import 'dart:io';

enum AppEnvironment {
  development('Development'),
  staging('Staging'),
  production('Production');

  const AppEnvironment(this.title);
  final String title;

  /// Base URL of the FHIR server. Development targets a local HAPI server;
  /// the Android emulator reaches the host machine at 10.0.2.2.
  String get baseUrl => switch (this) {
    development =>
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8080/fhir',
    staging => 'https://hapi.fhir.org/baseR4',
    production => 'https://fhir.example.com/fhir',
  };
}
