import 'enums.dart';
import 'models.dart';
import 'unit_conversion.dart';
import 'validation_service.dart';

/// Numeric text fields of the vitals entry form, with the vital each one measures.
enum VitalsField {
  systolic(VitalType.systolic),
  diastolic(VitalType.diastolic),
  heartRate(VitalType.heartRate),
  heightCm(VitalType.height),
  heightFeet(VitalType.height),
  heightInches(VitalType.height),
  weight(VitalType.weight),
  temperature(VitalType.temperature),
  respiratoryRate(VitalType.respiratoryRate),
  spo2(VitalType.spo2),
  painLevel(VitalType.painLevel);

  const VitalsField(this.type);
  final VitalType type;
}

/// One vitals entry form's raw input and the rules that turn it into a [VitalRecord]:
/// parsing, unit conversion to canonical units, and validation.
/// Pure (no widgets), so the rules can be unit-tested directly.
class VitalsEntry {
  const VitalsEntry({
    required this.recordedAt,
    this.text = const {},
    this.heightUnit = HeightUnit.cm,
    this.weightUnit = WeightUnit.kg,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.symptoms = '',
  });

  final DateTime recordedAt;
  final Map<VitalsField, String> text;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
  final TemperatureUnit temperatureUnit;
  final String symptoms;

  bool has(VitalsField f) => (text[f] ?? '').trim().isNotEmpty;

  /// Parsed field value as typed (comma accepted as decimal separator), or null.
  double? number(VitalsField f) =>
      double.tryParse((text[f] ?? '').trim().replaceAll(',', '.'));

  // Canonical-unit values (null when empty or unparseable).
  double? get heightCm => switch (heightUnit) {
    HeightUnit.cm => number(VitalsField.heightCm),
    HeightUnit.ftIn =>
      has(VitalsField.heightFeet) || has(VitalsField.heightInches)
          ? UnitConversion.cm(
              number(VitalsField.heightFeet) ?? 0,
              number(VitalsField.heightInches) ?? 0,
            )
          : null,
  };

  double? get weightKg => switch (number(VitalsField.weight)) {
    null => null,
    final v => weightUnit == WeightUnit.kg ? v : UnitConversion.kg(v),
  };

  double? get temperatureC => switch (number(VitalsField.temperature)) {
    null => null,
    final v =>
      temperatureUnit == TemperatureUnit.celsius
          ? v
          : UnitConversion.celsius(v),
  };

  /// A field's value in canonical units; the height fields share the combined height.
  double? canonical(VitalsField f) => switch (f) {
    VitalsField.heightCm ||
    VitalsField.heightFeet ||
    VitalsField.heightInches => heightCm,
    VitalsField.weight => weightKg,
    VitalsField.temperature => temperatureC,
    _ => number(f),
  };

  /// Error shown on a field: unparseable text, or a value outside the hard limits.
  /// Inches are only checked for being a number; the combined height is checked on feet.
  String? error(VitalsField f) => f == VitalsField.heightInches
      ? (has(f) && number(f) == null ? 'Enter a number' : null)
      : _check(f, canonical(f));

  String? _check(VitalsField f, double? canonical) {
    if (!has(f)) return null;
    if (canonical == null) return 'Enter a number';
    return ValidationService.validateVital(canonical, f.type).error;
  }

  /// True when a field holds a valid value outside the normal range.
  bool isAbnormal(VitalsField f) {
    final v = canonical(f);
    return error(f) == null &&
        v != null &&
        ValidationService.isAbnormal(v, f.type);
  }

  String? get bloodPressurePairError {
    if (has(VitalsField.systolic) != has(VitalsField.diastolic)) {
      return 'Enter both systolic and diastolic';
    }
    final s = number(VitalsField.systolic), d = number(VitalsField.diastolic);
    return s != null && d != null
        ? ValidationService.validateBloodPressurePair(s, d).error
        : null;
  }

  /// Mean arterial pressure while typing; null until both pressures are in and diastolic < systolic.
  double? get map {
    final s = number(VitalsField.systolic), d = number(VitalsField.diastolic);
    return s != null && d != null && d < s
        ? UnitConversion.meanArterialPressure(s, d)
        : null;
  }

  bool get isMapAbnormal {
    final m = map;
    return m != null && ValidationService.isAbnormal(m, VitalType.map);
  }

  /// First error across all fields, or null when the form can be saved.
  String? get blockingError {
    final heightField = heightUnit == HeightUnit.cm
        ? VitalsField.heightCm
        : (has(VitalsField.heightFeet)
              ? VitalsField.heightFeet
              : VitalsField.heightInches);
    return [
      error(VitalsField.systolic),
      error(VitalsField.diastolic),
      bloodPressurePairError,
      error(VitalsField.heartRate),
      _check(heightField, heightCm),
      error(VitalsField.weight),
      error(VitalsField.temperature),
      error(VitalsField.respiratoryRate),
      error(VitalsField.spo2),
      error(VitalsField.painLevel),
      ValidationService.validateRecordedAt(recordedAt).error,
    ].whereType<String>().firstOrNull;
  }

  bool get hasAnyValue => VitalsField.values.any(has);

  VitalRecord toRecord(String patientId) => VitalRecord(
    patientId: patientId,
    recordedAt: recordedAt,
    systolic: number(VitalsField.systolic),
    diastolic: number(VitalsField.diastolic),
    heartRate: number(VitalsField.heartRate),
    heightCm: heightCm,
    weightKg: weightKg,
    temperatureC: temperatureC,
    respiratoryRate: number(VitalsField.respiratoryRate),
    spo2: number(VitalsField.spo2),
    painLevel: number(VitalsField.painLevel),
    symptoms: symptoms.trim(),
  );
}
