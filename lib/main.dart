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
  // Independent startup work runs in parallel; only the DB needs the passphrase.
  final (db, prefs) = await (
    secureStore.databasePassphrase().then(openEncryptedDatabase),
    SharedPreferences.getInstance(),
  ).wait;
  if (kDebugMode && seedDemoData) await seedDemo(db);
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
