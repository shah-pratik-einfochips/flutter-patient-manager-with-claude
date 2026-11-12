NOTE: This is a read-only file. Do not modify it.

## Requirement Gathering
* Collaborate with stakeholders to capture functional and non-functional requirements.
* Prepare user stories, acceptance criteria, and feature backlog.
* Conduct feasibility analysis for Flutter on Android and iOS, including plugin support, background execution, permissions, push notifications, and offline sync.
* Collect performance and security expectations to be considered in the architecture phase.
* Create a requirement traceability matrix to map business needs with app features.

## Design & Documentation
* Design application architecture (MVVM or Clean Architecture) with clear presentation, domain, and data layers.
* Create UI/UX wireframes, flow diagrams, and navigation architecture with adaptive Material and Cupertino patterns.
* Define data flow diagrams, sequence diagrams, and class structures.
* Document technical decisions including state management, plugins, third-party dependencies, and native integrations.
* Provide developer onboarding documentation with coding standards and project guidelines.

## Application Setup & Code Generation
* Create a new Flutter application using the stable Flutter SDK and Dart with a feature-based modular structure.
* Configure Android flavors and iOS schemes for multiple environments (Dev, QA, Prod).
* Configure pubspec.yaml and lock application dependencies for reproducible builds.
* Configure local data models, entity relationships, and database migrations using a maintained persistence library with an appropriate encryption strategy.
* Implement navigation using go_router and state management using Riverpod.
* Configure networking, serialization, dependency injection, and repository interfaces.
* Set up Android app signing and iOS signing/provisioning, keeping credentials outside source control.
* Implement code generation using build_runner and json_serializable where appropriate.
* Establish coding guidelines and reusable templates to accelerate feature development.

## Code Analysis, Refactoring & Enhancement
* Run dart format and flutter analyze with the project's lint rules.
* Refactor duplicate or legacy code into reusable widgets, services, and packages.
* Review memory usage and resource disposal using Flutter DevTools.
* Suggest modularization ensuring scalability and backward compatibility on Android and iOS.
* Apply coding standards to improve readability and long-term maintainability.

## Unit Testing Automation
* Configure flutter_test for unit and widget testing and integration_test for end-to-end testing.
* Develop positive and negative test cases for critical modules, asynchronous behavior, and platform boundaries.
* Implement widget, golden, and integration tests for UI consistency.
* Analyze code coverage using flutter test --coverage and generate readable reports.
* Document test cases with pass/fail reports for the QA team.

## Migration & Compatibility
* Upgrade Flutter, Dart, packages, and native build tooling to compatible stable versions.
* Resolve deprecated APIs, plugin breaking changes, and native configuration changes.
* Define minimum Android and iOS versions based on selected SDK and plugin requirements.
* Implement and test local database schema migrations without losing patient data.
* Validate compatibility across Android and iOS versions, phones, tablets, and screen sizes.

## Consulting – SOLID Principles & Best Practices
* Review the codebase for SOLID violations and recommend modular refactoring.
* Suggest dependency injection, immutable state, and clear asynchronous error handling.
* Recommend reusable and accessible widgets with adaptive platform behavior.
* Document coding standards for scalable Flutter projects.
* Propose guidelines for privacy-safe logging, crash reporting, platform channels, and plugin selection.

## Analysis of Potential Performance Issues
* Identify bottlenecks using Flutter DevTools CPU, memory, and frame performance views in profile mode.
* Optimize database queries, indexes, pagination, and transaction usage.
* Avoid blocking the UI isolate; use background isolates for suitable CPU-heavy work.
* Minimize unnecessary widget rebuilds and use lazy lists for large datasets.
* Implement image caching and appropriately sized image decoding if required.
* Reduce app launch time and evaluate application size for Android and iOS release builds.
* Implement background sync using supported platform integrations while respecting native execution limits.
