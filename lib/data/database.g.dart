// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients
    with TableInfo<$PatientsTable, PatientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicalIdMeta = const VerificationMeta(
    'medicalId',
  );
  @override
  late final GeneratedColumn<String> medicalId = GeneratedColumn<String>(
    'medical_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dobEpochDayMeta = const VerificationMeta(
    'dobEpochDay',
  );
  @override
  late final GeneratedColumn<int> dobEpochDay = GeneratedColumn<int>(
    'dob_epoch_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ethnicityMeta = const VerificationMeta(
    'ethnicity',
  );
  @override
  late final GeneratedColumn<String> ethnicity = GeneratedColumn<String>(
    'ethnicity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bloodTypeMeta = const VerificationMeta(
    'bloodType',
  );
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
    'blood_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _medicationsMeta = const VerificationMeta(
    'medications',
  );
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
    'medications',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _conditionsMeta = const VerificationMeta(
    'conditions',
  );
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
    'conditions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _examPurposeMeta = const VerificationMeta(
    'examPurpose',
  );
  @override
  late final GeneratedColumn<String> examPurpose = GeneratedColumn<String>(
    'exam_purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _examTypeMeta = const VerificationMeta(
    'examType',
  );
  @override
  late final GeneratedColumn<String> examType = GeneratedColumn<String>(
    'exam_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performedByMeta = const VerificationMeta(
    'performedBy',
  );
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
    'performed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _referredByMeta = const VerificationMeta(
    'referredBy',
  );
  @override
  late final GeneratedColumn<String> referredBy = GeneratedColumn<String>(
    'referred_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _consentGivenMeta = const VerificationMeta(
    'consentGiven',
  );
  @override
  late final GeneratedColumn<bool> consentGiven = GeneratedColumn<bool>(
    'consent_given',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("consent_given" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _consentAtMeta = const VerificationMeta(
    'consentAt',
  );
  @override
  late final GeneratedColumn<int> consentAt = GeneratedColumn<int>(
    'consent_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fhirIdMeta = const VerificationMeta('fhirId');
  @override
  late final GeneratedColumn<String> fhirId = GeneratedColumn<String>(
    'fhir_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalId,
    firstName,
    lastName,
    dobEpochDay,
    gender,
    ethnicity,
    phone,
    email,
    bloodType,
    allergies,
    medications,
    conditions,
    examPurpose,
    examType,
    performedBy,
    referredBy,
    consentGiven,
    consentAt,
    fhirId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medical_id')) {
      context.handle(
        _medicalIdMeta,
        medicalId.isAcceptableOrUnknown(data['medical_id']!, _medicalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicalIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('dob_epoch_day')) {
      context.handle(
        _dobEpochDayMeta,
        dobEpochDay.isAcceptableOrUnknown(
          data['dob_epoch_day']!,
          _dobEpochDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dobEpochDayMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('ethnicity')) {
      context.handle(
        _ethnicityMeta,
        ethnicity.isAcceptableOrUnknown(data['ethnicity']!, _ethnicityMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('blood_type')) {
      context.handle(
        _bloodTypeMeta,
        bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_bloodTypeMeta);
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('medications')) {
      context.handle(
        _medicationsMeta,
        medications.isAcceptableOrUnknown(
          data['medications']!,
          _medicationsMeta,
        ),
      );
    }
    if (data.containsKey('conditions')) {
      context.handle(
        _conditionsMeta,
        conditions.isAcceptableOrUnknown(data['conditions']!, _conditionsMeta),
      );
    }
    if (data.containsKey('exam_purpose')) {
      context.handle(
        _examPurposeMeta,
        examPurpose.isAcceptableOrUnknown(
          data['exam_purpose']!,
          _examPurposeMeta,
        ),
      );
    }
    if (data.containsKey('exam_type')) {
      context.handle(
        _examTypeMeta,
        examType.isAcceptableOrUnknown(data['exam_type']!, _examTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_examTypeMeta);
    }
    if (data.containsKey('performed_by')) {
      context.handle(
        _performedByMeta,
        performedBy.isAcceptableOrUnknown(
          data['performed_by']!,
          _performedByMeta,
        ),
      );
    }
    if (data.containsKey('referred_by')) {
      context.handle(
        _referredByMeta,
        referredBy.isAcceptableOrUnknown(data['referred_by']!, _referredByMeta),
      );
    }
    if (data.containsKey('consent_given')) {
      context.handle(
        _consentGivenMeta,
        consentGiven.isAcceptableOrUnknown(
          data['consent_given']!,
          _consentGivenMeta,
        ),
      );
    }
    if (data.containsKey('consent_at')) {
      context.handle(
        _consentAtMeta,
        consentAt.isAcceptableOrUnknown(data['consent_at']!, _consentAtMeta),
      );
    }
    if (data.containsKey('fhir_id')) {
      context.handle(
        _fhirIdMeta,
        fhirId.isAcceptableOrUnknown(data['fhir_id']!, _fhirIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      dobEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dob_epoch_day'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      ethnicity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ethnicity'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      bloodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_type'],
      )!,
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      )!,
      conditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conditions'],
      )!,
      examPurpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_purpose'],
      )!,
      examType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_type'],
      )!,
      performedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performed_by'],
      )!,
      referredBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referred_by'],
      )!,
      consentGiven: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}consent_given'],
      )!,
      consentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consent_at'],
      ),
      fhirId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fhir_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class PatientRow extends DataClass implements Insertable<PatientRow> {
  final String id;
  final String medicalId;
  final String firstName;
  final String lastName;
  final int dobEpochDay;
  final String gender;
  final String ethnicity;
  final String phone;
  final String email;
  final String bloodType;
  final String allergies;
  final String medications;
  final String conditions;
  final String examPurpose;
  final String examType;
  final String performedBy;
  final String referredBy;
  final bool consentGiven;
  final int? consentAt;
  final String? fhirId;
  final int createdAt;
  final int updatedAt;
  const PatientRow({
    required this.id,
    required this.medicalId,
    required this.firstName,
    required this.lastName,
    required this.dobEpochDay,
    required this.gender,
    required this.ethnicity,
    required this.phone,
    required this.email,
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.conditions,
    required this.examPurpose,
    required this.examType,
    required this.performedBy,
    required this.referredBy,
    required this.consentGiven,
    this.consentAt,
    this.fhirId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medical_id'] = Variable<String>(medicalId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['dob_epoch_day'] = Variable<int>(dobEpochDay);
    map['gender'] = Variable<String>(gender);
    map['ethnicity'] = Variable<String>(ethnicity);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['blood_type'] = Variable<String>(bloodType);
    map['allergies'] = Variable<String>(allergies);
    map['medications'] = Variable<String>(medications);
    map['conditions'] = Variable<String>(conditions);
    map['exam_purpose'] = Variable<String>(examPurpose);
    map['exam_type'] = Variable<String>(examType);
    map['performed_by'] = Variable<String>(performedBy);
    map['referred_by'] = Variable<String>(referredBy);
    map['consent_given'] = Variable<bool>(consentGiven);
    if (!nullToAbsent || consentAt != null) {
      map['consent_at'] = Variable<int>(consentAt);
    }
    if (!nullToAbsent || fhirId != null) {
      map['fhir_id'] = Variable<String>(fhirId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      medicalId: Value(medicalId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      dobEpochDay: Value(dobEpochDay),
      gender: Value(gender),
      ethnicity: Value(ethnicity),
      phone: Value(phone),
      email: Value(email),
      bloodType: Value(bloodType),
      allergies: Value(allergies),
      medications: Value(medications),
      conditions: Value(conditions),
      examPurpose: Value(examPurpose),
      examType: Value(examType),
      performedBy: Value(performedBy),
      referredBy: Value(referredBy),
      consentGiven: Value(consentGiven),
      consentAt: consentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(consentAt),
      fhirId: fhirId == null && nullToAbsent
          ? const Value.absent()
          : Value(fhirId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PatientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientRow(
      id: serializer.fromJson<String>(json['id']),
      medicalId: serializer.fromJson<String>(json['medicalId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      dobEpochDay: serializer.fromJson<int>(json['dobEpochDay']),
      gender: serializer.fromJson<String>(json['gender']),
      ethnicity: serializer.fromJson<String>(json['ethnicity']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      bloodType: serializer.fromJson<String>(json['bloodType']),
      allergies: serializer.fromJson<String>(json['allergies']),
      medications: serializer.fromJson<String>(json['medications']),
      conditions: serializer.fromJson<String>(json['conditions']),
      examPurpose: serializer.fromJson<String>(json['examPurpose']),
      examType: serializer.fromJson<String>(json['examType']),
      performedBy: serializer.fromJson<String>(json['performedBy']),
      referredBy: serializer.fromJson<String>(json['referredBy']),
      consentGiven: serializer.fromJson<bool>(json['consentGiven']),
      consentAt: serializer.fromJson<int?>(json['consentAt']),
      fhirId: serializer.fromJson<String?>(json['fhirId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicalId': serializer.toJson<String>(medicalId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'dobEpochDay': serializer.toJson<int>(dobEpochDay),
      'gender': serializer.toJson<String>(gender),
      'ethnicity': serializer.toJson<String>(ethnicity),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'bloodType': serializer.toJson<String>(bloodType),
      'allergies': serializer.toJson<String>(allergies),
      'medications': serializer.toJson<String>(medications),
      'conditions': serializer.toJson<String>(conditions),
      'examPurpose': serializer.toJson<String>(examPurpose),
      'examType': serializer.toJson<String>(examType),
      'performedBy': serializer.toJson<String>(performedBy),
      'referredBy': serializer.toJson<String>(referredBy),
      'consentGiven': serializer.toJson<bool>(consentGiven),
      'consentAt': serializer.toJson<int?>(consentAt),
      'fhirId': serializer.toJson<String?>(fhirId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  PatientRow copyWith({
    String? id,
    String? medicalId,
    String? firstName,
    String? lastName,
    int? dobEpochDay,
    String? gender,
    String? ethnicity,
    String? phone,
    String? email,
    String? bloodType,
    String? allergies,
    String? medications,
    String? conditions,
    String? examPurpose,
    String? examType,
    String? performedBy,
    String? referredBy,
    bool? consentGiven,
    Value<int?> consentAt = const Value.absent(),
    Value<String?> fhirId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => PatientRow(
    id: id ?? this.id,
    medicalId: medicalId ?? this.medicalId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    dobEpochDay: dobEpochDay ?? this.dobEpochDay,
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
    consentAt: consentAt.present ? consentAt.value : this.consentAt,
    fhirId: fhirId.present ? fhirId.value : this.fhirId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PatientRow copyWithCompanion(PatientsCompanion data) {
    return PatientRow(
      id: data.id.present ? data.id.value : this.id,
      medicalId: data.medicalId.present ? data.medicalId.value : this.medicalId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      dobEpochDay: data.dobEpochDay.present
          ? data.dobEpochDay.value
          : this.dobEpochDay,
      gender: data.gender.present ? data.gender.value : this.gender,
      ethnicity: data.ethnicity.present ? data.ethnicity.value : this.ethnicity,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      conditions: data.conditions.present
          ? data.conditions.value
          : this.conditions,
      examPurpose: data.examPurpose.present
          ? data.examPurpose.value
          : this.examPurpose,
      examType: data.examType.present ? data.examType.value : this.examType,
      performedBy: data.performedBy.present
          ? data.performedBy.value
          : this.performedBy,
      referredBy: data.referredBy.present
          ? data.referredBy.value
          : this.referredBy,
      consentGiven: data.consentGiven.present
          ? data.consentGiven.value
          : this.consentGiven,
      consentAt: data.consentAt.present ? data.consentAt.value : this.consentAt,
      fhirId: data.fhirId.present ? data.fhirId.value : this.fhirId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientRow(')
          ..write('id: $id, ')
          ..write('medicalId: $medicalId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('dobEpochDay: $dobEpochDay, ')
          ..write('gender: $gender, ')
          ..write('ethnicity: $ethnicity, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('conditions: $conditions, ')
          ..write('examPurpose: $examPurpose, ')
          ..write('examType: $examType, ')
          ..write('performedBy: $performedBy, ')
          ..write('referredBy: $referredBy, ')
          ..write('consentGiven: $consentGiven, ')
          ..write('consentAt: $consentAt, ')
          ..write('fhirId: $fhirId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    medicalId,
    firstName,
    lastName,
    dobEpochDay,
    gender,
    ethnicity,
    phone,
    email,
    bloodType,
    allergies,
    medications,
    conditions,
    examPurpose,
    examType,
    performedBy,
    referredBy,
    consentGiven,
    consentAt,
    fhirId,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientRow &&
          other.id == this.id &&
          other.medicalId == this.medicalId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.dobEpochDay == this.dobEpochDay &&
          other.gender == this.gender &&
          other.ethnicity == this.ethnicity &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.bloodType == this.bloodType &&
          other.allergies == this.allergies &&
          other.medications == this.medications &&
          other.conditions == this.conditions &&
          other.examPurpose == this.examPurpose &&
          other.examType == this.examType &&
          other.performedBy == this.performedBy &&
          other.referredBy == this.referredBy &&
          other.consentGiven == this.consentGiven &&
          other.consentAt == this.consentAt &&
          other.fhirId == this.fhirId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientsCompanion extends UpdateCompanion<PatientRow> {
  final Value<String> id;
  final Value<String> medicalId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<int> dobEpochDay;
  final Value<String> gender;
  final Value<String> ethnicity;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> bloodType;
  final Value<String> allergies;
  final Value<String> medications;
  final Value<String> conditions;
  final Value<String> examPurpose;
  final Value<String> examType;
  final Value<String> performedBy;
  final Value<String> referredBy;
  final Value<bool> consentGiven;
  final Value<int?> consentAt;
  final Value<String?> fhirId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.medicalId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.dobEpochDay = const Value.absent(),
    this.gender = const Value.absent(),
    this.ethnicity = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.conditions = const Value.absent(),
    this.examPurpose = const Value.absent(),
    this.examType = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.referredBy = const Value.absent(),
    this.consentGiven = const Value.absent(),
    this.consentAt = const Value.absent(),
    this.fhirId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String id,
    required String medicalId,
    required String firstName,
    required String lastName,
    required int dobEpochDay,
    required String gender,
    this.ethnicity = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    required String bloodType,
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.conditions = const Value.absent(),
    this.examPurpose = const Value.absent(),
    required String examType,
    this.performedBy = const Value.absent(),
    this.referredBy = const Value.absent(),
    this.consentGiven = const Value.absent(),
    this.consentAt = const Value.absent(),
    this.fhirId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicalId = Value(medicalId),
       firstName = Value(firstName),
       lastName = Value(lastName),
       dobEpochDay = Value(dobEpochDay),
       gender = Value(gender),
       bloodType = Value(bloodType),
       examType = Value(examType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PatientRow> custom({
    Expression<String>? id,
    Expression<String>? medicalId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<int>? dobEpochDay,
    Expression<String>? gender,
    Expression<String>? ethnicity,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? bloodType,
    Expression<String>? allergies,
    Expression<String>? medications,
    Expression<String>? conditions,
    Expression<String>? examPurpose,
    Expression<String>? examType,
    Expression<String>? performedBy,
    Expression<String>? referredBy,
    Expression<bool>? consentGiven,
    Expression<int>? consentAt,
    Expression<String>? fhirId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalId != null) 'medical_id': medicalId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (dobEpochDay != null) 'dob_epoch_day': dobEpochDay,
      if (gender != null) 'gender': gender,
      if (ethnicity != null) 'ethnicity': ethnicity,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (bloodType != null) 'blood_type': bloodType,
      if (allergies != null) 'allergies': allergies,
      if (medications != null) 'medications': medications,
      if (conditions != null) 'conditions': conditions,
      if (examPurpose != null) 'exam_purpose': examPurpose,
      if (examType != null) 'exam_type': examType,
      if (performedBy != null) 'performed_by': performedBy,
      if (referredBy != null) 'referred_by': referredBy,
      if (consentGiven != null) 'consent_given': consentGiven,
      if (consentAt != null) 'consent_at': consentAt,
      if (fhirId != null) 'fhir_id': fhirId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicalId,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<int>? dobEpochDay,
    Value<String>? gender,
    Value<String>? ethnicity,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? bloodType,
    Value<String>? allergies,
    Value<String>? medications,
    Value<String>? conditions,
    Value<String>? examPurpose,
    Value<String>? examType,
    Value<String>? performedBy,
    Value<String>? referredBy,
    Value<bool>? consentGiven,
    Value<int?>? consentAt,
    Value<String?>? fhirId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PatientsCompanion(
      id: id ?? this.id,
      medicalId: medicalId ?? this.medicalId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dobEpochDay: dobEpochDay ?? this.dobEpochDay,
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
      consentAt: consentAt ?? this.consentAt,
      fhirId: fhirId ?? this.fhirId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicalId.present) {
      map['medical_id'] = Variable<String>(medicalId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (dobEpochDay.present) {
      map['dob_epoch_day'] = Variable<int>(dobEpochDay.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (ethnicity.present) {
      map['ethnicity'] = Variable<String>(ethnicity.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (examPurpose.present) {
      map['exam_purpose'] = Variable<String>(examPurpose.value);
    }
    if (examType.present) {
      map['exam_type'] = Variable<String>(examType.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (referredBy.present) {
      map['referred_by'] = Variable<String>(referredBy.value);
    }
    if (consentGiven.present) {
      map['consent_given'] = Variable<bool>(consentGiven.value);
    }
    if (consentAt.present) {
      map['consent_at'] = Variable<int>(consentAt.value);
    }
    if (fhirId.present) {
      map['fhir_id'] = Variable<String>(fhirId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('medicalId: $medicalId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('dobEpochDay: $dobEpochDay, ')
          ..write('gender: $gender, ')
          ..write('ethnicity: $ethnicity, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('bloodType: $bloodType, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('conditions: $conditions, ')
          ..write('examPurpose: $examPurpose, ')
          ..write('examType: $examType, ')
          ..write('performedBy: $performedBy, ')
          ..write('referredBy: $referredBy, ')
          ..write('consentGiven: $consentGiven, ')
          ..write('consentAt: $consentAt, ')
          ..write('fhirId: $fhirId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VitalsTable extends Vitals with TableInfo<$VitalsTable, VitalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systolicMeta = const VerificationMeta(
    'systolic',
  );
  @override
  late final GeneratedColumn<double> systolic = GeneratedColumn<double>(
    'systolic',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diastolicMeta = const VerificationMeta(
    'diastolic',
  );
  @override
  late final GeneratedColumn<double> diastolic = GeneratedColumn<double>(
    'diastolic',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heartRateMeta = const VerificationMeta(
    'heartRate',
  );
  @override
  late final GeneratedColumn<double> heartRate = GeneratedColumn<double>(
    'heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureCMeta = const VerificationMeta(
    'temperatureC',
  );
  @override
  late final GeneratedColumn<double> temperatureC = GeneratedColumn<double>(
    'temperature_c',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _respiratoryRateMeta = const VerificationMeta(
    'respiratoryRate',
  );
  @override
  late final GeneratedColumn<double> respiratoryRate = GeneratedColumn<double>(
    'respiratory_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2Meta = const VerificationMeta('spo2');
  @override
  late final GeneratedColumn<double> spo2 = GeneratedColumn<double>(
    'spo2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painLevelMeta = const VerificationMeta(
    'painLevel',
  );
  @override
  late final GeneratedColumn<double> painLevel = GeneratedColumn<double>(
    'pain_level',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fhirIdsMeta = const VerificationMeta(
    'fhirIds',
  );
  @override
  late final GeneratedColumn<String> fhirIds = GeneratedColumn<String>(
    'fhir_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    recordedAt,
    systolic,
    diastolic,
    heartRate,
    heightCm,
    weightKg,
    temperatureC,
    respiratoryRate,
    spo2,
    painLevel,
    symptoms,
    fhirIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vitals';
  @override
  VerificationContext validateIntegrity(
    Insertable<VitalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('systolic')) {
      context.handle(
        _systolicMeta,
        systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta),
      );
    }
    if (data.containsKey('diastolic')) {
      context.handle(
        _diastolicMeta,
        diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta),
      );
    }
    if (data.containsKey('heart_rate')) {
      context.handle(
        _heartRateMeta,
        heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('temperature_c')) {
      context.handle(
        _temperatureCMeta,
        temperatureC.isAcceptableOrUnknown(
          data['temperature_c']!,
          _temperatureCMeta,
        ),
      );
    }
    if (data.containsKey('respiratory_rate')) {
      context.handle(
        _respiratoryRateMeta,
        respiratoryRate.isAcceptableOrUnknown(
          data['respiratory_rate']!,
          _respiratoryRateMeta,
        ),
      );
    }
    if (data.containsKey('spo2')) {
      context.handle(
        _spo2Meta,
        spo2.isAcceptableOrUnknown(data['spo2']!, _spo2Meta),
      );
    }
    if (data.containsKey('pain_level')) {
      context.handle(
        _painLevelMeta,
        painLevel.isAcceptableOrUnknown(data['pain_level']!, _painLevelMeta),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('fhir_ids')) {
      context.handle(
        _fhirIdsMeta,
        fhirIds.isAcceptableOrUnknown(data['fhir_ids']!, _fhirIdsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VitalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      systolic: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}systolic'],
      ),
      diastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diastolic'],
      ),
      heartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heart_rate'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      temperatureC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature_c'],
      ),
      respiratoryRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}respiratory_rate'],
      ),
      spo2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spo2'],
      ),
      painLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pain_level'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      )!,
      fhirIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fhir_ids'],
      )!,
    );
  }

  @override
  $VitalsTable createAlias(String alias) {
    return $VitalsTable(attachedDatabase, alias);
  }
}

class VitalRow extends DataClass implements Insertable<VitalRow> {
  final String id;
  final String patientId;
  final int recordedAt;
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
  final String fhirIds;
  const VitalRow({
    required this.id,
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
    required this.symptoms,
    required this.fhirIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['recorded_at'] = Variable<int>(recordedAt);
    if (!nullToAbsent || systolic != null) {
      map['systolic'] = Variable<double>(systolic);
    }
    if (!nullToAbsent || diastolic != null) {
      map['diastolic'] = Variable<double>(diastolic);
    }
    if (!nullToAbsent || heartRate != null) {
      map['heart_rate'] = Variable<double>(heartRate);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || temperatureC != null) {
      map['temperature_c'] = Variable<double>(temperatureC);
    }
    if (!nullToAbsent || respiratoryRate != null) {
      map['respiratory_rate'] = Variable<double>(respiratoryRate);
    }
    if (!nullToAbsent || spo2 != null) {
      map['spo2'] = Variable<double>(spo2);
    }
    if (!nullToAbsent || painLevel != null) {
      map['pain_level'] = Variable<double>(painLevel);
    }
    map['symptoms'] = Variable<String>(symptoms);
    map['fhir_ids'] = Variable<String>(fhirIds);
    return map;
  }

  VitalsCompanion toCompanion(bool nullToAbsent) {
    return VitalsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      recordedAt: Value(recordedAt),
      systolic: systolic == null && nullToAbsent
          ? const Value.absent()
          : Value(systolic),
      diastolic: diastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(diastolic),
      heartRate: heartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRate),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      temperatureC: temperatureC == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureC),
      respiratoryRate: respiratoryRate == null && nullToAbsent
          ? const Value.absent()
          : Value(respiratoryRate),
      spo2: spo2 == null && nullToAbsent ? const Value.absent() : Value(spo2),
      painLevel: painLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(painLevel),
      symptoms: Value(symptoms),
      fhirIds: Value(fhirIds),
    );
  }

  factory VitalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalRow(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      systolic: serializer.fromJson<double?>(json['systolic']),
      diastolic: serializer.fromJson<double?>(json['diastolic']),
      heartRate: serializer.fromJson<double?>(json['heartRate']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      temperatureC: serializer.fromJson<double?>(json['temperatureC']),
      respiratoryRate: serializer.fromJson<double?>(json['respiratoryRate']),
      spo2: serializer.fromJson<double?>(json['spo2']),
      painLevel: serializer.fromJson<double?>(json['painLevel']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      fhirIds: serializer.fromJson<String>(json['fhirIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'systolic': serializer.toJson<double?>(systolic),
      'diastolic': serializer.toJson<double?>(diastolic),
      'heartRate': serializer.toJson<double?>(heartRate),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'temperatureC': serializer.toJson<double?>(temperatureC),
      'respiratoryRate': serializer.toJson<double?>(respiratoryRate),
      'spo2': serializer.toJson<double?>(spo2),
      'painLevel': serializer.toJson<double?>(painLevel),
      'symptoms': serializer.toJson<String>(symptoms),
      'fhirIds': serializer.toJson<String>(fhirIds),
    };
  }

  VitalRow copyWith({
    String? id,
    String? patientId,
    int? recordedAt,
    Value<double?> systolic = const Value.absent(),
    Value<double?> diastolic = const Value.absent(),
    Value<double?> heartRate = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<double?> temperatureC = const Value.absent(),
    Value<double?> respiratoryRate = const Value.absent(),
    Value<double?> spo2 = const Value.absent(),
    Value<double?> painLevel = const Value.absent(),
    String? symptoms,
    String? fhirIds,
  }) => VitalRow(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    recordedAt: recordedAt ?? this.recordedAt,
    systolic: systolic.present ? systolic.value : this.systolic,
    diastolic: diastolic.present ? diastolic.value : this.diastolic,
    heartRate: heartRate.present ? heartRate.value : this.heartRate,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    temperatureC: temperatureC.present ? temperatureC.value : this.temperatureC,
    respiratoryRate: respiratoryRate.present
        ? respiratoryRate.value
        : this.respiratoryRate,
    spo2: spo2.present ? spo2.value : this.spo2,
    painLevel: painLevel.present ? painLevel.value : this.painLevel,
    symptoms: symptoms ?? this.symptoms,
    fhirIds: fhirIds ?? this.fhirIds,
  );
  VitalRow copyWithCompanion(VitalsCompanion data) {
    return VitalRow(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      temperatureC: data.temperatureC.present
          ? data.temperatureC.value
          : this.temperatureC,
      respiratoryRate: data.respiratoryRate.present
          ? data.respiratoryRate.value
          : this.respiratoryRate,
      spo2: data.spo2.present ? data.spo2.value : this.spo2,
      painLevel: data.painLevel.present ? data.painLevel.value : this.painLevel,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      fhirIds: data.fhirIds.present ? data.fhirIds.value : this.fhirIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalRow(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('heartRate: $heartRate, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('respiratoryRate: $respiratoryRate, ')
          ..write('spo2: $spo2, ')
          ..write('painLevel: $painLevel, ')
          ..write('symptoms: $symptoms, ')
          ..write('fhirIds: $fhirIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    recordedAt,
    systolic,
    diastolic,
    heartRate,
    heightCm,
    weightKg,
    temperatureC,
    respiratoryRate,
    spo2,
    painLevel,
    symptoms,
    fhirIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalRow &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.recordedAt == this.recordedAt &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.heartRate == this.heartRate &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.temperatureC == this.temperatureC &&
          other.respiratoryRate == this.respiratoryRate &&
          other.spo2 == this.spo2 &&
          other.painLevel == this.painLevel &&
          other.symptoms == this.symptoms &&
          other.fhirIds == this.fhirIds);
}

class VitalsCompanion extends UpdateCompanion<VitalRow> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<int> recordedAt;
  final Value<double?> systolic;
  final Value<double?> diastolic;
  final Value<double?> heartRate;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<double?> temperatureC;
  final Value<double?> respiratoryRate;
  final Value<double?> spo2;
  final Value<double?> painLevel;
  final Value<String> symptoms;
  final Value<String> fhirIds;
  final Value<int> rowid;
  const VitalsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.respiratoryRate = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.fhirIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VitalsCompanion.insert({
    required String id,
    required String patientId,
    required int recordedAt,
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.respiratoryRate = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.fhirIds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       recordedAt = Value(recordedAt);
  static Insertable<VitalRow> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<int>? recordedAt,
    Expression<double>? systolic,
    Expression<double>? diastolic,
    Expression<double>? heartRate,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<double>? temperatureC,
    Expression<double>? respiratoryRate,
    Expression<double>? spo2,
    Expression<double>? painLevel,
    Expression<String>? symptoms,
    Expression<String>? fhirIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (heartRate != null) 'heart_rate': heartRate,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (temperatureC != null) 'temperature_c': temperatureC,
      if (respiratoryRate != null) 'respiratory_rate': respiratoryRate,
      if (spo2 != null) 'spo2': spo2,
      if (painLevel != null) 'pain_level': painLevel,
      if (symptoms != null) 'symptoms': symptoms,
      if (fhirIds != null) 'fhir_ids': fhirIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VitalsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<int>? recordedAt,
    Value<double?>? systolic,
    Value<double?>? diastolic,
    Value<double?>? heartRate,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<double?>? temperatureC,
    Value<double?>? respiratoryRate,
    Value<double?>? spo2,
    Value<double?>? painLevel,
    Value<String>? symptoms,
    Value<String>? fhirIds,
    Value<int>? rowid,
  }) {
    return VitalsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      recordedAt: recordedAt ?? this.recordedAt,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      heartRate: heartRate ?? this.heartRate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      temperatureC: temperatureC ?? this.temperatureC,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      spo2: spo2 ?? this.spo2,
      painLevel: painLevel ?? this.painLevel,
      symptoms: symptoms ?? this.symptoms,
      fhirIds: fhirIds ?? this.fhirIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<double>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<double>(diastolic.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<double>(heartRate.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (temperatureC.present) {
      map['temperature_c'] = Variable<double>(temperatureC.value);
    }
    if (respiratoryRate.present) {
      map['respiratory_rate'] = Variable<double>(respiratoryRate.value);
    }
    if (spo2.present) {
      map['spo2'] = Variable<double>(spo2.value);
    }
    if (painLevel.present) {
      map['pain_level'] = Variable<double>(painLevel.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (fhirIds.present) {
      map['fhir_ids'] = Variable<String>(fhirIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('heartRate: $heartRate, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('respiratoryRate: $respiratoryRate, ')
          ..write('spo2: $spo2, ')
          ..write('painLevel: $painLevel, ')
          ..write('symptoms: $symptoms, ')
          ..write('fhirIds: $fhirIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog with TableInfo<$AuditLogTable, AuditRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, action, detail];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditRow extends DataClass implements Insertable<AuditRow> {
  final int id;
  final int timestamp;
  final String action;
  final String detail;
  const AuditRow({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.detail,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<int>(timestamp);
    map['action'] = Variable<String>(action);
    map['detail'] = Variable<String>(detail);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      action: Value(action),
      detail: Value(detail),
    );
  }

  factory AuditRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      action: serializer.fromJson<String>(json['action']),
      detail: serializer.fromJson<String>(json['detail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<int>(timestamp),
      'action': serializer.toJson<String>(action),
      'detail': serializer.toJson<String>(detail),
    };
  }

  AuditRow copyWith({
    int? id,
    int? timestamp,
    String? action,
    String? detail,
  }) => AuditRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    action: action ?? this.action,
    detail: detail ?? this.detail,
  );
  AuditRow copyWithCompanion(AuditLogCompanion data) {
    return AuditRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      action: data.action.present ? data.action.value : this.action,
      detail: data.detail.present ? data.detail.value : this.detail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('action: $action, ')
          ..write('detail: $detail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, action, detail);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.action == this.action &&
          other.detail == this.detail);
}

class AuditLogCompanion extends UpdateCompanion<AuditRow> {
  final Value<int> id;
  final Value<int> timestamp;
  final Value<String> action;
  final Value<String> detail;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.action = const Value.absent(),
    this.detail = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    required int timestamp,
    required String action,
    this.detail = const Value.absent(),
  }) : timestamp = Value(timestamp),
       action = Value(action);
  static Insertable<AuditRow> custom({
    Expression<int>? id,
    Expression<int>? timestamp,
    Expression<String>? action,
    Expression<String>? detail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (action != null) 'action': action,
      if (detail != null) 'detail': detail,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? id,
    Value<int>? timestamp,
    Value<String>? action,
    Value<String>? detail,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      detail: detail ?? this.detail,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('action: $action, ')
          ..write('detail: $detail')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $VitalsTable vitals = $VitalsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final Index vitalsPatientTime = Index(
    'vitals_patient_time',
    'CREATE INDEX vitals_patient_time ON vitals (patient_id, recorded_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patients,
    vitals,
    auditLog,
    vitalsPatientTime,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'patients',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vitals', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String id,
  required String medicalId,
  required String firstName,
  required String lastName,
  required int dobEpochDay,
  required String gender,
  Value<String> ethnicity,
  Value<String> phone,
  Value<String> email,
  required String bloodType,
  Value<String> allergies,
  Value<String> medications,
  Value<String> conditions,
  Value<String> examPurpose,
  required String examType,
  Value<String> performedBy,
  Value<String> referredBy,
  Value<bool> consentGiven,
  Value<int?> consentAt,
  Value<String?> fhirId,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> id,
  Value<String> medicalId,
  Value<String> firstName,
  Value<String> lastName,
  Value<int> dobEpochDay,
  Value<String> gender,
  Value<String> ethnicity,
  Value<String> phone,
  Value<String> email,
  Value<String> bloodType,
  Value<String> allergies,
  Value<String> medications,
  Value<String> conditions,
  Value<String> examPurpose,
  Value<String> examType,
  Value<String> performedBy,
  Value<String> referredBy,
  Value<bool> consentGiven,
  Value<int?> consentAt,
  Value<String?> fhirId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, PatientRow> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VitalsTable, List<VitalRow>> _vitalsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vitals,
    aliasName: 'patients__id__vitals__patient_id',
  );

  $$VitalsTableProcessedTableManager get vitalsRefs {
    final manager = $$VitalsTableTableManager(
      $_db,
      $_db.vitals,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vitalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalId => $composableBuilder(
    column: $table.medicalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dobEpochDay => $composableBuilder(
    column: $table.dobEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ethnicity => $composableBuilder(
    column: $table.ethnicity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examPurpose => $composableBuilder(
    column: $table.examPurpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referredBy => $composableBuilder(
    column: $table.referredBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get consentGiven => $composableBuilder(
    column: $table.consentGiven,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consentAt => $composableBuilder(
    column: $table.consentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fhirId => $composableBuilder(
    column: $table.fhirId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vitalsRefs(
    Expression<bool> Function($$VitalsTableFilterComposer f) f,
  ) {
    final $$VitalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vitals,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VitalsTableFilterComposer(
            $db: $db,
            $table: $db.vitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalId => $composableBuilder(
    column: $table.medicalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dobEpochDay => $composableBuilder(
    column: $table.dobEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ethnicity => $composableBuilder(
    column: $table.ethnicity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examPurpose => $composableBuilder(
    column: $table.examPurpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referredBy => $composableBuilder(
    column: $table.referredBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get consentGiven => $composableBuilder(
    column: $table.consentGiven,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consentAt => $composableBuilder(
    column: $table.consentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fhirId => $composableBuilder(
    column: $table.fhirId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicalId =>
      $composableBuilder(column: $table.medicalId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<int> get dobEpochDay => $composableBuilder(
    column: $table.dobEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get ethnicity =>
      $composableBuilder(column: $table.ethnicity, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get examPurpose => $composableBuilder(
    column: $table.examPurpose,
    builder: (column) => column,
  );

  GeneratedColumn<String> get examType =>
      $composableBuilder(column: $table.examType, builder: (column) => column);

  GeneratedColumn<String> get performedBy => $composableBuilder(
    column: $table.performedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referredBy => $composableBuilder(
    column: $table.referredBy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get consentGiven => $composableBuilder(
    column: $table.consentGiven,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consentAt =>
      $composableBuilder(column: $table.consentAt, builder: (column) => column);

  GeneratedColumn<String> get fhirId =>
      $composableBuilder(column: $table.fhirId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> vitalsRefs<T extends Object>(
    Expression<T> Function($$VitalsTableAnnotationComposer a) f,
  ) {
    final $$VitalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vitals,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VitalsTableAnnotationComposer(
            $db: $db,
            $table: $db.vitals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientsTable,
          PatientRow,
          $$PatientsTableFilterComposer,
          $$PatientsTableOrderingComposer,
          $$PatientsTableAnnotationComposer,
          $$PatientsTableCreateCompanionBuilder,
          $$PatientsTableUpdateCompanionBuilder,
          (PatientRow, $$PatientsTableReferences),
          PatientRow,
          PrefetchHooks Function({bool vitalsRefs})
        > {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicalId = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<int> dobEpochDay = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> ethnicity = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> bloodType = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> conditions = const Value.absent(),
                Value<String> examPurpose = const Value.absent(),
                Value<String> examType = const Value.absent(),
                Value<String> performedBy = const Value.absent(),
                Value<String> referredBy = const Value.absent(),
                Value<bool> consentGiven = const Value.absent(),
                Value<int?> consentAt = const Value.absent(),
                Value<String?> fhirId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientsCompanion(
                id: id,
                medicalId: medicalId,
                firstName: firstName,
                lastName: lastName,
                dobEpochDay: dobEpochDay,
                gender: gender,
                ethnicity: ethnicity,
                phone: phone,
                email: email,
                bloodType: bloodType,
                allergies: allergies,
                medications: medications,
                conditions: conditions,
                examPurpose: examPurpose,
                examType: examType,
                performedBy: performedBy,
                referredBy: referredBy,
                consentGiven: consentGiven,
                consentAt: consentAt,
                fhirId: fhirId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicalId,
                required String firstName,
                required String lastName,
                required int dobEpochDay,
                required String gender,
                Value<String> ethnicity = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                required String bloodType,
                Value<String> allergies = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> conditions = const Value.absent(),
                Value<String> examPurpose = const Value.absent(),
                required String examType,
                Value<String> performedBy = const Value.absent(),
                Value<String> referredBy = const Value.absent(),
                Value<bool> consentGiven = const Value.absent(),
                Value<int?> consentAt = const Value.absent(),
                Value<String?> fhirId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PatientsCompanion.insert(
                id: id,
                medicalId: medicalId,
                firstName: firstName,
                lastName: lastName,
                dobEpochDay: dobEpochDay,
                gender: gender,
                ethnicity: ethnicity,
                phone: phone,
                email: email,
                bloodType: bloodType,
                allergies: allergies,
                medications: medications,
                conditions: conditions,
                examPurpose: examPurpose,
                examType: examType,
                performedBy: performedBy,
                referredBy: referredBy,
                consentGiven: consentGiven,
                consentAt: consentAt,
                fhirId: fhirId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PatientsTable, PatientRow>(table),
                  $$PatientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vitalsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vitalsRefs) db.vitals],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vitalsRefs)
                    await $_getPrefetchedDataByColumns<
                      PatientRow,
                      $PatientsTable,
                      VitalRow,
                      $VitalsTable
                    >(
                      currentTable: table,
                      referencedTable: $$PatientsTableReferences
                          ._vitalsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PatientsTableReferences(db, table, p0).vitalsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'patient_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PatientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientsTable,
      PatientRow,
      $$PatientsTableFilterComposer,
      $$PatientsTableOrderingComposer,
      $$PatientsTableAnnotationComposer,
      $$PatientsTableCreateCompanionBuilder,
      $$PatientsTableUpdateCompanionBuilder,
      (PatientRow, $$PatientsTableReferences),
      PatientRow,
      PrefetchHooks Function({bool vitalsRefs})
    >;
typedef $$VitalsTableCreateCompanionBuilder = VitalsCompanion Function({
  required String id,
  required String patientId,
  required int recordedAt,
  Value<double?> systolic,
  Value<double?> diastolic,
  Value<double?> heartRate,
  Value<double?> heightCm,
  Value<double?> weightKg,
  Value<double?> temperatureC,
  Value<double?> respiratoryRate,
  Value<double?> spo2,
  Value<double?> painLevel,
  Value<String> symptoms,
  Value<String> fhirIds,
  Value<int> rowid,
});
typedef $$VitalsTableUpdateCompanionBuilder = VitalsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<int> recordedAt,
  Value<double?> systolic,
  Value<double?> diastolic,
  Value<double?> heartRate,
  Value<double?> heightCm,
  Value<double?> weightKg,
  Value<double?> temperatureC,
  Value<double?> respiratoryRate,
  Value<double?> spo2,
  Value<double?> painLevel,
  Value<String> symptoms,
  Value<String> fhirIds,
  Value<int> rowid,
});

final class $$VitalsTableReferences
    extends BaseReferences<_$AppDatabase, $VitalsTable, VitalRow> {
  $$VitalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('vitals__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VitalsTableFilterComposer
    extends Composer<_$AppDatabase, $VitalsTable> {
  $$VitalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get respiratoryRate => $composableBuilder(
    column: $table.respiratoryRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get painLevel => $composableBuilder(
    column: $table.painLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fhirIds => $composableBuilder(
    column: $table.fhirIds,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VitalsTableOrderingComposer
    extends Composer<_$AppDatabase, $VitalsTable> {
  $$VitalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get respiratoryRate => $composableBuilder(
    column: $table.respiratoryRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get painLevel => $composableBuilder(
    column: $table.painLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fhirIds => $composableBuilder(
    column: $table.fhirIds,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VitalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VitalsTable> {
  $$VitalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<double> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<double> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => column,
  );

  GeneratedColumn<double> get respiratoryRate => $composableBuilder(
    column: $table.respiratoryRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spo2 =>
      $composableBuilder(column: $table.spo2, builder: (column) => column);

  GeneratedColumn<double> get painLevel =>
      $composableBuilder(column: $table.painLevel, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get fhirIds =>
      $composableBuilder(column: $table.fhirIds, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VitalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VitalsTable,
          VitalRow,
          $$VitalsTableFilterComposer,
          $$VitalsTableOrderingComposer,
          $$VitalsTableAnnotationComposer,
          $$VitalsTableCreateCompanionBuilder,
          $$VitalsTableUpdateCompanionBuilder,
          (VitalRow, $$VitalsTableReferences),
          VitalRow,
          PrefetchHooks Function({bool patientId})
        > {
  $$VitalsTableTableManager(_$AppDatabase db, $VitalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<double?> systolic = const Value.absent(),
                Value<double?> diastolic = const Value.absent(),
                Value<double?> heartRate = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> temperatureC = const Value.absent(),
                Value<double?> respiratoryRate = const Value.absent(),
                Value<double?> spo2 = const Value.absent(),
                Value<double?> painLevel = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<String> fhirIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VitalsCompanion(
                id: id,
                patientId: patientId,
                recordedAt: recordedAt,
                systolic: systolic,
                diastolic: diastolic,
                heartRate: heartRate,
                heightCm: heightCm,
                weightKg: weightKg,
                temperatureC: temperatureC,
                respiratoryRate: respiratoryRate,
                spo2: spo2,
                painLevel: painLevel,
                symptoms: symptoms,
                fhirIds: fhirIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required int recordedAt,
                Value<double?> systolic = const Value.absent(),
                Value<double?> diastolic = const Value.absent(),
                Value<double?> heartRate = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> temperatureC = const Value.absent(),
                Value<double?> respiratoryRate = const Value.absent(),
                Value<double?> spo2 = const Value.absent(),
                Value<double?> painLevel = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<String> fhirIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VitalsCompanion.insert(
                id: id,
                patientId: patientId,
                recordedAt: recordedAt,
                systolic: systolic,
                diastolic: diastolic,
                heartRate: heartRate,
                heightCm: heightCm,
                weightKg: weightKg,
                temperatureC: temperatureC,
                respiratoryRate: respiratoryRate,
                spo2: spo2,
                painLevel: painLevel,
                symptoms: symptoms,
                fhirIds: fhirIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VitalsTable, VitalRow>(table),
                  $$VitalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.patientId,
                        referencedTable: $$VitalsTableReferences
                            ._patientIdTable(db),
                        referencedColumn: $$VitalsTableReferences
                            ._patientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VitalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VitalsTable,
      VitalRow,
      $$VitalsTableFilterComposer,
      $$VitalsTableOrderingComposer,
      $$VitalsTableAnnotationComposer,
      $$VitalsTableCreateCompanionBuilder,
      $$VitalsTableUpdateCompanionBuilder,
      (VitalRow, $$VitalsTableReferences),
      VitalRow,
      PrefetchHooks Function({bool patientId})
    >;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  required int timestamp,
  required String action,
  Value<String> detail,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<int> id,
  Value<int> timestamp,
  Value<String> action,
  Value<String> detail,
});

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditRow,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (AuditRow, BaseReferences<_$AppDatabase, $AuditLogTable, AuditRow>),
          AuditRow,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> detail = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                timestamp: timestamp,
                action: action,
                detail: detail,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int timestamp,
                required String action,
                Value<String> detail = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                timestamp: timestamp,
                action: action,
                detail: detail,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditLogTable, AuditRow>(table),
                  BaseReferences<_$AppDatabase, $AuditLogTable, AuditRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditRow,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditRow, BaseReferences<_$AppDatabase, $AuditLogTable, AuditRow>),
      AuditRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$VitalsTableTableManager get vitals =>
      $$VitalsTableTableManager(_db, _db.vitals);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
}
