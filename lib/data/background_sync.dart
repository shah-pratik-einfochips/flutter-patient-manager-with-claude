import 'dart:io';

import 'package:workmanager/workmanager.dart';

import '../core/environment.dart';
import 'database.dart';
import 'fhir_client.dart';
import 'key_provider.dart';
import 'patient_repository.dart';

/// Task name shared with the native iOS registration (see Info.plist / AppDelegate).
const syncTaskName = 'com.einfochips.patientHealth.sync';

/// Entry point run by the OS in a background isolate. It opens its own database
/// connection, uploads consented patients and closes it again.
@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final store = SecureStore();
    final db = await openEncryptedDatabase(await store.databasePassphrase());
    try {
      final env = AppEnvironment.values.firstWhere(
        (e) => e.name == (inputData?['env'] as String?),
        orElse: () => AppEnvironment.development,
      );
      final repo = PatientRepository(
        db,
        FhirClient(baseUrl: env.baseUrl, tokenProvider: store.readToken),
      );
      final failures = await repo.pushAllConsented();
      return failures == 0; // false asks the OS to retry later
    } finally {
      await db.close();
    }
  });
}

abstract final class BackgroundSync {
  /// Requests a best-effort sync about every 6 hours when a network is available.
  /// Android uses WorkManager; iOS uses BGTaskScheduler, which decides when it runs.
  static Future<void> register({
    AppEnvironment env = AppEnvironment.development,
  }) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    await Workmanager().initialize(backgroundDispatcher);
    await Workmanager().registerPeriodicTask(
      syncTaskName,
      syncTaskName,
      frequency: const Duration(hours: 6),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      inputData: {'env': env.name},
    );
  }
}
