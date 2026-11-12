import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/domain/enums.dart';
import 'package:patient_health/domain/validation_service.dart';

void main() {
  group('names', () {
    test('accepts letters, spaces, hyphens, apostrophes', () {
      for (final n in ['Anna', "O'Brien", 'Mary-Jane', 'Anne Marie', 'José']) {
        expect(ValidationService.validateName(n, 'First name').isValid, isTrue, reason: n);
      }
    });
    test('rejects empty, digits, symbols, over 50 chars', () {
      expect(ValidationService.validateName('  ', 'First name').error, 'First name is required');
      expect(ValidationService.validateName('Ann3', 'Last name').error, 'Last name contains invalid characters');
      expect(ValidationService.validateName('A@B', 'Last name').isValid, isFalse);
      expect(ValidationService.validateName('a' * 51, 'Last name').error, 'Last name must be 50 characters or fewer');
      expect(ValidationService.validateName('a' * 50, 'Last name').isValid, isTrue);
    });
  });

  group('date of birth', () {
    final today = DateTime(2026, 6, 15);
    test('null is required', () => expect(ValidationService.validateDateOfBirth(null, today: today).error, 'Date of birth is required'));
    test('today is valid, tomorrow is not', () {
      expect(ValidationService.validateDateOfBirth(today, today: today).isValid, isTrue);
      expect(ValidationService.validateDateOfBirth(DateTime(2026, 6, 16), today: today).error, 'Date of birth cannot be in the future');
    });
    test('150 year limit', () {
      expect(ValidationService.validateDateOfBirth(DateTime(1876, 6, 15), today: today).isValid, isTrue);
      expect(ValidationService.validateDateOfBirth(DateTime(1876, 6, 14), today: today).error, 'Date of birth is too far in the past');
    });
    test('time of day is ignored', () {
      expect(ValidationService.validateDateOfBirth(DateTime(2026, 6, 15, 23, 59), today: today).isValid, isTrue);
    });
  });

  group('medical id', () {
    test('valid forms', () {
      for (final id in ['ABC', 'MRN-12345', 'a1b2c3', '1' * 20]) {
        expect(ValidationService.validateMedicalId(id).isValid, isTrue, reason: id);
      }
    });
    test('invalid forms', () {
      expect(ValidationService.validateMedicalId('').error, 'Medical ID is required');
      expect(ValidationService.validateMedicalId('ab').error, 'Medical ID must be 3–20 characters');
      expect(ValidationService.validateMedicalId('1' * 21).isValid, isFalse);
      expect(ValidationService.validateMedicalId('AB C').error, contains('letters, numbers and hyphens'));
      expect(ValidationService.validateMedicalId('AB_C').isValid, isFalse);
    });
  });

  group('phone and email', () {
    test('phone is optional', () => expect(ValidationService.validatePhone('').isValid, isTrue));
    test('phone digits 7-15', () {
      expect(ValidationService.validatePhone('+1 (555) 123-4567').isValid, isTrue);
      expect(ValidationService.validatePhone('123456').error, 'Phone number must have 7–15 digits');
      expect(ValidationService.validatePhone('1' * 16).isValid, isFalse);
      expect(ValidationService.validatePhone('555-ABC-1234').error, 'Phone number contains invalid characters');
    });
    test('email', () {
      expect(ValidationService.validateEmail('').isValid, isTrue);
      expect(ValidationService.validateEmail('a.b+c@example.co').isValid, isTrue);
      for (final bad in ['plain', 'a@b', '@x.com', 'a@b.c', 'a b@x.com']) {
        expect(ValidationService.validateEmail(bad).isValid, isFalse, reason: bad);
      }
    });
  });

  group('vitals', () {
    test('boundaries are inclusive for every type', () {
      for (final t in VitalType.values) {
        expect(ValidationService.validateVital(t.validMin, t).isValid, isTrue, reason: '${t.name} min');
        expect(ValidationService.validateVital(t.validMax, t).isValid, isTrue, reason: '${t.name} max');
        expect(ValidationService.validateVital(t.validMin - 0.1, t).isValid, isFalse, reason: '${t.name} below');
        expect(ValidationService.validateVital(t.validMax + 0.1, t).isValid, isFalse, reason: '${t.name} above');
      }
    });
    test('non-finite is rejected', () {
      expect(ValidationService.validateVital(double.nan, VitalType.heartRate).isValid, isFalse);
      expect(ValidationService.validateVital(double.infinity, VitalType.heartRate).isValid, isFalse);
    });
    test('error message names the range', () {
      expect(ValidationService.validateVital(300, VitalType.systolic).error, 'Systolic BP must be between 50 and 260 mmHg');
      expect(ValidationService.validateVital(50, VitalType.temperature).error, 'Temperature must be between 30 and 45 °C');
    });
    test('blood pressure pair', () {
      expect(ValidationService.validateBloodPressurePair(120, 80).isValid, isTrue);
      expect(ValidationService.validateBloodPressurePair(80, 80).error, 'Diastolic must be lower than systolic');
      expect(ValidationService.validateBloodPressurePair(70, 90).isValid, isFalse);
    });
    test('recorded-at allows past and 60 s skew, not future', () {
      final now = DateTime(2026, 6, 15, 12);
      expect(ValidationService.validateRecordedAt(now.subtract(const Duration(days: 3)), now: now).isValid, isTrue);
      expect(ValidationService.validateRecordedAt(now.add(const Duration(seconds: 59)), now: now).isValid, isTrue);
      expect(ValidationService.validateRecordedAt(now.add(const Duration(minutes: 5)), now: now).error, 'Measurement date cannot be in the future');
    });
  });

  group('abnormal', () {
    test('normal range edges are normal, just outside is abnormal', () {
      expect(ValidationService.isAbnormal(60, VitalType.heartRate), isFalse);
      expect(ValidationService.isAbnormal(100, VitalType.heartRate), isFalse);
      expect(ValidationService.isAbnormal(59.9, VitalType.heartRate), isTrue);
      expect(ValidationService.isAbnormal(100.1, VitalType.heartRate), isTrue);
      expect(ValidationService.isAbnormal(94, VitalType.spo2), isTrue);
      expect(ValidationService.isAbnormal(37.3, VitalType.temperature), isTrue);
      expect(ValidationService.isAbnormal(4, VitalType.painLevel), isTrue);
    });
    test('height and weight are never abnormal', () {
      expect(ValidationService.isAbnormal(1, VitalType.height), isFalse);
      expect(ValidationService.isAbnormal(500, VitalType.weight), isFalse);
    });
  });
}
