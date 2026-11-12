import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/presentation/screens/home_screen.dart';
import 'package:patient_health/presentation/screens/patient_form_screen.dart';
import 'package:patient_health/presentation/screens/vitals_entry_screen.dart';

import 'helpers.dart';

Finder field(String label) => find.widgetWithText(TextField, label);

void main() {
  group('HomeScreen', () {
    appTest('shows empty state', (tester) async {
      await pumpScreen(tester, const HomeScreen());
      await settleDb(tester);
      expect(find.textContaining('No patients yet'), findsOneWidget);
    });

    appTest('lists patients and filters by search', (tester) async {
      await pumpScreen(tester, const HomeScreen(), patients: [patient(), patient(id: 'p2', medicalId: 'MRN-002').copyWith(firstName: 'Bob', lastName: 'Stone')]);
      await settleDb(tester);
      expect(find.text('Anna Lee'), findsOneWidget);
      expect(find.text('Bob Stone'), findsOneWidget);
      await tester.enterText(find.byType(SearchBar), 'stone');
      await tester.pumpAndSettle();
      expect(find.text('Anna Lee'), findsNothing);
      expect(find.text('Bob Stone'), findsOneWidget);
      await tester.enterText(find.byType(SearchBar), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('No patients match your search.'), findsOneWidget);
    });
  });

  group('PatientFormScreen', () {
    appTest('empty form shows required errors and does not save', (tester) async {
      final h = await pumpScreen(tester, const PatientFormScreen());
      await tester.tap(find.widgetWithText(FilledButton, 'Save patient'));
      await tester.pumpAndSettle();
      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);
      expect(find.text('Medical ID is required'), findsOneWidget);
      expect(find.text('Date of birth is required'), findsOneWidget);
      expect(await tester.runAsync(() => h.db.watchPatients().first), isEmpty);
    });

    appTest('exam type dropdown offers the six required options', (tester) async {
      await pumpScreen(tester, const PatientFormScreen());
      await tester.scrollUntilVisible(find.text('Routine checkup'), 300, scrollable: find.byType(Scrollable).first);
      await tester.tap(find.text('Routine checkup'));
      await tester.pumpAndSettle();
      for (final label in ['Routine checkup', 'Emergency', 'Follow-up', 'Consultation', 'Diagnostic', 'Preventive']) {
        expect(find.text(label), findsWidgets, reason: label);
      }
    });

    appTest('saves a valid patient', (tester) async {
      final h = await pumpScreen(tester, const PatientFormScreen());
      await tester.enterText(field('First name'), 'Maya');
      await tester.enterText(field('Last name'), 'Patel');
      await tester.enterText(field('Medical ID'), 'MRN-777');
      await tester.tap(find.text('Select date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save patient'));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pumpAndSettle();
      final saved = await tester.runAsync(() => h.db.watchPatients().first);
      expect(saved!.single.medicalId, 'MRN-777');
      expect(find.text('home'), findsOneWidget); // popped back
    });

    appTest('duplicate medical id shows an error and keeps the form open', (tester) async {
      await pumpScreen(tester, const PatientFormScreen(), patients: [patient()]);
      await tester.enterText(field('First name'), 'Maya');
      await tester.enterText(field('Last name'), 'Patel');
      await tester.enterText(field('Medical ID'), 'MRN-001');
      await tester.tap(find.text('Select date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save patient'));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pumpAndSettle();
      expect(find.text('A patient with this medical ID already exists.'), findsOneWidget);
      expect(find.text('home'), findsNothing);
    });

    appTest('invalid email and phone are flagged live', (tester) async {
      await pumpScreen(tester, const PatientFormScreen());
      await tester.enterText(field('Email (optional)'), 'nope');
      await tester.enterText(field('Phone (optional)'), '12');
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(find.text('Phone number must have 7–15 digits'), findsOneWidget);
    });
  });

  group('VitalsEntryScreen', () {
    appTest('out-of-range value is rejected with the allowed range', (tester) async {
      await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await tester.enterText(field('Heart rate (bpm)'), '300');
      await tester.pumpAndSettle();
      expect(find.text('Heart Rate must be between 20 and 250 bpm'), findsOneWidget);
    });

    appTest('abnormal but valid value gets a non-colour indicator', (tester) async {
      await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await tester.enterText(field('Heart rate (bpm)'), '130');
      await tester.pumpAndSettle();
      expect(find.text('⚠ Outside normal range'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      await tester.enterText(field('Heart rate (bpm)'), '72');
      await tester.pumpAndSettle();
      expect(find.text('⚠ Outside normal range'), findsNothing);
    });

    appTest('MAP is calculated live and diastolic must be below systolic', (tester) async {
      await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await tester.enterText(field('Systolic (mmHg)'), '120');
      await tester.enterText(field('Diastolic (mmHg)'), '80');
      await tester.pumpAndSettle();
      expect(find.text('MAP (calculated): 93.3 mmHg'), findsOneWidget);
      await tester.enterText(field('Diastolic (mmHg)'), '130');
      await tester.pumpAndSettle();
      expect(find.text('Diastolic must be lower than systolic'), findsOneWidget);
      expect(find.text('MAP (calculated): – '), findsNothing);
    });

    appTest('saving with nothing entered is refused', (tester) async {
      await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await tester.tap(find.widgetWithText(FilledButton, 'Save vitals'));
      await tester.pumpAndSettle();
      expect(find.text('Enter at least one measurement'), findsOneWidget);
    });

    appTest('converts °F and lbs to canonical units on save', (tester) async {
      final h = await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await tester.tap(find.text('Temperature °F'));
      await tester.tap(find.text('Weight lbs'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Temperature (°F)'), '98.6');
      await tester.enterText(field('Weight (lbs)'), '154');
      await tester.enterText(field('Systolic (mmHg)'), '118');
      await tester.enterText(field('Diastolic (mmHg)'), '76');
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save vitals'));
      await tester.tap(find.widgetWithText(FilledButton, 'Save vitals'));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pumpAndSettle();
      final v = (await tester.runAsync(() => h.db.allVitals('p1')))!.single;
      expect(v.temperatureC, closeTo(37.0, 1e-9));
      expect(v.weightKg, closeTo(69.85, 0.01));
      expect((v.systolic, v.diastolic), (118, 76));
    });

    appTest('height in ft/in is stored as centimetres', (tester) async {
      final h = await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await tester.tap(find.text('Height ft/in'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Feet'), '5');
      await tester.enterText(field('Inches'), '10');
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save vitals'));
      await tester.tap(find.widgetWithText(FilledButton, 'Save vitals'));
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pumpAndSettle();
      expect((await tester.runAsync(() => h.db.allVitals('p1')))!.single.heightCm, closeTo(177.8, 1e-9));
    });

    appTest('meets tap-target and label accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(tester, const VitalsEntryScreen(patientId: 'p1'), patients: [patient()]);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
