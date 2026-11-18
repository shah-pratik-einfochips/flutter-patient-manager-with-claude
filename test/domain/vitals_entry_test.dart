import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/domain/enums.dart';
import 'package:patient_health/domain/models.dart';
import 'package:patient_health/domain/vitals_entry.dart';

void main() {
  final when = DateTime(2026, 1, 1, 9);
  VitalsEntry entry(
    Map<VitalsField, String> text, {
    HeightUnit height = HeightUnit.cm,
    WeightUnit weight = WeightUnit.kg,
    TemperatureUnit temp = TemperatureUnit.celsius,
  }) => VitalsEntry(
    recordedAt: when,
    text: text,
    heightUnit: height,
    weightUnit: weight,
    temperatureUnit: temp,
  );

  group('VitalsEntry', () {
    test('empty form has no value and no error', () {
      final e = entry({});
      expect(e.hasAnyValue, isFalse);
      expect(e.blockingError, isNull);
    });

    test('converts to canonical units', () {
      final e = entry(
        {
          VitalsField.heightFeet: '5',
          VitalsField.heightInches: '10',
          VitalsField.weight: '154',
          VitalsField.temperature: '98.6',
        },
        height: HeightUnit.ftIn,
        weight: WeightUnit.lbs,
        temp: TemperatureUnit.fahrenheit,
      );
      expect(e.heightCm, closeTo(177.8, 0.01));
      expect(e.weightKg, closeTo(69.85, 0.01));
      expect(e.temperatureC, closeTo(37, 0.01));
    });

    test('accepts a comma as decimal separator', () {
      expect(entry({VitalsField.temperature: '36,6'}).temperatureC, 36.6);
    });

    test('flags unparseable and out-of-range values', () {
      expect(
        entry({VitalsField.heartRate: '.'}).error(VitalsField.heartRate),
        'Enter a number',
      );
      expect(
        entry({VitalsField.heartRate: '400'}).error(VitalsField.heartRate),
        contains('between'),
      );
    });

    test('inches alone are checked as the combined height on save', () {
      final e = entry({VitalsField.heightInches: '5'}, height: HeightUnit.ftIn);
      expect(e.error(VitalsField.heightInches), isNull);
      expect(e.blockingError, contains('Height'));
    });

    test('blood pressure needs both values, diastolic below systolic', () {
      expect(
        entry({VitalsField.systolic: '120'}).bloodPressurePairError,
        'Enter both systolic and diastolic',
      );
      expect(
        entry({VitalsField.systolic: '80', VitalsField.diastolic: '90'})
            .bloodPressurePairError,
        isNotNull,
      );
    });

    test('MAP only once diastolic is below systolic', () {
      final ok = entry({
        VitalsField.systolic: '120',
        VitalsField.diastolic: '80',
      });
      expect(ok.map, 93.3);
      expect(ok.isMapAbnormal, isFalse);
      expect(
        entry({VitalsField.systolic: '80', VitalsField.diastolic: '90'}).map,
        isNull,
      );
    });

    test('abnormal only for valid values outside the normal range', () {
      expect(
        entry({VitalsField.heartRate: '130'}).isAbnormal(VitalsField.heartRate),
        isTrue,
      );
      expect(
        entry({VitalsField.heartRate: '72'}).isAbnormal(VitalsField.heartRate),
        isFalse,
      );
      expect(
        entry({VitalsField.heartRate: '400'}).isAbnormal(VitalsField.heartRate),
        isFalse,
      );
      expect(
        entry({VitalsField.heightCm: '250'}).isAbnormal(VitalsField.heightCm),
        isFalse,
      );
    });

    test('builds the record in canonical units', () {
      final r = VitalsEntry(
        recordedAt: when,
        text: {VitalsField.heartRate: '72', VitalsField.weight: '154'},
        weightUnit: WeightUnit.lbs,
        symptoms: '  cough ',
      ).toRecord('p1');
      expect((r.patientId, r.recordedAt, r.heartRate), ('p1', when, 72.0));
      expect(r.weightKg, closeTo(69.85, 0.01));
      expect(r.symptoms, 'cough');
      expect(r.systolic, isNull);
    });
  });

  group('Patient.withConsent', () {
    final base = Patient(
      medicalId: 'M1',
      firstName: 'A',
      lastName: 'B',
      dob: DateTime(1990),
    );
    final now = DateTime(2026, 2, 3);

    test('stamps the time when consent is granted', () {
      expect(base.withConsent(true, now: now).consentAt, now);
    });

    test('keeps the original time while consent stays granted', () {
      final given = base.withConsent(true, now: DateTime(2025));
      expect(given.withConsent(true, now: now).consentAt, DateTime(2025));
    });

    test('clears the time when consent is revoked', () {
      final revoked = base.withConsent(true, now: now).withConsent(false);
      expect((revoked.consentGiven, revoked.consentAt), (false, null));
    });
  });

  group('VitalRecord.withValue', () {
    test('sets the matching field and rejects derived MAP', () {
      final r = VitalRecord(patientId: 'p', recordedAt: when);
      expect(r.withValue(VitalType.spo2, 97).spo2, 97);
      expect(() => r.withValue(VitalType.map, 90), throwsArgumentError);
    });
  });
}
