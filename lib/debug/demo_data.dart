import '../data/database.dart';
import '../domain/enums.dart';
import '../domain/models.dart';

/// Debug-only sample data, enabled with `--dart-define=SEED_DEMO=true`.
/// Synthetic values only; the guard in main() keeps this out of release builds.
const seedDemoData = bool.fromEnvironment('SEED_DEMO');

Future<void> seedDemo(AppDatabase db) async {
  if ((await db.watchPatients().first).isNotEmpty) return;
  final p = Patient(
    id: 'demo-patient',
    medicalId: 'MRN-1001',
    firstName: 'Demo',
    lastName: 'Patient',
    dob: DateTime(1985, 3, 14),
    gender: Gender.female,
    bloodType: BloodType.oPos,
    allergies: 'Penicillin',
    consentGiven: true,
    consentAt: DateTime.now(),
  );
  await db.upsertPatient(p);
  final now = DateTime.now();
  const hr = [72.0, 58.0, 68.0, 130.0, 75.0, 88.0, 72.0];
  const sys = [118.0, 122.0, 135.0, 150.0, 116.0, 124.0, 119.0];
  const dia = [76.0, 80.0, 88.0, 96.0, 74.0, 82.0, 78.0];
  const temp = [36.6, 36.8, 37.0, 38.4, 36.7, 36.5, 36.6];
  const spo2 = [98.0, 97.0, 96.0, 93.0, 98.0, 99.0, 98.0];
  for (var i = 0; i < 7; i++) {
    await db.insertVital(
      VitalRecord(
        patientId: p.id,
        recordedAt: now.subtract(Duration(days: 6 - i, hours: 1)),
        systolic: sys[i],
        diastolic: dia[i],
        heartRate: hr[i],
        temperatureC: temp[i],
        respiratoryRate: 16,
        spo2: spo2[i],
        painLevel: i == 3 ? 6 : 1,
        weightKg: 64,
        heightCm: 168,
        symptoms: i == 3 ? 'fever, chills "mild"' : '',
      ),
    );
  }
}
