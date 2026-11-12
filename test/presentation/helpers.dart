import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_health/app.dart';
import 'package:patient_health/data/database.dart';
import 'package:patient_health/domain/models.dart';
import 'package:patient_health/presentation/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/fhir_test.dart' show samplePatient;
import '../data/repository_test.dart' show MockFhir;

class Harness {
  Harness(this.db, this.fhir, this.router);
  final AppDatabase db;
  final MockFhir fhir;
  final GoRouter router;
}

/// Pumps [screen] on top of a home route so `context.pop()` works, using an in-memory DB.
Future<Harness> pumpScreen(WidgetTester tester, Widget screen, {List<Patient> patients = const [], List<VitalRecord> vitals = const []}) async {
  // Tall surface so lazily-built list items are all on screen.
  tester.view.physicalSize = const Size(800, 3600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase.inMemory();
  final fhir = MockFhir();
  await tester.runAsync(() async {
    for (final p in patients) {
      await db.upsertPatient(p);
    }
    // Seed before any widget subscribes: drift stream queries created in the fake-async
    // zone can otherwise block writes made from runAsync.
    for (final v in vitals) {
      await db.insertVital(v);
    }
  });
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, _) => const Scaffold(body: Text('home'))),
    GoRoute(path: '/screen', builder: (_, _) => screen),
  ]);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: Consumer(
      builder: (_, ref, _) => MaterialApp.router(theme: buildTheme(Brightness.light), routerConfig: router),
    ),
  ));
  router.push('/screen');
  await tester.pumpAndSettle();
  return Harness(db, fhir, router);
}

/// Lets real async work (drift streams and queries) complete, then rebuilds.
Future<void> settleDb(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 150)));
  // Fixed pumps instead of pumpAndSettle: charts animate and pumpAndSettle can spin for a long time.
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 400));
  }
}

Patient patient({String id = 'p1', String medicalId = 'MRN-001'}) => samplePatient(id: id).copyWith(medicalId: medicalId);


/// Like testWidgets, but tears the tree and database down inside the test body so
/// drift's stream-cleanup timers are gone before the framework checks for pending timers.
void appTest(String name, Future<void> Function(WidgetTester tester) body) {
  testWidgets(name, (tester) async {
    await body(tester);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump(const Duration(seconds: 1));
  });
}
