import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/enums.dart';
import '../../domain/vitals_entry.dart';
import '../providers.dart';
import '../widgets/common.dart';

/// Records one set of vitals; values are validated live and converted to canonical units on save.
class VitalsEntryScreen extends ConsumerStatefulWidget {
  const VitalsEntryScreen({super.key, required this.patientId});
  final String patientId;

  @override
  ConsumerState<VitalsEntryScreen> createState() => _VitalsEntryScreenState();
}

class _VitalsEntryScreenState extends ConsumerState<VitalsEntryScreen> {
  final _fields = {
    for (final f in VitalsField.values) f: TextEditingController(),
  };
  final _symptoms = TextEditingController();

  DateTime _when = DateTime.now();
  HeightUnit _heightUnit = HeightUnit.cm;
  WeightUnit _weightUnit = WeightUnit.kg;
  TemperatureUnit _tempUnit = TemperatureUnit.celsius;
  bool _saving = false;
  String? _saveError;

  @override
  void dispose() {
    for (final c in [..._fields.values, _symptoms]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Snapshot of the form; all parsing and validation rules live in [VitalsEntry].
  VitalsEntry get _entry => VitalsEntry(
    recordedAt: _when,
    text: {
      for (final MapEntry(:key, :value) in _fields.entries) key: value.text,
    },
    heightUnit: _heightUnit,
    weightUnit: _weightUnit,
    temperatureUnit: _tempUnit,
    symptoms: _symptoms.text,
  );

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (!mounted) return;
    setState(
      () => _when = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _when.hour,
        time?.minute ?? _when.minute,
      ),
    );
  }

  Future<void> _save() async {
    final entry = _entry;
    final error = entry.blockingError;
    if (error != null || !entry.hasAnyValue) {
      setState(() => _saveError = error ?? 'Enter at least one measurement');
      return;
    }
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await ref
          .read(repositoryProvider)
          .addVitals(entry.toRecord(widget.patientId));
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _saveError = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = _entry;
    final map = entry.map;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record vitals'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: AdaptiveBody(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_saveError != null)
              Semantics(
                liveRegion: true,
                child: Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: Text(_saveError!),
                  ),
                ),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: const Text('Measured on'),
              subtitle: Text(formatDateTime(_when)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickDateTime,
            ),
            const SectionTitle('Blood pressure'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _numberField(
                    entry,
                    VitalsField.systolic,
                    'Systolic (mmHg)',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _numberField(
                    entry,
                    VitalsField.diastolic,
                    'Diastolic (mmHg)',
                  ),
                ),
              ],
            ),
            if (entry.bloodPressurePairError case final e?)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  e,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Semantics(
              label: 'Mean arterial pressure, calculated',
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'MAP (calculated): ${map == null ? '–' : '$map mmHg'}${entry.isMapAbnormal ? '  ⚠ Outside normal range' : ''}',
                ),
              ),
            ),
            const SectionTitle('Heart and breathing'),
            _numberField(entry, VitalsField.heartRate, 'Heart rate (bpm)'),
            _numberField(
              entry,
              VitalsField.respiratoryRate,
              'Respiratory rate (breaths/min)',
            ),
            _numberField(
              entry,
              VitalsField.spo2,
              'SpO₂ - oxygen saturation (%)',
            ),
            const SectionTitle('Body measurements'),
            SegmentedButton<HeightUnit>(
              segments: [
                for (final u in HeightUnit.values)
                  ButtonSegment(value: u, label: Text('Height ${u.label}')),
              ],
              selected: {_heightUnit},
              onSelectionChanged: (v) => setState(() => _heightUnit = v.first),
            ),
            const SizedBox(height: 12),
            if (_heightUnit == HeightUnit.cm)
              _numberField(entry, VitalsField.heightCm, 'Height (cm)')
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _numberField(
                      entry,
                      VitalsField.heightFeet,
                      'Feet',
                      integer: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberField(
                      entry,
                      VitalsField.heightInches,
                      'Inches',
                    ),
                  ),
                ],
              ),
            SegmentedButton<WeightUnit>(
              segments: [
                for (final u in WeightUnit.values)
                  ButtonSegment(value: u, label: Text('Weight ${u.label}')),
              ],
              selected: {_weightUnit},
              onSelectionChanged: (v) => setState(() => _weightUnit = v.first),
            ),
            const SizedBox(height: 12),
            _numberField(
              entry,
              VitalsField.weight,
              'Weight (${_weightUnit.label})',
            ),
            SegmentedButton<TemperatureUnit>(
              segments: [
                for (final u in TemperatureUnit.values)
                  ButtonSegment(
                    value: u,
                    label: Text('Temperature ${u.label}'),
                  ),
              ],
              selected: {_tempUnit},
              onSelectionChanged: (v) => setState(() => _tempUnit = v.first),
            ),
            const SizedBox(height: 12),
            _numberField(
              entry,
              VitalsField.temperature,
              'Temperature (${_tempUnit.label})',
            ),
            const SectionTitle('Symptoms'),
            _numberField(
              entry,
              VitalsField.painLevel,
              'Pain level (0–10)',
              integer: true,
            ),
            TextField(
              controller: _symptoms,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Symptoms (optional)',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving…' : 'Save vitals'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Numeric field with live range validation and a non-colour "outside normal range" caption.
  Widget _numberField(
    VitalsEntry entry,
    VitalsField field,
    String label, {
    bool integer = false,
  }) {
    final error = entry.error(field);
    final abnormal = entry.isAbnormal(field);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _fields[field],
        keyboardType: TextInputType.numberWithOptions(decimal: !integer),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(integer ? r'[0-9]' : r'[0-9.,]'),
          ),
        ],
        onChanged: (_) => setState(() => _saveError = null),
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          helperText: abnormal ? '⚠ Outside normal range' : null,
          helperStyle: abnormal
              ? const TextStyle(fontWeight: FontWeight.w600)
              : null,
          prefixIcon: abnormal
              ? const Icon(
                  Icons.warning_amber_rounded,
                  semanticLabel: 'Outside normal range',
                )
              : null,
        ),
      ),
    );
  }
}
