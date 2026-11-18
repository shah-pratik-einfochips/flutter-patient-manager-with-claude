import '../domain/enums.dart';
import '../domain/models.dart';

typedef Json = Map<String, dynamic>;

/// Converts between app models and FHIR R4 Patient / Observation JSON.
abstract final class FhirMapper {
  static const medicalIdSystem = 'urn:einfochips:patient-health:medical-id';
  static const _loinc = 'http://loinc.org';
  static const _ucum = 'http://unitsofmeasure.org';

  // region Patient

  static Json patientResource(Patient p) => {
    'resourceType': 'Patient',
    if (p.fhirId != null) 'id': p.fhirId,
    'identifier': [
      {'system': medicalIdSystem, 'value': p.medicalId},
    ],
    'name': [
      {
        'family': p.lastName,
        'given': [p.firstName],
      },
    ],
    'gender': p.gender.fhir,
    'birthDate': _date(p.dob),
    'telecom': [
      if (p.phone.isNotEmpty) {'system': 'phone', 'value': p.phone},
      if (p.email.isNotEmpty) {'system': 'email', 'value': p.email},
    ],
    'extension': [
      {
        'url': 'urn:einfochips:patient-health:blood-type',
        'valueString': p.bloodType.label,
      },
    ],
  };

  /// Applies the demographics present in [json] onto [p]; absent fields are left unchanged.
  static Patient applyPatient(Json json, Patient p) {
    var lastName = p.lastName,
        firstName = p.firstName,
        phone = p.phone,
        email = p.email;
    var gender = p.gender, dob = p.dob;
    final name = _firstMap(json['name']);
    if (name != null) {
      if (name['family'] is String) lastName = name['family'] as String;
      final given = name['given'];
      if (given is List && given.isNotEmpty && given.first is String)
        firstName = given.first as String;
    }
    if (json['gender'] is String)
      gender = Gender.fromFhir(json['gender'] as String);
    if (json['birthDate'] is String) {
      final parsed = DateTime.tryParse(json['birthDate'] as String);
      if (parsed != null) dob = DateTime(parsed.year, parsed.month, parsed.day);
    }
    final telecom = json['telecom'];
    if (telecom is List) {
      for (final t in telecom.whereType<Map>()) {
        final value = t['value'];
        if (value is! String) continue;
        if (t['system'] == 'phone') phone = value;
        if (t['system'] == 'email') email = value;
      }
    }
    return p.copyWith(
      fhirId: json['id'] is String ? json['id'] as String : null,
      lastName: lastName,
      firstName: firstName,
      gender: gender,
      dob: dob,
      phone: phone,
      email: email,
    );
  }

  // endregion

  // region Observation

  static final _specs = <_Spec>[
    _Spec(
      '8867-4',
      'Heart rate',
      '/min',
      (r) => r.heartRate,
      (r, v) => r.copyWith(heartRate: v),
    ),
    _Spec(
      '8302-2',
      'Body height',
      'cm',
      (r) => r.heightCm,
      (r, v) => r.copyWith(heightCm: v),
    ),
    _Spec(
      '29463-7',
      'Body weight',
      'kg',
      (r) => r.weightKg,
      (r, v) => r.copyWith(weightKg: v),
    ),
    _Spec(
      '8310-5',
      'Body temperature',
      'Cel',
      (r) => r.temperatureC,
      (r, v) => r.copyWith(temperatureC: v),
    ),
    _Spec(
      '9279-1',
      'Respiratory rate',
      '/min',
      (r) => r.respiratoryRate,
      (r, v) => r.copyWith(respiratoryRate: v),
    ),
    _Spec(
      '59408-5',
      'Oxygen saturation by pulse oximetry',
      '%',
      (r) => r.spo2,
      (r, v) => r.copyWith(spo2: v),
    ),
    _Spec(
      '72514-3',
      'Pain severity 0-10',
      '{score}',
      (r) => r.painLevel,
      (r, v) => r.copyWith(painLevel: v),
    ),
  ];

