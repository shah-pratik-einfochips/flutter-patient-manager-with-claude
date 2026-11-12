import 'package:flutter_test/flutter_test.dart';
import 'package:patient_health/data/database.dart';
import 'package:patient_health/data/export_service.dart';
import 'package:patient_health/data/fhir_client.dart';
import 'package:patient_health/data/fhir_mapper.dart';
import 'package:patient_health/data/patient_repository.dart';
import 'package:patient_health/domain/enums.dart';
import 'package:patient_health/domain/models.dart';

import 'fhir_test.dart' show samplePatient;

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
  Future<List<Json>> fetchObservations(String patientId) async => remoteObservations;
}

void main() {
  late AppDatabase db;
  late MockFhir fhir;
  late PatientRepository repo;

  setUp(() {
    db = AppDatabase.inMemory();
    fhir = MockFhir();
    repo = PatientRepository(db, fhir);
  });
  tearDown(() => db.close());

  Future<Patient> savedPatient({bool consent = true, String medicalId = 'MRN-001'}) async {
    final p = samplePatient(id: 'id-$medicalId').copyWith(medicalId: medicalId, consentGiven: consent);
    await repo.savePatient(p, isNew: true);
    return p;
  }

  group('patients', () {
    test('save and read back every field', () async {
      final p = samplePatient().copyWith(
        ethnicity: 'x', allergies: 'nuts', medications: 'm', conditions: 'c', examPurpose: 'check', examType: ExaminationType.followUp,
        performedBy: 'Dr A', referredBy: 'Dr B', consentGiven: true, consentAt: DateTime(2026, 1, 1),
      );
      await repo.savePatient(p, isNew: true);
      final r = (await repo.getPatient(p.id))!;
      expect((r.medicalId, r.firstName, r.lastName, r.dob, r.gender, r.bloodType), ('MRN-001', 'Anna', 'Lee', DateTime(1990, 4, 5), Gender.female, BloodType.abPos));
      expect((r.ethnicity, r.allergies, r.examType, r.performedBy, r.referredBy, r.consentGiven), ('x', 'nuts', ExaminationType.followUp, 'Dr A', 'Dr B', true));
      expect(r.consentAt, DateTime(2026, 1, 1));
    });
    test('duplicate medical id is rejected for new and edited patients', () async {
      await savedPatient();
      await expectLater(repo.savePatient(samplePatient(id: 'new-id'), isNew: true), throwsA(isA<DuplicateMedicalIdException>()));
      final other = await savedPatient(medicalId: 'MRN-002');
      await expectLater(repo.savePatient(other.copyWith(medicalId: 'MRN-001'), isNew: false), throwsA(isA<DuplicateMedicalIdException>()));
    });
    test('editing keeps the same medical id', () async {
      final p = await savedPatient();
      await repo.savePatient(p.copyWith(firstName: 'Anne'), isNew: false);
      expect((await repo.getPatient(p.id))!.firstName, 'Anne');
    });
    test('clearConsentAt removes the timestamp', () async {
      final p = samplePatient().copyWith(consentGiven: true, consentAt: DateTime(2026, 1, 1));
      await repo.savePatient(p, isNew: true);
      await repo.savePatient(p.copyWith(consentGiven: false, clearConsentAt: true), isNew: false);
      final r = (await repo.getPatient(p.id))!;
      expect((r.consentGiven, r.consentAt), (false, null));
    });
    test('delete cascades to vitals', () async {
      final p = await savedPatient();
      await repo.addVitals(VitalRecord(patientId: p.id, recordedAt: DateTime.now(), heartRate: 70));
      await repo.deletePatient(p.id);
      expect(await repo.allVitals(p.id), isEmpty);
      expect(await repo.getPatient(p.id), isNull);
    });
    test('watchPatients is ordered by last then first name', () async {
      await repo.savePatient(samplePatient(id: 'a').copyWith(medicalId: 'AAA', lastName: 'Zed', firstName: 'A'), isNew: true);
      await repo.savePatient(samplePatient(id: 'b').copyWith(medicalId: 'BBB', lastName: 'Abe', firstName: 'B'), isNew: true);
      expect((await repo.watchPatients().first).map((p) => p.lastName), ['Abe', 'Zed']);
    });
  });

  group('audit', () {
    test('records actions with ids only', () async {
      final p = await savedPatient();
      await repo.addVitals(VitalRecord(patientId: p.id, recordedAt: DateTime.now(), systolic: 190, diastolic: 120));
      final log = await repo.watchAudit().first;
      expect(log.map((e) => e.action), containsAll(['patient.create', 'vitals.create']));
      for (final e in log) {
        expect(e.detail, p.id);
        expect(e.detail.contains('190'), isFalse);
      }
    });
  });

  group('sync', () {
    test('push requires consent', () async {
      final p = await savedPatient(consent: false);
      await expectLater(repo.push(p.id), throwsA(isA<ConsentRequiredException>()));
      expect(fhir.patients, isEmpty);
    });
    test('push uploads patient and unsynced vitals once', () async {
      final p = await savedPatient();
      await repo.addVitals(VitalRecord(patientId: p.id, recordedAt: DateTime.now(), systolic: 120, diastolic: 80, heartRate: 70));
      await repo.push(p.id);
      expect((await repo.getPatient(p.id))!.fhirId, 'srv-1');
      expect(fhir.observations.length, 3); // panel + MAP + HR
      final stored = (await repo.allVitals(p.id)).single;
      expect(stored.fhirIds.split(','), hasLength(3));

      await repo.push(p.id); // second push must not duplicate observations
      expect(fhir.observations.length, 3);
      expect(fhir.patients.length, 2); // patient is upserted (PUT) each time
      expect(fhir.patients.last['id'], 'srv-1');
    });
    test('a failed upload leaves vitals unsynced so a retry sends them', () async {
      final p = await savedPatient();
      await repo.addVitals(VitalRecord(patientId: p.id, recordedAt: DateTime.now(), heartRate: 70));
      fhir.failUpsert = FhirHttpException(503);
      await expectLater(repo.push(p.id), throwsA(isA<FhirHttpException>()));
      expect((await repo.allVitals(p.id)).single.fhirIds, '');
      fhir.failUpsert = null;
      await repo.push(p.id);
      expect((await repo.allVitals(p.id)).single.fhirIds, isNotEmpty);
    });
    test('pull needs a prior upload', () async {
      final p = await savedPatient();
      await expectLater(repo.pull(p.id), throwsA(isA<NotSyncedException>()));
    });
    test('pull applies demographics and imports new vitals, skipping known timestamps', () async {
      final p = await savedPatient();
      await repo.push(p.id);
      final known = DateTime.utc(2026, 5, 1, 10);
      await repo.addVitals(VitalRecord(patientId: p.id, recordedAt: known.toLocal(), heartRate: 66));
      fhir.remotePatient = {'id': 'srv-1', 'name': [{'family': 'Remote', 'given': ['Rae']}]};
      Json hr(String when, double v, String id) => {
            'id': id,
            'effectiveDateTime': when,
            'code': {'coding': [{'code': '8867-4'}]},
            'valueQuantity': {'value': v},
          };
      fhir.remoteObservations = [hr('2026-05-01T10:00:00.000Z', 66, 'o1'), hr('2026-05-02T10:00:00.000Z', 80, 'o2'), {'effectiveDateTime': 'junk'}];
      await repo.pull(p.id);
      expect((await repo.getPatient(p.id))!.lastName, 'Remote');
      final all = await repo.allVitals(p.id);
      expect(all.length, 2);
      expect(all.map((v) => v.heartRate), containsAll([66, 80]));
      expect(all.firstWhere((v) => v.heartRate == 80).fhirIds, 'o2');
    });
    test('pushAllConsented counts failures and skips non-consented', () async {
      await savedPatient(medicalId: 'AAA');
      await savedPatient(medicalId: 'BBB');
      await savedPatient(consent: false, medicalId: 'CCC');
      expect(await repo.pushAllConsented(), 0);
      expect(fhir.patients.length, 2);
      fhir.failUpsert = FhirHttpException(500);
      expect(await repo.pushAllConsented(), 2);
    });
  });

  group('export', () {
    final at = DateTime.utc(2026, 6, 1, 8, 30);
    test('CSV header lists every vital with units, then symptoms', () {
      final header = ExportService.csv([]).split('\n').first.split(',');
      expect(header.first, 'Date');
      expect(header.length, VitalType.values.length + 2);
      expect(header[1], 'Systolic BP (mmHg)');
      expect(header.last, 'Symptoms');
    });
    test('CSV rows are oldest first with one-decimal values and escaped symptoms', () {
      final a = VitalRecord(patientId: 'p', recordedAt: at, systolic: 120, diastolic: 80, heartRate: 70, symptoms: 'fever, chills "mild"');
      final b = VitalRecord(patientId: 'p', recordedAt: at.subtract(const Duration(days: 1)), heartRate: 58.25);
      final lines = ExportService.csv([a, b]).split('\n');
      expect(lines.length, 3);
      expect(lines[1], startsWith('2026-05-31T08:30:00Z,,,,58.3'));
      expect(lines[2], startsWith('2026-06-01T08:30:00Z,120.0,80.0,93.3,70.0'));
      expect(lines[2], endsWith(',"fever, chills ""mild"""'));
    });
    test('PDF renders a valid document', () async {
      final bytes = await ExportService.pdf(samplePatient(), [
        for (var i = 0; i < 80; i++) VitalRecord(patientId: 'p', recordedAt: at.add(Duration(hours: i)), systolic: 150, diastolic: 95, heartRate: 50.0 + i, spo2: 93),
      ]);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(2000));
    });
  });

  group('database', () {
    test('schema version is tracked', () => expect(db.schemaVersion, 1));
    test('epoch day round trip is stable across dates', () {
      for (final d in [DateTime(1900, 1, 1), DateTime(2000, 2, 29), DateTime(2026, 12, 31)]) {
        expect(AppDatabase.fromEpochDay(AppDatabase.epochDay(d)), d);
      }
    });
  });
}
