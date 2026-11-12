import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/domain/dashboard_calculator.dart';
import 'package:patient_health/domain/enums.dart';
import 'package:patient_health/domain/models.dart';
import 'package:patient_health/domain/unit_conversion.dart';

void main() {
  group('conversions', () {
    test('height', () {
      expect(UnitConversion.cm(5, 10), closeTo(177.8, 1e-9));
      expect(UnitConversion.cm(0, 0), 0);
      final (f, i) = UnitConversion.feetAndInches(177.8);
      expect((f, i), (5, 10.0));
    });
    test('inches carry into the next foot', () {
      // 5 ft 11.97 in rounds to 12.0 -> 6 ft 0 in
      final (f, i) = UnitConversion.feetAndInches(182.87);
      expect((f, i), (6, 0.0));
    });
    test('weight round trip', () {
      expect(UnitConversion.kg(220.462262185), closeTo(100, 1e-6));
      expect(UnitConversion.lbs(UnitConversion.kg(154)), closeTo(154, 1e-9));
    });
    test('temperature', () {
      expect(UnitConversion.celsius(98.6), closeTo(37, 1e-9));
      expect(UnitConversion.fahrenheit(37), closeTo(98.6, 1e-9));
      expect(UnitConversion.celsius(32), 0);
      expect(UnitConversion.celsius(-40), closeTo(-40, 1e-9));
    });
    test('MAP = (SBP + 2 DBP) / 3 to one decimal', () {
      expect(UnitConversion.meanArterialPressure(120, 80), 93.3);
      expect(UnitConversion.meanArterialPressure(140, 90), 106.7);
      expect(UnitConversion.meanArterialPressure(90, 60), 70.0);
    });
  });

  group('roundTo', () {
    test('half rounds away from zero', () {
      expect(0.25.roundTo(1), 0.3);
      expect(2.5.roundTo(0), 3);
      expect((-2.5).roundTo(0), -3);
      expect(0.0.roundTo(1), 0);
    });
  });

  group('VitalRecord', () {
    test('MAP is derived only when both pressures exist', () {
      expect(VitalRecord(patientId: 'p', recordedAt: DateTime.now(), systolic: 120, diastolic: 80).map, 93.3);
      expect(VitalRecord(patientId: 'p', recordedAt: DateTime.now(), systolic: 120).map, isNull);
    });
    test('value() maps each type', () {
      final r = VitalRecord(patientId: 'p', recordedAt: DateTime.now(), systolic: 120, diastolic: 80, heartRate: 70, heightCm: 170, weightKg: 65, temperatureC: 36.6, respiratoryRate: 16, spo2: 98, painLevel: 2);
      expect([for (final t in VitalType.values) r.value(t)], [120, 80, 93.3, 70, 170, 65, 36.6, 16, 98, 2]);
    });
  });

  group('DashboardCalculator', () {
    final now = DateTime(2026, 6, 15, 12);
    VitalRecord rec(int daysAgo, {double? hr}) => VitalRecord(patientId: 'p', recordedAt: now.subtract(Duration(days: daysAgo)), heartRate: hr);

    test('recent keeps 7 days, drops older and future, sorts oldest first', () {
      final out = DashboardCalculator.recent([rec(1), rec(8), rec(6), VitalRecord(patientId: 'p', recordedAt: now.add(const Duration(hours: 1)))], now: now);
      expect(out.length, 2);
      expect(out.first.recordedAt.isBefore(out.last.recordedAt), isTrue);
    });
    test('stats', () {
      final records = [rec(3, hr: 58), rec(2, hr: 72), rec(1, hr: 130)];
      final s = DashboardCalculator.stats(records, VitalType.heartRate)!;
      expect((s.min, s.max, s.average, s.latest, s.count), (58.0, 130.0, 86.7, 130.0, 3));
    });
    test('stats null when no readings', () => expect(DashboardCalculator.stats([rec(1)], VitalType.heartRate), isNull));
    test('points flag abnormal values', () {
      final pts = DashboardCalculator.points([rec(2, hr: 58), rec(1, hr: 72)], VitalType.heartRate);
      expect(pts.map((p) => p.abnormal), [true, false]);
    });
  });
}
