enum Gender {
  male('Male', 'male'),
  female('Female', 'female'),
  other('Other', 'other'),
  unknown('Unknown', 'unknown');

  const Gender(this.title, this.fhir);
  final String title;
  final String fhir;

  /// Parses a FHIR gender code, falling back to [unknown].
  static Gender fromFhir(String? code) =>
      values.firstWhere((g) => g.fhir == code, orElse: () => unknown);
}

enum BloodType {
  unknown('Unknown'),
  aPos('A+'),
  aNeg('A-'),
  bPos('B+'),
  bNeg('B-'),
  abPos('AB+'),
  abNeg('AB-'),
  oPos('O+'),
  oNeg('O-');

  const BloodType(this.label);
  final String label;
}

enum ExaminationType {
  routineCheckup('Routine checkup'),
  emergency('Emergency'),
  followUp('Follow-up'),
  consultation('Consultation'),
  diagnostic('Diagnostic'),
  preventive('Preventive');

  const ExaminationType(this.label);
  final String label;
}

enum HeightUnit {
  cm('cm'),
  ftIn('ft/in');

  const HeightUnit(this.label);
  final String label;
}

enum WeightUnit {
  kg('kg'),
  lbs('lbs');

  const WeightUnit(this.label);
  final String label;
}

enum TemperatureUnit {
  celsius('°C'),
  fahrenheit('°F');

  const TemperatureUnit(this.label);
  final String label;
}

enum VitalType {
  systolic('Systolic BP', 'mmHg', 50, 260, 90, 120),
  diastolic('Diastolic BP', 'mmHg', 30, 160, 60, 80),
  map('Mean Arterial Pressure', 'mmHg', 30, 200, 70, 100),
  heartRate('Heart Rate', 'bpm', 20, 250, 60, 100),
  height('Height', 'cm', 30, 260, null, null),
  weight('Weight', 'kg', 1, 500, null, null),
  temperature('Temperature', '°C', 30, 45, 36.1, 37.2),
  respiratoryRate('Respiratory Rate', 'breaths/min', 4, 70, 12, 20),
  spo2('SpO₂ (Oxygen Saturation)', '%', 50, 100, 95, 100),
  painLevel('Pain Level', '/10', 0, 10, 0, 3);

  const VitalType(
    this.title,
    this.unit,
    this.validMin,
    this.validMax,
    this.normalMin,
    this.normalMax,
  );

  final String title;
  final String unit;

  /// Hard limits: values outside are rejected on entry.
  final double validMin;
  final double validMax;

  /// Clinical normal range; null for types where "abnormal" has no meaning.
  final double? normalMin;
  final double? normalMax;

  /// Vitals that make sense on a time-series chart (height rarely changes).
  static List<VitalType> get chartable =>
      values.where((t) => t != height).toList();
}
