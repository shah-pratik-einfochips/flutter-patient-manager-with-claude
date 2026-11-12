import '../domain/models.dart';
import 'database.dart';
import 'fhir_client.dart';
import 'fhir_mapper.dart';

class ConsentRequiredException implements Exception {
  @override
  String toString() =>
      'Patient consent is required before data can be uploaded.';
}

class NotSyncedException implements Exception {
  @override
  String toString() => 'This patient has not been uploaded yet.';
}

class DuplicateMedicalIdException implements Exception {
  @override
  String toString() => 'A patient with this medical ID already exists.';
}

class PatientRepository {
  PatientRepository(this._db, this._fhir);
  final AppDatabase _db;
  final FhirApi _fhir;

  Stream<List<Patient>> watchPatients() => _db.watchPatients();
  Stream<Patient?> watchPatient(String id) => _db.watchPatient(id);
  Stream<List<VitalRecord>> watchVitals(String patientId) =>
      _db.watchVitals(patientId);
  Stream<List<AuditEntry>> watchAudit({int limit = 50}) =>
      _db.watchAudit(limit: limit);
  Future<Patient?> getPatient(String id) => _db.getPatient(id);
  Future<List<VitalRecord>> allVitals(String patientId) =>
      _db.allVitals(patientId);

  Future<void> log(String action, [String detail = '']) =>
      _db.addAudit(action, detail);

  /// Inserts or updates a patient; medical IDs must stay unique.
  Future<void> savePatient(Patient patient, {required bool isNew}) async {
    if (await _db.countDuplicates(patient.medicalId, patient.id) > 0)
      throw DuplicateMedicalIdException();
    await _db.upsertPatient(patient);
    await log(isNew ? 'patient.create' : 'patient.update', patient.id);
  }

  Future<void> deletePatient(String id) async {
    await _db.deletePatient(id);
    await log('patient.delete', id);
  }

  Future<void> addVitals(VitalRecord record) async {
    await _db.insertVital(record);
    await log('vitals.create', record.patientId);
  }

  /// Uploads the patient and any not-yet-uploaded vitals. Requires consent.
  Future<void> push(String patientId) async {
    final local = await _db.getPatient(patientId);
    if (local == null) return;
    if (!local.consentGiven) throw ConsentRequiredException();
    final stored = await _fhir.upsertPatient(FhirMapper.patientResource(local));
    final serverId = stored['id'];
    if (serverId is! String) throw const FhirDecodingException();
    await _db.upsertPatient(local.copyWith(fhirId: serverId));
    for (final record in await _db.unsyncedVitals(patientId)) {
      final ids = <String>[];
      for (final o in FhirMapper.observations(record, serverId)) {
        ids.add(await _fhir.createObservation(o));
      }
      await _db.setFhirIds(record.id, ids.join(','));
    }
    await log('sync.push', patientId);
  }

  /// Downloads demographics and any vitals not already stored (matched by timestamp).
  Future<void> pull(String patientId) async {
    final local = await _db.getPatient(patientId);
    if (local == null) return;
    final serverId = local.fhirId;
    if (serverId == null) throw NotSyncedException();
    await _db.upsertPatient(
      FhirMapper.applyPatient(await _fhir.fetchPatient(serverId), local),
    );

    final grouped = <String, List<Json>>{};
    for (final o in await _fhir.fetchObservations(serverId)) {
      grouped
          .putIfAbsent((o['effectiveDateTime'] as String?) ?? '', () => [])
          .add(o);
    }
    for (final MapEntry(key: stamp, value: group) in grouped.entries) {
      final time = DateTime.tryParse(stamp);
      if (time == null) continue;
      if (await _db.countNear(patientId, time) > 0) continue;
      final record = FhirMapper.vitalRecord(group, patientId, time.toLocal());
      if (record == null) continue;
      final ids = group.map((o) => o['id']).whereType<String>().join(',');
      await _db.insertVital(record.copyWith(fhirIds: ids));
    }
    await log('sync.pull', patientId);
  }

  /// Pushes every consented patient; used by background sync. Returns the number that failed.
  Future<int> pushAllConsented() async {
    var failures = 0;
    for (final p in await _db.consentedPatients()) {
      try {
        await push(p.id);
      } catch (_) {
        failures++;
      }
    }
    return failures;
  }
}
