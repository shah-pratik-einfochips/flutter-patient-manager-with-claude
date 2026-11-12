import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/environment.dart';
import '../data/database.dart';
import '../data/fhir_client.dart';
import '../data/key_provider.dart';
import '../data/patient_repository.dart';
import '../domain/models.dart';

/// Overridden in `main()` once the encrypted database is open.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);
final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

class EnvironmentNotifier extends Notifier<AppEnvironment> {
  static const _key = 'environment';

  @override
  AppEnvironment build() {
    final saved = ref.watch(sharedPreferencesProvider).getString(_key);
    return AppEnvironment.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => AppEnvironment.development,
    );
  }

  Future<void> select(AppEnvironment env) async {
    state = env;
    await ref.read(sharedPreferencesProvider).setString(_key, env.name);
  }
}

final environmentProvider =
    NotifierProvider<EnvironmentNotifier, AppEnvironment>(
      EnvironmentNotifier.new,
    );

final fhirApiProvider = Provider<FhirApi>((ref) {
  final env = ref.watch(environmentProvider);
  final store = ref.watch(secureStoreProvider);
  return FhirClient(baseUrl: env.baseUrl, tokenProvider: store.readToken);
});

final repositoryProvider = Provider<PatientRepository>(
  (ref) => PatientRepository(
    ref.watch(databaseProvider),
    ref.watch(fhirApiProvider),
  ),
);

final patientsProvider = StreamProvider<List<Patient>>(
  (ref) => ref.watch(repositoryProvider).watchPatients(),
);
final patientProvider = StreamProvider.family<Patient?, String>(
  (ref, id) => ref.watch(repositoryProvider).watchPatient(id),
);
final vitalsProvider = StreamProvider.family<List<VitalRecord>, String>(
  (ref, id) => ref.watch(repositoryProvider).watchVitals(id),
);
final auditProvider = StreamProvider<List<AuditEntry>>(
  (ref) => ref.watch(repositoryProvider).watchAudit(),
);
