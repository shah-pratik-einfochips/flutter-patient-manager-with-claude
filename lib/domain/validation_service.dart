import 'enums.dart';

/// Outcome of a validation: [error] is null when the value is valid.
class ValidationResult {
  const ValidationResult._(this.error);
  const ValidationResult.valid() : this._(null);
  const ValidationResult.invalid(String message) : this._(message);

  final String? error;
  bool get isValid => error == null;
}

abstract final class ValidationService {
  static final _email = RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$',
  );
  static final _nameChars = RegExp(r"^[\p{L} \-']+$", unicode: true);
  static final _idChars = RegExp(r'^[A-Za-z0-9\-]+$');
  static final _phoneChars = RegExp(r'^[0-9+\-() ]+$');

  /// Required person name: letters, spaces, hyphens, apostrophes; max 50 chars.
  static ValidationResult validateName(String value, String field) {
    final v = value.trim();
    if (v.isEmpty) return ValidationResult.invalid('$field is required');
    if (v.length > 50) {
      return ValidationResult.invalid('$field must be 50 characters or fewer');
    }
    if (!_nameChars.hasMatch(v)) {
      return ValidationResult.invalid('$field contains invalid characters');
    }
    return const ValidationResult.valid();
  }

  /// DOB must not be in the future nor more than 150 years ago.
  static ValidationResult validateDateOfBirth(
    DateTime? dob, {
    DateTime? today,
  }) {
    if (dob == null)
      return const ValidationResult.invalid('Date of birth is required');
    final now = today ?? DateTime.now();
    final d = DateTime(dob.year, dob.month, dob.day);
    final t = DateTime(now.year, now.month, now.day);
    if (d.isAfter(t)) {
      return const ValidationResult.invalid(
        'Date of birth cannot be in the future',
      );
    }
    if (d.isBefore(DateTime(t.year - 150, t.month, t.day))) {
      return const ValidationResult.invalid(
        'Date of birth is too far in the past',
      );
    }
    return const ValidationResult.valid();
  }

  /// Mandatory medical ID: 3-20 letters, digits or hyphens.
  static ValidationResult validateMedicalId(String value) {
    final v = value.trim();
    if (v.isEmpty)
      return const ValidationResult.invalid('Medical ID is required');
    if (v.length < 3 || v.length > 20) {
      return const ValidationResult.invalid(
        'Medical ID must be 3–20 characters',
      );
    }
    if (!_idChars.hasMatch(v)) {
      return const ValidationResult.invalid(
        'Medical ID may only contain letters, numbers and hyphens',
      );
    }
    return const ValidationResult.valid();
  }

  /// Optional phone: 7-15 digits with optional + - ( ) and spaces.
  static ValidationResult validatePhone(String value) {
    final v = value.trim();
    if (v.isEmpty) return const ValidationResult.valid();
    if (!_phoneChars.hasMatch(v)) {
      return const ValidationResult.invalid(
        'Phone number contains invalid characters',
      );
    }
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '').length;
    return digits >= 7 && digits <= 15
        ? const ValidationResult.valid()
        : const ValidationResult.invalid('Phone number must have 7–15 digits');
  }

  /// Optional email using a pragmatic pattern.
  static ValidationResult validateEmail(String value) {
    final v = value.trim();
    return v.isEmpty || _email.hasMatch(v)
        ? const ValidationResult.valid()
        : const ValidationResult.invalid('Enter a valid email address');
  }

  /// Vital value (canonical units) must be finite and inside the hard limits.
  static ValidationResult validateVital(double value, VitalType type) {
    if (value.isFinite && value >= type.validMin && value <= type.validMax) {
      return const ValidationResult.valid();
    }
    return ValidationResult.invalid(
      '${type.title} must be between ${_fmt(type.validMin)} and ${_fmt(type.validMax)} ${type.unit}',
    );
  }

  static ValidationResult validateBloodPressurePair(
    double systolic,
    double diastolic,
  ) => diastolic < systolic
      ? const ValidationResult.valid()
      : const ValidationResult.invalid('Diastolic must be lower than systolic');

  /// Measurement time may be in the past but not in the future (60 s clock-skew allowance).
  static ValidationResult validateRecordedAt(DateTime at, {DateTime? now}) =>
      !at.isAfter((now ?? DateTime.now()).add(const Duration(seconds: 60)))
      ? const ValidationResult.valid()
      : const ValidationResult.invalid(
          'Measurement date cannot be in the future',
        );

  /// True when the value is outside the type's normal range
  /// (types without a range are never abnormal).
  static bool isAbnormal(double value, VitalType type) {
    final lo = type.normalMin, hi = type.normalMax;
    if (lo == null || hi == null) return false;
    return value < lo || value > hi;
  }

  static String _fmt(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toString();
}
