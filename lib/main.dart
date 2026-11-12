import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/background_sync.dart';
import 'data/database.dart';
import 'data/key_provider.dart';
import 'debug/demo_data.dart';
import 'presentation/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final secureStore = SecureStore();
  final db = await openEncryptedDatabase(
    await secureStore.databasePassphrase(),
  );
  if (kDebugMode && seedDemoData) await seedDemo(db);
  final prefs = await SharedPreferences.getInstance();
  await BackgroundSync.register();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStoreProvider.overrideWithValue(secureStore),
      ],
      child: const PatientHealthApp(),
    ),
  );
}
