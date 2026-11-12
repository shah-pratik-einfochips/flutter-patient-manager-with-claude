import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/patient_detail_screen.dart';
import 'presentation/screens/patient_form_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/vitals_entry_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const HomeScreen(),
      routes: [
        GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen()),
        GoRoute(
          path: 'patient/new',
          builder: (_, _) => const PatientFormScreen(),
        ),
        GoRoute(
          path: 'patient/:id',
          builder: (_, s) =>
              PatientDetailScreen(patientId: s.pathParameters['id']!),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (_, s) =>
                  PatientFormScreen(patientId: s.pathParameters['id']),
            ),
            GoRoute(
              path: 'vitals',
              builder: (_, s) =>
                  VitalsEntryScreen(patientId: s.pathParameters['id']!),
            ),
            GoRoute(
              path: 'dashboard',
              builder: (_, s) =>
                  DashboardScreen(patientId: s.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Builds the app theme. Material 3 with a teal seed; large touch targets come from the defaults.
ThemeData buildTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00796B),
    brightness: brightness,
  ),
  visualDensity: VisualDensity.standard,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

class PatientHealthApp extends ConsumerWidget {
  const PatientHealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Patient Health',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(Brightness.light),
    darkTheme: buildTheme(Brightness.dark),
    routerConfig: _router,
  );
}
