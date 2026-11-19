import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'unit_conversion.dart';

const _uuid = Uuid();
String newId() => _uuid.v4();

class Patient {
  Patient({
    String? id,
    required this.medicalId,
    required this.firstName,
    required this.lastName,
    required this.dob,
    this.gender = Gender.unknown,
    this.ethnicity = '',
    this.phone = '',
    this.email = '',
    this.bloodType = BloodType.unknown,
    this.allergies = '',
    this.medications = '',
    this.conditions = '',
    this.examPurpose = '',
    this.examType = ExaminationType.routineCheckup,
    this.performedBy = '',
    this.referredBy = '',
    this.consentGiven = false,
    this.consentAt,
    this.fhirId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? newId(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final String medicalId;
  final String firstName;
  final String lastName;

  /// Date only (time ignored).
  final DateTime dob;
  final Gender gender;
  final String ethnicity;
  final String phone;
  final String email;
  final BloodType bloodType;
  final String allergies;
  final String medications;
  final String conditions;
  final String examPurpose;
  final ExaminationType examType;
  final String performedBy;
  final String referredBy;
  final bool consentGiven;
  final DateTime? consentAt;
  final String? fhirId;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName';

  /// Applies the consent rule: the original time is kept while consent stays granted,
  /// [now] is stamped when it is newly granted, and the time is cleared when revoked.
  Patient withConsent(bool given, {DateTime? now}) => copyWith(
    consentGiven: given,
    consentAt: given ? (consentAt ?? now ?? DateTime.now()) : null,
    clearConsentAt: !given,
  );

  Patient copyWith({
    String? medicalId,
    String? firstName,
    String? lastName,
    DateTime? dob,
    Gender? gender,
    String? ethnicity,
    String? phone,
    String? email,
    BloodType? bloodType,
    String? allergies,
    String? medications,
    String? conditions,
    String? examPurpose,
    ExaminationType? examType,
    String? performedBy,
    String? referredBy,
    bool? consentGiven,
    DateTime? consentAt,
    bool clearConsentAt = false,
    String? fhirId,
    DateTime? updatedAt,
  }) => Patient(
    id: id,
    medicalId: medicalId ?? this.medicalId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    ethnicity: ethnicity ?? this.ethnicity,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    bloodType: bloodType ?? this.bloodType,
    allergies: allergies ?? this.allergies,
    medications: medications ?? this.medications,
    conditions: conditions ?? this.conditions,
    examPurpose: examPurpose ?? this.examPurpose,
    examType: examType ?? this.examType,
    performedBy: performedBy ?? this.performedBy,
    referredBy: referredBy ?? this.referredBy,
    consentGiven: consentGiven ?? this.consentGiven,
    consentAt: clearConsentAt ? null : (consentAt ?? this.consentAt),
    fhirId: fhirId ?? this.fhirId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}

class VitalRecord {
  VitalRecord({
    String? id,
    required this.patientId,
    required this.recordedAt,
    this.systolic,
    this.diastolic,
    this.heartRate,
    this.heightCm,
    this.weightKg,
    this.temperatureC,
    this.respiratoryRate,
    this.spo2,
    this.painLevel,
    this.symptoms = '',
    this.fhirIds = '',
  }) : id = id ?? newId();

  final String id;
  final String patientId;
  final DateTime recordedAt;
  final double? systolic;
  final double? diastolic;
  final double? heartRate;
  final double? heightCm;
  final double? weightKg;
  final double? temperatureC;
  final double? respiratoryRate;
  final double? spo2;
  final double? painLevel;
  final String symptoms;

  /// Comma-separated server observation ids; empty means not yet uploaded.
  final String fhirIds;

  /// Mean arterial pressure, derived so it can never disagree with systolic/diastolic.
  double? get map => systolic != null && diastolic != null
      ? UnitConversion.meanArterialPressure(systolic!, diastolic!)
      : null;

  /// Copy with one measured vital set (canonical units). MAP is derived, so it cannot be set.
  VitalRecord withValue(VitalType type, double v) => switch (type) {
    VitalType.systolic => copyWith(systolic: v),
    VitalType.diastolic => copyWith(diastolic: v),
    VitalType.map => throw ArgumentError.value(type, 'type', 'MAP is derived'),
    VitalType.heartRate => copyWith(heartRate: v),
    VitalType.height => copyWith(heightCm: v),
    VitalType.weight => copyWith(weightKg: v),
    VitalType.temperature => copyWith(temperatureC: v),
    VitalType.respiratoryRate => copyWith(respiratoryRate: v),
    VitalType.spo2 => copyWith(spo2: v),
    VitalType.painLevel => copyWith(painLevel: v),
  };

  /// Value for a vital type in canonical units, or null if not recorded.
  double? value(VitalType type) => switch (type) {
    VitalType.systolic => systolic,
    VitalType.diastolic => diastolic,
    VitalType.map => map,
    VitalType.heartRate => heartRate,
    VitalType.height => heightCm,
    VitalType.weight => weightKg,
    VitalType.temperature => temperatureC,
    VitalType.respiratoryRate => respiratoryRate,
    VitalType.spo2 => spo2,
    VitalType.painLevel => painLevel,
  };

  VitalRecord copyWith({
    double? systolic,
    double? diastolic,
    double? heartRate,
    double? heightCm,
    double? weightKg,
    double? temperatureC,
    double? respiratoryRate,
    double? spo2,
    double? painLevel,
    String? fhirIds,
  }) => VitalRecord(
    id: id,
    patientId: patientId,
    recordedAt: recordedAt,
    systolic: systolic ?? this.systolic,
    diastolic: diastolic ?? this.diastolic,
    heartRate: heartRate ?? this.heartRate,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    temperatureC: temperatureC ?? this.temperatureC,
    respiratoryRate: respiratoryRate ?? this.respiratoryRate,
    spo2: spo2 ?? this.spo2,
    painLevel: painLevel ?? this.painLevel,
    symptoms: symptoms,
    fhirIds: fhirIds ?? this.fhirIds,
  );
}

/// Audit entries hold action names and identifiers only - never clinical values.
class AuditEntry {
  const AuditEntry({
    this.id = 0,
    required this.timestamp,
    required this.action,
    this.detail = '',
  });
  final int id;
  final DateTime timestamp;
  final String action;
  final String detail;
}
