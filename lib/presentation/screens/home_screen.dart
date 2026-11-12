import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models.dart';
import '../providers.dart';
import '../widgets/common.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _query = '';

  static int _age(DateTime dob) {
    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day))
      age--;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/patient/new'),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add patient'),
      ),
      body: AdaptiveBody(
        child: patients.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load patients: $e')),
          data: (all) {
            final q = _query.trim().toLowerCase();
            final list = q.isEmpty
                ? all
                : all
                      .where(
                        (p) =>
                            p.fullName.toLowerCase().contains(q) ||
                            p.medicalId.toLowerCase().contains(q),
                      )
                      .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchBar(
                    hintText: 'Search by name or medical ID',
                    leading: const Icon(Icons.search),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              all.isEmpty
                                  ? 'No patients yet.\nTap “Add patient” to register one.'
                                  : 'No patients match your search.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 96),
                          itemCount: list.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (_, i) => _PatientTile(
                            patient: list[i],
                            age: _age(list[i].dob),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PatientTile extends StatelessWidget {
  const _PatientTile({required this.patient, required this.age});
  final Patient patient;
  final int age;

  @override
  Widget build(BuildContext context) => ListTile(
    minVerticalPadding: 12,
    leading: CircleAvatar(
      child: Text(
        patient.firstName.isEmpty ? '?' : patient.firstName[0].toUpperCase(),
      ),
    ),
    title: Text(patient.fullName),
    subtitle: Text(
      'ID ${patient.medicalId} · $age yrs · ${patient.gender.title}',
    ),
    trailing: Icon(
      patient.fhirId == null
          ? Icons.cloud_off_outlined
          : Icons.cloud_done_outlined,
      semanticLabel: patient.fhirId == null ? 'Not uploaded' : 'Uploaded',
    ),
    onTap: () => context.go('/patient/${patient.id}'),
  );
}
