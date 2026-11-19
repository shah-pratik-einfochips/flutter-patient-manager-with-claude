import 'package:patient_health/data/fhir_client.dart';
import 'package:patient_health/data/fhir_mapper.dart';
import 'package:patient_health/domain/enums.dart';
import 'package:patient_health/domain/models.dart';

/// Shared test data and fakes, so test files never import each other.

Patient samplePatient({String? fhirId, String id = 'p1'}) => Patient(
  id: id,
  medicalId: 'MRN-001',
  firstName: 'Anna',
  lastName: 'Lee',
  dob: DateTime(1990, 4, 5),
  gender: Gender.female,
  phone: '+1 555 123 4567',
  email: 'anna@example.com',
  bloodType: BloodType.abPos,
  fhirId: fhirId,
);

/// In-memory FHIR server: records uploads and serves scripted remote data.
class MockFhir implements FhirApi {
  final patients = <Json>[];
  final observations = <Json>[];
  var nextId = 1;
  Object? failUpsert;
  Json? remotePatient;
  List<Json> remoteObservations = [];

  @override
  Future<Json> upsertPatient(Json json) async {
    if (failUpsert != null) throw failUpsert!;
    patients.add(json);
    return {...json, 'id': json['id'] ?? 'srv-${nextId++}'};
  }

  @override
  Future<Json> fetchPatient(String id) async => remotePatient ?? {'id': id};

  @override
  Future<String> createObservation(Json json) async {
    observations.add(json);
    return 'obs-${nextId++}';
  }

  @override
  Future<List<Json>> fetchObservations(String patientId) async =>
      remoteObservations;
}
