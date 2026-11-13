# Patient Health (Flutter)

Patient demographics and daily vitals for iOS and Android, with a FHIR R4 backend, a 7-day dashboard and CSV/PDF export. It follows the same domain rules as the native iOS and Android apps, which live in separate repositories.

## Architecture
Feature-light Clean Architecture, Riverpod for state and DI, go_router for navigation.

- `lib/domain` – pure Dart: enums, models, validation, unit conversion, dashboard maths
- `lib/data` – drift + SQLCipher database, FHIR mapper and Dio client (bounded retries), repository, export, background sync
- `lib/presentation` – providers, screens, shared widgets
- `lib/debug` – demo data, enabled only with `--dart-define=SEED_DEMO=true` in debug builds

## Run
```bash
flutter pub get
dart run build_runner build      # regenerates database.g.dart
flutter run --dart-define=SEED_DEMO=true
flutter test --coverage
```
Development targets `localhost:8080/fhir` (`10.0.2.2` on the Android emulator). Staging is the public HAPI test server: synthetic data only.

## Security
- Local database encrypted with SQLCipher; the random key lives in Keychain / Keystore (`flutter_secure_storage`).
- iOS: storage directory excluded from backup and file-protected (`AppDelegate.swift`).
- Uploads only for patients who gave consent. Audit log stores actions and IDs only.

## Known gaps
No Android flavors / iOS schemes (environment is a runtime setting), no localization, no integration_test or golden tests, PDF uses the built-in Latin-1 font, no session expiry.
