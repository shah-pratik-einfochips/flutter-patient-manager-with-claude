import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/core/environment.dart';
import 'package:patient_health/domain/models.dart';
import 'package:patient_health/presentation/screens/dashboard_screen.dart';
import 'package:patient_health/presentation/screens/patient_detail_screen.dart';
import 'package:patient_health/presentation/screens/settings_screen.dart';

import 'helpers.dart';

List<VitalRecord> seed() {
  final now = DateTime.now();
  const hr = [72.0, 58.0, 130.0];
  return [
    for (var i = 0; i < 3; i++)
      VitalRecord(
        patientId: 'p1',
        recordedAt: now.subtract(Duration(days: 2 - i)),
        systolic: 120,
        diastolic: 80,
        heartRate: hr[i],
      ),
    // Older than 7 days: must not appear in stats.
    VitalRecord(
      patientId: 'p1',
      recordedAt: now.subtract(const Duration(days: 10)),
      heartRate: 200,
    ),
  ];
}

void main() {
  group('DashboardScreen', () {
    appTest('shows 7-day stats and a text summary of the chart', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(
        tester,
        const DashboardScreen(patientId: 'p1'),
        patients: [patient()],
        vitals: seed(),
      );
      await settleDb(tester);
      expect(find.text('Heart Rate (bpm)'), findsOneWidget);
      expect(find.text('Normal 60–100 bpm'), findsOneWidget);
      // latest 130 is abnormal -> ⚠, average (72+58+130)/3 = 86.7, 3 readings (the 10-day-old one is excluded)
      expect(find.text('⚠ 130.0'), findsOneWidget);
      expect(find.text('86.7'), findsOneWidget);
      expect(find.text('58.0'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          RegExp(r'Heart Rate chart, 3 readings .* 2 outside the normal range'),
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    appTest('table view marks abnormal rows with text, not only colour', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const DashboardScreen(patientId: 'p1'),
        patients: [patient()],
        vitals: seed(),
      );
      await settleDb(tester);
      await tester.tap(find.text('Table'));
      await tester.pumpAndSettle();
      expect(find.text('Abnormal'), findsNWidgets(2));
      expect(find.text('Normal'), findsOneWidget);
    });

    appTest('switching vital type updates the stats', (tester) async {
      await pumpScreen(
        tester,
        const DashboardScreen(patientId: 'p1'),
        patients: [patient()],
        vitals: seed(),
      );
      await settleDb(tester);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Systolic BP'));
      await tester.pumpAndSettle();
      expect(find.text('Systolic BP (mmHg)'), findsOneWidget);
      expect(find.text('120.0'), findsWidgets);
    });

    appTest('empty period shows a message and disables export', (tester) async {
      await pumpScreen(
        tester,
        const DashboardScreen(patientId: 'p1'),
        patients: [patient()],
      );
      await settleDb(tester);
      expect(
        find.text('No vitals recorded in the past 7 days.'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Export CSV'),
            )
            .onPressed,
        isNull,
      );
    });
  });

  group('PatientDetailScreen', () {
    appTest('shows demographics, consent state and recent vitals', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const PatientDetailScreen(patientId: 'p1'),
        patients: [
          patient().copyWith(
            consentGiven: true,
            consentAt: DateTime(2026, 1, 2),
          ),
        ],
        vitals: seed(),
      );
      await settleDb(tester);
      expect(find.text('Anna Lee'), findsOneWidget);
      expect(find.text('MRN-001'), findsOneWidget);
      expect(find.text('AB+'), findsOneWidget);
      expect(find.text('Given on Jan 2, 2026'), findsOneWidget);
      expect(find.text('Not uploaded'), findsOneWidget);
      expect(find.textContaining('HR 130.0⚠'), findsOneWidget);
    });

    appTest('uploading without consent reports why', (tester) async {
      await pumpScreen(
        tester,
        const PatientDetailScreen(patientId: 'p1'),
        patients: [patient()],
      );
      await settleDb(tester);
      expect(find.text('Not given - data is not uploaded'), findsOneWidget);
    });

    appTest('unknown patient shows not found', (tester) async {
      await pumpScreen(tester, const PatientDetailScreen(patientId: 'nope'));
      await settleDb(tester);
      expect(find.text('Patient not found.'), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    appTest('lists the three environments and persists the choice', (
      tester,
    ) async {
      await pumpScreen(tester, const SettingsScreen());
      await settleDb(tester);
      for (final e in AppEnvironment.values) {
        expect(find.text(e.title), findsOneWidget);
      }
      await tester.tap(find.text('Staging'));
      await tester.pumpAndSettle();
      expect(find.textContaining('synthetic data only'), findsOneWidget);
      expect(find.text(AppEnvironment.staging.baseUrl), findsOneWidget);
    });

    appTest('audit log is empty at first', (tester) async {
      await pumpScreen(tester, const SettingsScreen());
      await settleDb(tester);
      expect(find.text('No activity yet.'), findsOneWidget);
    });
  });
}
