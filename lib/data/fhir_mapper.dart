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

  static const _specs = [
    _Spec(VitalType.heartRate, '8867-4', 'Heart rate', '/min'),
    _Spec(VitalType.height, '8302-2', 'Body height', 'cm'),
    _Spec(VitalType.weight, '29463-7', 'Body weight', 'kg'),
    _Spec(VitalType.temperature, '8310-5', 'Body temperature', 'Cel'),
    _Spec(VitalType.respiratoryRate, '9279-1', 'Respiratory rate', '/min'),
    _Spec(
      VitalType.spo2,
      '59408-5',
      'Oxygen saturation by pulse oximetry',
      '%',
    ),
    _Spec(VitalType.painLevel, '72514-3', 'Pain severity 0-10', '{score}'),
  ];

  // Blood pressure is one panel Observation with two components, plus MAP on its own.
  static const _bpPanel = '85354-9';
  static const _bpComponents = [
    _Spec(VitalType.systolic, '8480-6', 'Systolic blood pressure', _mmHg),
    _Spec(VitalType.diastolic, '8462-4', 'Diastolic blood pressure', _mmHg),
  ];
  static const _meanBp = _Spec(
    VitalType.map,
    '8478-0',
    'Mean blood pressure',
    _mmHg,
  );
  static const _mmHg = 'mm[Hg]';

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

  /// Fields every vital-signs Observation shares.
  static Json _envelope(
    String code,
    String display,
    Json subject,
    String whenIso,
  ) => {
    'resourceType': 'Observation',
    'status': 'final',
    'category': [_vitalSigns],
    'code': _codeable(code, display),
    'subject': subject,
    'effectiveDateTime': whenIso,
  };

  static Json _observation(_Spec s, double v, Json subject, String whenIso) => {
    ..._envelope(s.code, s.display, subject, whenIso),
    'valueQuantity': _quantity(v, s.unit),
  };

  /// One BP panel (systolic + diastolic components) plus MAP,
  /// then one Observation per other recorded vital.
  static List<Json> observations(VitalRecord r, String patientFhirId) {
    final subject = {'reference': 'Patient/$patientFhirId'};
    final whenIso = r.recordedAt.toUtc().toIso8601String();
    final out = <Json>[];
    if (r.systolic != null && r.diastolic != null) {
      out.add({
        ..._envelope(_bpPanel, 'Blood pressure panel', subject, whenIso),
        'component': [
          for (final c in _bpComponents)
            {
              'code': _codeable(c.code, c.display),
              'valueQuantity': _quantity(r.value(c.type)!, c.unit),
            },
        ],
      });
      out.add(_observation(_meanBp, r.map!, subject, whenIso));
    }
    for (final s in _specs) {
      final v = r.value(s.type);
      if (v != null) out.add(_observation(s, v, subject, whenIso));
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
      final (specs, parts) = code == _bpPanel
          ? (_bpComponents, o['component'])
          : (_specs, [o]);
      if (parts is! List) continue;
      for (final part in parts.whereType<Map>()) {
        final spec = _spec(specs, _firstCode(part));
        final v = _quantityValue(part);
        if (spec != null && v != null) {
          r = r.withValue(spec.type, v);
          found = true;
        }
      }
    }
    return found ? r : null;
  }

  // endregion

  static String _date(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static _Spec? _spec(List<_Spec> specs, String? code) =>
      specs.where((s) => s.code == code).firstOrNull;

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

/// LOINC coding and UCUM unit for one vital.
class _Spec {
  const _Spec(this.type, this.code, this.display, this.unit);
  final VitalType type;
  final String code;
  final String display;
  final String unit;
}
