import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patient_health/app.dart';
import 'package:patient_health/data/database.dart';
import 'package:patient_health/presentation/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end flow on a real device/simulator: register a patient, record vitals,
/// see them on the dashboard in both chart and table views.
///
/// Uses an in-memory database so the run never touches (or depends on) the encrypted
/// on-device store, and never reaches the network.
/// Types into the labelled field, scrolling it into view first. Forms are lazy lists, so on
/// small screens (or with the keyboard open) a field may not be built until scrolled to.
Future<void> enter(WidgetTester tester, String label, String text) async {
  final field = find.widgetWithText(TextField, label);
  if (field.evaluate().isEmpty) {
    final scrollable = find.byType(Scrollable).first;
    try {
      await tester.scrollUntilVisible(field, -200, scrollable: scrollable);
    } on StateError {
      await tester.scrollUntilVisible(field, 200, scrollable: scrollable);
    }
  }
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
}

/// Scrolls the button fully into view (not just partly on screen), then taps it.
Future<void> tapButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(FilledButton, label);
  await tester.scrollUntilVisible(
    button,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('register patient → record vitals → dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.inMemory();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const PatientHealthApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Empty state.
    expect(find.textContaining('No patients yet'), findsOneWidget);

    // Register a patient.
    await tester.tap(find.text('Add patient'));
    await tester.pumpAndSettle();

    await enter(tester, 'Medical ID', 'MRN-E2E-1');
    await enter(tester, 'First name', 'Maya');
    await enter(tester, 'Last name', 'Patel');
    await tester.scrollUntilVisible(
      find.text('Select date'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tapButton(tester, 'Save patient');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Back on the list, the new patient is shown.
    expect(find.text('Maya Patel'), findsOneWidget);

    // Open the patient and record vitals, one of them abnormal.
    await tester.tap(find.text('Maya Patel'));
    await tester.pumpAndSettle();
    expect(find.text('No vitals recorded yet.'), findsOneWidget);
    await tester.tap(find.text('Record vitals'));
    await tester.pumpAndSettle();
    await enter(tester, 'Heart rate (bpm)', '130');
    await enter(tester, 'Systolic (mmHg)', '120');
    await enter(tester, 'Diastolic (mmHg)', '80');
    await tester.pumpAndSettle();
    expect(find.text('⚠ Outside normal range'), findsOneWidget);
    expect(find.text('MAP (calculated): 93.3 mmHg'), findsOneWidget);
    await tapButton(tester, 'Save vitals');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('No vitals recorded yet.'), findsNothing);

    // Dashboard: chart view, then table view with a text (non-colour) abnormal marker.
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Vitals dashboard'), findsOneWidget);
    await tester.tap(find.text('Table'));
    await tester.pumpAndSettle();
    // The dashboard is a lazy list, so scroll each expectation into existence on small screens.
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.textContaining('Abnormal'),
      200,
      scrollable: scrollable,
    );
    expect(find.textContaining('Abnormal'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Export PDF'),
      200,
      scrollable: scrollable,
    );
    expect(find.text('Export CSV'), findsOneWidget);
    expect(find.text('Export PDF'), findsOneWidget);

    // Unmount before the in-memory DB goes away so drift stream timers are cleaned up.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
