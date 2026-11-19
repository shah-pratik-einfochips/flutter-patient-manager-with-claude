import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../domain/enums.dart';
import '../domain/models.dart';

part 'database.g.dart';

@DataClassName('PatientRow')
class Patients extends Table {
  TextColumn get id => text()();
  TextColumn get medicalId => text().unique()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  IntColumn get dobEpochDay => integer()();
  TextColumn get gender => text()();
  TextColumn get ethnicity => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get bloodType => text()();
  TextColumn get allergies => text().withDefault(const Constant(''))();
  TextColumn get medications => text().withDefault(const Constant(''))();
  TextColumn get conditions => text().withDefault(const Constant(''))();
  TextColumn get examPurpose => text().withDefault(const Constant(''))();
  TextColumn get examType => text()();
  TextColumn get performedBy => text().withDefault(const Constant(''))();
  TextColumn get referredBy => text().withDefault(const Constant(''))();
  BoolColumn get consentGiven => boolean().withDefault(const Constant(false))();
  IntColumn get consentAt => integer().nullable()();
  TextColumn get fhirId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VitalRow')
@TableIndex(name: 'vitals_patient_time', columns: {#patientId, #recordedAt})
class Vitals extends Table {
  TextColumn get id => text()();
  TextColumn get patientId =>
      text().references(Patients, #id, onDelete: KeyAction.cascade)();
  IntColumn get recordedAt => integer()();
  RealColumn get systolic => real().nullable()();
  RealColumn get diastolic => real().nullable()();
  RealColumn get heartRate => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get temperatureC => real().nullable()();
  RealColumn get respiratoryRate => real().nullable()();
  RealColumn get spo2 => real().nullable()();
  RealColumn get painLevel => real().nullable()();
  TextColumn get symptoms => text().withDefault(const Constant(''))();
  TextColumn get fhirIds => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AuditRow')
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timestamp => integer()();
  TextColumn get action => text()();
  TextColumn get detail => text().withDefault(const Constant(''))();
}

@DriftDatabase(tables: [Patients, Vitals, AuditLog])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens an unencrypted in-memory database (tests).
  AppDatabase.inMemory() : super(NativeDatabase.memory());

  /// Bump together with a step in [migration] whenever the schema changes.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    // Future versions: add `onUpgrade: stepByStep(from1To2: ...)` and a migration test.
  );

  // region Patients

  Stream<List<Patient>> watchPatients() =>
      (select(patients)..orderBy([
            (t) => OrderingTerm.asc(t.lastName),
            (t) => OrderingTerm.asc(t.firstName),
          ]))
          .watch()
          .map((rows) => rows.map(_patient).toList());

  Stream<Patient?> watchPatient(String id) =>
      (select(patients)..where((t) => t.id.equals(id))).watchSingleOrNull().map(
        (r) => r == null ? null : _patient(r),
      );

  Future<Patient?> getPatient(String id) async {
    final r = await (select(
      patients,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return r == null ? null : _patient(r);
  }

  Future<int> countDuplicates(String medicalId, String excludingId) async {
    final c = patients.id.count();
    final q = selectOnly(patients)
      ..addColumns([c])
      ..where(
        patients.medicalId.equals(medicalId) &
            patients.id.equals(excludingId).not(),
      );
    return (await q.map((r) => r.read(c)!).getSingle());
  }

  Future<void> upsertPatient(Patient x) =>
      into(patients).insertOnConflictUpdate(
        PatientsCompanion.insert(
          id: x.id,
          medicalId: x.medicalId,
          firstName: x.firstName,
          lastName: x.lastName,
          dobEpochDay: epochDay(x.dob),
          gender: x.gender.name,
          ethnicity: Value(x.ethnicity),
          phone: Value(x.phone),
          email: Value(x.email),
          bloodType: x.bloodType.name,
          allergies: Value(x.allergies),
          medications: Value(x.medications),
          conditions: Value(x.conditions),
          examPurpose: Value(x.examPurpose),
          examType: x.examType.name,
          performedBy: Value(x.performedBy),
          referredBy: Value(x.referredBy),
          consentGiven: Value(x.consentGiven),
          consentAt: Value(x.consentAt?.millisecondsSinceEpoch),
          fhirId: Value(x.fhirId),
          createdAt: x.createdAt.millisecondsSinceEpoch,
          updatedAt: x.updatedAt.millisecondsSinceEpoch,
        ),
      );

  Future<void> deletePatient(String id) =>
      (delete(patients)..where((t) => t.id.equals(id))).go();

  Future<List<Patient>> consentedPatients() async => (await (select(
    patients,
  )..where((t) => t.consentGiven.equals(true))).get()).map(_patient).toList();

  // endregion

  // region Vitals

  Stream<List<VitalRecord>> watchVitals(String patientId) =>
      (select(vitals)
            ..where((t) => t.patientId.equals(patientId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
          .watch()
          .map((rows) => rows.map(_vital).toList());

  Future<List<VitalRecord>> allVitals(String patientId) async => (await (select(
    vitals,
  )..where((t) => t.patientId.equals(patientId))).get()).map(_vital).toList();

  Future<void> insertVital(VitalRecord v) =>
      into(vitals).insertOnConflictUpdate(_vitalCompanion(v));

  Future<List<VitalRecord>> unsyncedVitals(String patientId) async =>
      (await (select(vitals)..where(
                (t) => t.patientId.equals(patientId) & t.fhirIds.equals(''),
              ))
              .get())
          .map(_vital)
          .toList();

  Future<void> setFhirIds(String vitalId, String ids) =>
      (update(vitals)..where((t) => t.id.equals(vitalId))).write(
        VitalsCompanion(fhirIds: Value(ids)),
      );

  /// Records within one second of [time]: used to avoid re-importing the same measurement.
  Future<int> countNear(String patientId, DateTime time) async {
    final c = vitals.id.count();
    final ms = time.millisecondsSinceEpoch;
    final q = selectOnly(vitals)
      ..addColumns([c])
      ..where(
        vitals.patientId.equals(patientId) &
            vitals.recordedAt.isBetweenValues(ms - 1000, ms + 1000),
      );
    return q.map((r) => r.read(c)!).getSingle();
  }

  // endregion

  // region Audit

  Future<void> addAudit(String action, String detail) => into(auditLog).insert(
    AuditLogCompanion.insert(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      action: action,
      detail: Value(detail),
    ),
  );

  Stream<List<AuditEntry>> watchAudit({int limit = 50}) =>
      (select(auditLog)
            ..orderBy([
              (t) => OrderingTerm.desc(t.timestamp),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(limit))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (r) => AuditEntry(
                    id: r.id,
                    timestamp: DateTime.fromMillisecondsSinceEpoch(r.timestamp),
                    action: r.action,
                    detail: r.detail,
                  ),
                )
                .toList(),
          );

  // endregion

  // region Mapping

  static int epochDay(DateTime d) =>
      DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 86400000;
  static DateTime fromEpochDay(int day) {
    final u = DateTime.fromMillisecondsSinceEpoch(day * 86400000, isUtc: true);
    return DateTime(u.year, u.month, u.day);
  }

  Patient _patient(PatientRow r) => Patient(
    id: r.id,
    medicalId: r.medicalId,
    firstName: r.firstName,
    lastName: r.lastName,
    dob: fromEpochDay(r.dobEpochDay),
    gender: Gender.values.byName(r.gender),
    ethnicity: r.ethnicity,
    phone: r.phone,
    email: r.email,
    bloodType: BloodType.values.byName(r.bloodType),
    allergies: r.allergies,
    medications: r.medications,
    conditions: r.conditions,
    examPurpose: r.examPurpose,
    examType: ExaminationType.values.byName(r.examType),
    performedBy: r.performedBy,
    referredBy: r.referredBy,
    consentGiven: r.consentGiven,
    consentAt: r.consentAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(r.consentAt!),
    fhirId: r.fhirId,
    createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(r.updatedAt),
  );

  VitalRecord _vital(VitalRow r) => VitalRecord(
    id: r.id,
    patientId: r.patientId,
    recordedAt: DateTime.fromMillisecondsSinceEpoch(r.recordedAt),
    systolic: r.systolic,
    diastolic: r.diastolic,
    heartRate: r.heartRate,
    heightCm: r.heightCm,
    weightKg: r.weightKg,
    temperatureC: r.temperatureC,
    respiratoryRate: r.respiratoryRate,
    spo2: r.spo2,
    painLevel: r.painLevel,
    symptoms: r.symptoms,
    fhirIds: r.fhirIds,
  );

  VitalsCompanion _vitalCompanion(VitalRecord v) => VitalsCompanion.insert(
    id: v.id,
    patientId: v.patientId,
    recordedAt: v.recordedAt.millisecondsSinceEpoch,
    systolic: Value(v.systolic),
    diastolic: Value(v.diastolic),
    heartRate: Value(v.heartRate),
    heightCm: Value(v.heightCm),
    weightKg: Value(v.weightKg),
    temperatureC: Value(v.temperatureC),
    respiratoryRate: Value(v.respiratoryRate),
    spo2: Value(v.spo2),
    painLevel: Value(v.painLevel),
    symptoms: Value(v.symptoms),
    fhirIds: Value(v.fhirIds),
  );

  // endregion
}

/// Opens the on-disk database encrypted with SQLCipher using [passphrase].
/// The file lives in app support storage, which is excluded from iOS backups below.
Future<AppDatabase> openEncryptedDatabase(String passphrase) async {
  final dir = await getApplicationSupportDirectory();
  await dir.create(recursive: true);
  final file = File(p.join(dir.path, 'patient_health.db'));
  final key = passphrase.replaceAll("'", "''");
  return AppDatabase(
    NativeDatabase.createInBackground(
      file,
      setup: (Database db) {
        db.execute("PRAGMA key = '$key'");
        assert(
          db.select('PRAGMA cipher_version').isNotEmpty,
          'SQLCipher is not linked; the database would be unencrypted',
        );
      },
    ),
  );
}
