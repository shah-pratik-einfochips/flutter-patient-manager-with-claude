import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../domain/unit_conversion.dart';
import '../../domain/validation_service.dart';
import '../providers.dart';
import '../widgets/common.dart';

class PatientDetailScreen extends ConsumerStatefulWidget {
  const PatientDetailScreen({super.key, required this.patientId});
  final String patientId;

  @override
  ConsumerState<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen> {
  bool _busy = false;

  Future<void> _run(
    String doing,
    Future<void> Function() action,
    String done,
  ) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) showMessage(context, done);
    } catch (e) {
      if (mounted) showMessage(context, '$doing failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete(Patient p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete patient?'),
        content: Text(
          '${p.fullName} and all of their vitals will be removed from this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(repositoryProvider).deletePatient(p.id);
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = ref.watch(patientProvider(widget.patientId));
    final vitals = ref.watch(vitalsProvider(widget.patientId));
    final repo = ref.read(repositoryProvider);

    return patient.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('$e')),
      ),
      data: (p) {
        if (p == null)
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Patient not found.')),
          );
        return Scaffold(
          appBar: AppBar(
            title: Text(p.fullName),
            actions: [
              IconButton(
                tooltip: 'Edit patient',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.go('/patient/${p.id}/edit'),
              ),
              IconButton(
                tooltip: 'Delete patient',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(p),
              ),
            ],
          ),
          body: AdaptiveBody(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_busy) const LinearProgressIndicator(),
                _Summary(patient: p),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.go('/patient/${p.id}/vitals'),
                      icon: const Icon(Icons.monitor_heart_outlined),
                      label: const Text('Record vitals'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => context.go('/patient/${p.id}/dashboard'),
                      icon: const Icon(Icons.show_chart),
                      label: const Text('Dashboard'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _run(
                              'Upload',
                              () => repo.push(p.id),
                              'Uploaded to the health server',
                            ),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Upload'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _run(
                              'Download',
                              () => repo.pull(p.id),
                              'Downloaded latest data',
                            ),
                      icon: const Icon(Icons.cloud_download_outlined),
                      label: const Text('Download'),
                    ),
                  ],
                ),
                const SectionTitle('Recent vitals'),
                vitals.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('$e'),
                  data: (list) => list.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('No vitals recorded yet.'),
                        )
                      : Column(
                          children: [
                            for (final r in list.take(10))
                              _VitalTile(record: r),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.patient});
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Medical ID', patient.medicalId),
      ('Date of birth', DateFormat.yMMMd().format(patient.dob)),
      ('Gender', patient.gender.title),
      ('Blood type', patient.bloodType.label),
      if (patient.phone.isNotEmpty) ('Phone', patient.phone),
      if (patient.email.isNotEmpty) ('Email', patient.email),
      if (patient.allergies.isNotEmpty) ('Allergies', patient.allergies),
      if (patient.medications.isNotEmpty) ('Medications', patient.medications),
      if (patient.conditions.isNotEmpty) ('Conditions', patient.conditions),
      ('Examination', patient.examType.label),
      if (patient.examPurpose.isNotEmpty) ('Purpose', patient.examPurpose),
      if (patient.performedBy.isNotEmpty) ('Performed by', patient.performedBy),
      if (patient.referredBy.isNotEmpty) ('Referred by', patient.referredBy),
      (
        'Consent',
        patient.consentGiven
            ? 'Given${patient.consentAt == null ? '' : ' on ${DateFormat.yMMMd().format(patient.consentAt!)}'}'
            : 'Not given - data is not uploaded',
      ),
      ('Server', patient.fhirId == null ? 'Not uploaded' : 'Uploaded'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Text(value)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({required this.record});
  final VitalRecord record;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    var abnormal = false;
    for (final t in [
      VitalType.systolic,
      VitalType.heartRate,
      VitalType.temperature,
      VitalType.spo2,
      VitalType.respiratoryRate,
    ]) {
      final v = record.value(t);
      if (v == null) continue;
      final bad = ValidationService.isAbnormal(v, t);
      abnormal = abnormal || bad;
      if (t == VitalType.systolic && record.diastolic != null) {
        parts.add(
          'BP ${v.roundTo(0).toInt()}/${record.diastolic!.roundTo(0).toInt()}${bad ? '⚠' : ''}',
        );
      } else if (t != VitalType.systolic) {
        parts.add('${_short[t]} ${v.roundTo(1)}${bad ? '⚠' : ''}');
      }
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        abnormal ? Icons.warning_amber_rounded : Icons.check_circle_outline,
        semanticLabel: abnormal
            ? 'Contains abnormal values'
            : 'All values normal',
      ),
      title: Text(DateFormat.yMMMd().add_jm().format(record.recordedAt)),
      subtitle: Text(parts.isEmpty ? 'Other measurements' : parts.join(' · ')),
    );
  }

  static const _short = {
    VitalType.heartRate: 'HR',
    VitalType.temperature: 'Temp',
    VitalType.spo2: 'SpO₂',
    VitalType.respiratoryRate: 'RR',
  };
}
