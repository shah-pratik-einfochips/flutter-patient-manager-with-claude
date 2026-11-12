import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../domain/unit_conversion.dart';
import '../../domain/validation_service.dart';
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
  final _sys = TextEditingController();
  final _dia = TextEditingController();
  final _hr = TextEditingController();
  final _cm = TextEditingController();
  final _ft = TextEditingController();
  final _inch = TextEditingController();
  final _weight = TextEditingController();
  final _temp = TextEditingController();
  final _rr = TextEditingController();
  final _spo2 = TextEditingController();
  final _pain = TextEditingController();
  final _symptoms = TextEditingController();

  DateTime _when = DateTime.now();
  HeightUnit _heightUnit = HeightUnit.cm;
  WeightUnit _weightUnit = WeightUnit.kg;
  TemperatureUnit _tempUnit = TemperatureUnit.celsius;
  bool _saving = false;
  String? _saveError;

  List<TextEditingController> get _all => [
    _sys,
    _dia,
    _hr,
    _cm,
    _ft,
    _inch,
    _weight,
    _temp,
    _rr,
    _spo2,
    _pain,
    _symptoms,
  ];

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  double? _num(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));
  bool _has(TextEditingController c) => c.text.trim().isNotEmpty;

  // Canonical-unit values (null when empty or unparseable).
  double? get _heightCm => switch (_heightUnit) {
    HeightUnit.cm => _num(_cm),
    HeightUnit.ftIn =>
      _has(_ft) || _has(_inch)
          ? UnitConversion.cm(_num(_ft) ?? 0, _num(_inch) ?? 0)
          : null,
  };
  double? get _weightKg => _num(_weight) == null
      ? null
      : (_weightUnit == WeightUnit.kg
            ? _num(_weight)
            : UnitConversion.kg(_num(_weight)!));
  double? get _tempC => _num(_temp) == null
      ? null
      : (_tempUnit == TemperatureUnit.celsius
            ? _num(_temp)
            : UnitConversion.celsius(_num(_temp)!));

  /// Error for a field: unparseable text, or a value outside the hard limits.
  String? _error(TextEditingController c, VitalType type, double? canonical) {
    if (!_has(c)) return null;
    if (canonical == null) return 'Enter a number';
    return ValidationService.validateVital(canonical, type).error;
  }

  String? _bpPairError() {
    final s = _num(_sys), d = _num(_dia);
    if (_has(_sys) != _has(_dia)) return 'Enter both systolic and diastolic';
    if (s != null && d != null)
      return ValidationService.validateBloodPressurePair(s, d).error;
    return null;
  }

  bool _abnormal(double? v, VitalType t) =>
      v != null && ValidationService.isAbnormal(v, t);

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

  /// First error across all fields, or null when the form is ready to save.
  String? _blockingError() {
    final checks = [
      _error(_sys, VitalType.systolic, _num(_sys)),
      _error(_dia, VitalType.diastolic, _num(_dia)),
      _bpPairError(),
      _error(_hr, VitalType.heartRate, _num(_hr)),
      _error(
        _heightUnit == HeightUnit.cm ? _cm : (_has(_ft) ? _ft : _inch),
        VitalType.height,
        _heightCm,
      ),
      _error(_weight, VitalType.weight, _weightKg),
      _error(_temp, VitalType.temperature, _tempC),
      _error(_rr, VitalType.respiratoryRate, _num(_rr)),
      _error(_spo2, VitalType.spo2, _num(_spo2)),
      _error(_pain, VitalType.painLevel, _num(_pain)),
      ValidationService.validateRecordedAt(_when).error,
    ];
    return checks.whereType<String>().firstOrNull;
  }

  bool get _hasAnyValue => [
    _sys,
    _dia,
    _hr,
    _cm,
    _ft,
    _inch,
    _weight,
    _temp,
    _rr,
    _spo2,
    _pain,
  ].any(_has);

  Future<void> _save() async {
    final error = _blockingError();
    if (error != null || !_hasAnyValue) {
      setState(() => _saveError = error ?? 'Enter at least one measurement');
      return;
    }
    setState(() {
      _saving = true;
      _saveError = null;
    });
    final record = VitalRecord(
      patientId: widget.patientId,
      recordedAt: _when,
      systolic: _num(_sys),
      diastolic: _num(_dia),
      heartRate: _num(_hr),
      heightCm: _heightCm,
      weightKg: _weightKg,
      temperatureC: _tempC,
      respiratoryRate: _num(_rr),
      spo2: _num(_spo2),
      painLevel: _num(_pain),
      symptoms: _symptoms.text.trim(),
    );
    try {
      await ref.read(repositoryProvider).addVitals(record);
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _saveError = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _num(_sys), d = _num(_dia);
    final map = s != null && d != null && d < s
        ? UnitConversion.meanArterialPressure(s, d)
        : null;
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
              subtitle: Text(DateFormat.yMMMd().add_jm().format(_when)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickDateTime,
            ),
            const SectionTitle('Blood pressure'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _numberField(
                    _sys,
                    'Systolic (mmHg)',
                    VitalType.systolic,
                    _num(_sys),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _numberField(
                    _dia,
                    'Diastolic (mmHg)',
                    VitalType.diastolic,
                    _num(_dia),
                  ),
                ),
              ],
            ),
            if (_bpPairError() case final e?)
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
                  'MAP (calculated): ${map == null ? '–' : '$map mmHg'}${_abnormal(map, VitalType.map) ? '  ⚠ Outside normal range' : ''}',
                ),
              ),
            ),
            const SectionTitle('Heart and breathing'),
            _numberField(
              _hr,
              'Heart rate (bpm)',
              VitalType.heartRate,
              _num(_hr),
            ),
            _numberField(
              _rr,
              'Respiratory rate (breaths/min)',
              VitalType.respiratoryRate,
              _num(_rr),
            ),
            _numberField(
              _spo2,
              'SpO₂ - oxygen saturation (%)',
              VitalType.spo2,
              _num(_spo2),
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
              _numberField(_cm, 'Height (cm)', VitalType.height, _heightCm)
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _numberField(
                      _ft,
                      'Feet',
                      VitalType.height,
                      _heightCm,
                      integer: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberField(
                      _inch,
                      'Inches',
                      VitalType.height,
                      _heightCm,
                      validate: false,
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
              _weight,
              'Weight (${_weightUnit.label})',
              VitalType.weight,
              _weightKg,
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
              _temp,
              'Temperature (${_tempUnit.label})',
              VitalType.temperature,
              _tempC,
            ),
            const SectionTitle('Symptoms'),
            _numberField(
              _pain,
              'Pain level (0–10)',
              VitalType.painLevel,
              _num(_pain),
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
    TextEditingController c,
    String label,
    VitalType type,
    double? canonical, {
    bool integer = false,
    bool validate = true,
  }) {
    final error = validate
        ? _error(c, type, canonical)
        : (_has(c) && _num(c) == null ? 'Enter a number' : null);
    final abnormal =
        error == null &&
        _abnormal(canonical, type) &&
        type != VitalType.height &&
        type != VitalType.weight;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
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