  static Json _codeable(String code, String display) => {
    'coding': [
      {'system': _loinc, 'code': code, 'display': display},
    ],
    'text': display,
  };

  static Json _quantity(double v, String unit) => {
    'value': v,
    'unit': unit,
    'system': _ucum,
    'code': unit,
  };

  static final Json _vitalSigns = {
    'coding': [
      {
        'system': 'http://terminology.hl7.org/CodeSystem/observation-category',
        'code': 'vital-signs',
      },
    ],
  };

  static Json _observation(
    String code,
    String display,
    double v,
    String unit,
    Json subject,
    String whenIso,
  ) => {
    'resourceType': 'Observation',
    'status': 'final',
    'category': [_vitalSigns],
    'code': _codeable(code, display),
    'subject': subject,
    'effectiveDateTime': whenIso,
    'valueQuantity': _quantity(v, unit),
  };

  /// One BP panel (systolic + diastolic components) plus MAP,
  /// then one Observation per other recorded vital.
  static List<Json> observations(VitalRecord r, String patientFhirId) {
    final subject = {'reference': 'Patient/$patientFhirId'};
    final whenIso = r.recordedAt.toUtc().toIso8601String();
    final out = <Json>[];
    if (r.systolic != null && r.diastolic != null) {
      out.add({
        'resourceType': 'Observation',
        'status': 'final',
        'category': [_vitalSigns],
        'code': _codeable('85354-9', 'Blood pressure panel'),
        'subject': subject,
        'effectiveDateTime': whenIso,
        'component': [
          {
            'code': _codeable('8480-6', 'Systolic blood pressure'),
            'valueQuantity': _quantity(r.systolic!, 'mm[Hg]'),
          },
          {
            'code': _codeable('8462-4', 'Diastolic blood pressure'),
            'valueQuantity': _quantity(r.diastolic!, 'mm[Hg]'),
          },
        ],
      });
      out.add(
        _observation(
          '8478-0',
          'Mean blood pressure',
          r.map!,
          'mm[Hg]',
          subject,
          whenIso,
        ),
      );
    }
    for (final s in _specs) {
      final v = s.read(r);
      if (v != null)
        out.add(_observation(s.code, s.display, v, s.unit, subject, whenIso));
    }
    return out;
  }

  /// Builds a record from observations sharing one timestamp,
  /// or null when none is a known vital.
  static VitalRecord? vitalRecord(
    List<Json> observations,
    String patientId,
    DateTime recordedAt,
  ) {
    var r = VitalRecord(patientId: patientId, recordedAt: recordedAt);
    var found = false;
    for (final o in observations) {
      final code = _firstCode(o);
      if (code == '85354-9') {
        final components = o['component'];
        if (components is! List) continue;
        for (final c in components.whereType<Map>()) {
          final v = _quantityValue(c);
          if (v == null) continue;
          switch (_firstCode(c)) {
            case '8480-6':
              r = r.copyWith(systolic: v);
              found = true;
            case '8462-4':
              r = r.copyWith(diastolic: v);
              found = true;
          }
        }
      } else {
        final spec = _specs.where((s) => s.code == code).firstOrNull;
        final v = _quantityValue(o);
        if (spec != null && v != null) {
          r = spec.write(r, v);
          found = true;
        }
      }
    }
    return found ? r : null;
  }

  // endregion

  static String _date(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Map? _firstMap(Object? list) =>
      list is List && list.isNotEmpty && list.first is Map
      ? list.first as Map
      : null;

  static String? _firstCode(Map o) {
    final coding = (o['code'] is Map) ? (o['code'] as Map)['coding'] : null;
    final first = _firstMap(coding);
    return first?['code'] is String ? first!['code'] as String : null;
  }

  static double? _quantityValue(Map o) {
    final q = o['valueQuantity'];
    final v = q is Map ? q['value'] : null;
    return v is num ? v.toDouble() : null;
  }
}

class _Spec {
  _Spec(this.code, this.display, this.unit, this.read, this.write);
  final String code;
  final String display;
  final String unit;
  final double? Function(VitalRecord) read;
  final VitalRecord Function(VitalRecord, double) write;
}
