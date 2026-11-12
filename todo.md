NOTE: This is a read-only file. Do not modify it.

# Patient Health Management Module - Flutter Application

## Overview
A cross-platform Flutter application for Android phones/tablets and iPhone/iPad that enables healthcare staff and patients to manage patient demographic data and daily vitals, storing them securely in a FHIR-compliant backend with visualization and reporting capabilities.

## Scope
Develop a shared Flutter application for Android and iOS that allows healthcare staff or patients to manage patient demographic data and daily vitals, storing them securely in a FHIR-compliant backend with visualization and reporting capabilities. Web and desktop are outside the initial scope.

All tasks below are planned; completion must be verified during implementation.

## Features

### 1. Patient Information Management
- [ ] Register and manage patient profiles with comprehensive demographic data:
  - First name, last name, date of birth, gender, ethnicity
  - Contact information (phone, email)
  - Medical ID, blood type, allergies, medications, health conditions
- [ ] Validate demographic fields, including mandatory ID and dates of birth not in the future.
- [ ] Map demographics to FHIR Patient resources and clinical details to appropriate linked FHIR resources.
- [ ] Implement data privacy controls and consent management to support applicable HIPAA/GDPR obligations.
- [ ] Track examination purpose, type, performed by, and referral by.
- [ ] Provide a dropdown for type of examination with these options: Routine checkup, Emergency, Follow-up, Consultation, Diagnostic, Preventive.

### 2. Vitals Entry
- [ ] Implement vitals input and unit conversions:
  - Blood pressure: systolic, diastolic, and auto-calculated MAP
  - Heart rate (bpm)
  - Height (cm / ft and in)
  - Weight (lbs / kg)
  - Temperature (C / F)
  - Respiratory rate (breaths/min)
  - SpO2 (blood oxygen saturation %)
  - Pain level (0-10 scale)
  - Symptoms (free text)
- [ ] Provide real-time validation against clinically approved ranges.
- [ ] Auto-fill the current date with an option to select past dates.
- [ ] Show abnormal-value indicators without relying on color alone.

### 3. Vitals Dashboard
- [ ] Visualize the past seven days of vitals.
- [ ] Provide tabular and interactive line-chart views.
- [ ] Highlight abnormal values with accessible indicators.
- [ ] Implement CSV and PDF exports with secure temporary file handling and native sharing on Android and iOS.
- [ ] Filter charts by vital type and display detailed vital statistics.

### 4. FHIR Integration
- [ ] Store demographics as FHIR Patient resources.
- [ ] Store vitals as FHIR Observation resources linked to the patient, with appropriate codes and units.
- [ ] Implement asynchronous API operations using Dart futures and streams.
- [ ] Retrieve and update patient data and vitals history.
- [ ] Support Development, Staging, and Production environments.
- [ ] Handle authentication, authorization, errors, and bounded retries without duplicate submissions.
- [ ] Implement offline handling, explicit conflict resolution, and background sync respecting Android and iOS execution limits.

### 5. Accessibility & Compliance
- [ ] Apply WCAG accessibility guidance and verify contrast ratios.
- [ ] Support TalkBack and VoiceOver using Flutter semantics and appropriate focus order.
- [ ] Support system text scaling and adequate touch target sizes.
- [ ] Clearly label clinical terms, input errors, and accessibility hints.
- [ ] Encrypt sensitive local data using a validated persistence and key-management solution.
- [ ] Implement privacy-safe audit logging and consent management.
- [ ] Review HIPAA/GDPR obligations across the app, backend, and operational processes.

## Technical Architecture

### Design Pattern: MVVM / Clean Architecture with Riverpod
Separate widgets, presentation state, domain logic, and data repositories; isolate platform-specific integrations behind interfaces.

### Technology Stack
- **Language**: Dart with sound null safety
- **Framework**: Flutter stable SDK
- **UI**: Adaptive Material and Cupertino widgets
- **State management and dependency injection**: Riverpod
- **Persistence**: Evaluate a maintained SQLite-based library with supported encryption and migrations on both platforms
- **Networking**: Dio with typed models and json_serializable
- **Navigation**: go_router
- **Charts**: Evaluate a maintained Flutter chart package for accessibility and licensing
- **Secure storage**: A maintained plugin backed by iOS Keychain and Android Keystore-based protection
- **Localization**: Flutter localization tooling and ARB resources
- **Minimum Android/iOS**: Define based on product requirements, Flutter SDK, and selected plugin support

## Code Quality Standards
- [ ] Follow Effective Dart and Flutter conventions with separation of concerns.
- [ ] Use immutable state and predictable asynchronous state transitions.
- [ ] Dispose controllers, subscriptions, and other resources correctly.
- [ ] Keep blocking computation off the UI isolate when appropriate.
- [ ] Implement comprehensive validation and sound null safety.
- [ ] Run dart format and flutter analyze.
- [ ] Provide accessible reusable widgets and platform-adaptive interactions.
- [ ] Complete PDF export, background sync, and localization.
- [ ] Optimize layouts for tablets, rotation, safe areas, and different screen sizes.

## Unit Testing Automation
Following requirements.md Unit Testing Automation section:
- [ ] Configure flutter_test and integration_test.
- [ ] Test validation, patient models, vitals models, and unit conversions with positive and negative cases.
- [ ] Test repositories, API failures, retries, and offline sync.
- [ ] Test Riverpod state transitions and dependency overrides.
- [ ] Add widget, golden, and accessibility tests.
- [ ] Run integration tests on Android and iOS, including native plugin behavior.
- [ ] Test local database migrations and encrypted persistence.
- [ ] Generate coverage with flutter test --coverage; establish coverage targets rather than claiming unmeasured results.
- [ ] Document pass/fail reports and integrate verification into CI/CD.

## Security & Privacy
- [ ] Encrypt sensitive data at rest and use secure TLS for all network communication.
- [ ] Protect encryption keys and tokens through platform-backed secure storage.
- [ ] Never embed backend secrets in Dart code, assets, or build-time environment values shipped with the app.
- [ ] Implement patient consent, access controls, and session expiration.
- [ ] Exclude sensitive data from logs, backups, crash reports, and exported files unless explicitly authorized.
- [ ] Assess HIPAA/GDPR compliance with appropriate security and legal review.

## Migration & Compatibility
Following requirements.md Migration & Compatibility section:
- [ ] Maintain compatible stable Flutter, Dart, package, and native build-tool versions.
- [ ] Resolve deprecated APIs, plugin breaking changes, and native configuration updates.
- [ ] Define and document minimum Android and iOS versions.
- [ ] Track database versions and implement tested schema migrations.
- [ ] Validate data integrity and document recovery strategies for failed upgrades.
- [ ] Maintain a compatibility matrix across Android and iOS versions.
- [ ] Verify phones, tablets, portrait, landscape, and platform-specific permissions.
- [ ] Verify release builds and signing separately for Android and iOS.

## Supported Devices
- Android phones and tablets within the agreed API support range
- iPhone and iPad within the agreed iOS support range
- Portrait and landscape orientations with adaptive layouts
