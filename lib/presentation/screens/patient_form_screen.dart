import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/patient_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../domain/validation_service.dart';
import '../providers.dart';
import '../widgets/common.dart';

/// Registers a new patient or edits an existing one ([patientId] set).
class PatientFormScreen extends ConsumerStatefulWidget {
  const PatientFormScreen({super.key, this.patientId});
  final String? patientId;

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _medicalId = TextEditingController();
  final _ethnicity = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _allergies = TextEditingController();
  final _medications = TextEditingController();
  final _conditions = TextEditingController();
  final _purpose = TextEditingController();
  final _performedBy = TextEditingController();
  final _referredBy = TextEditingController();

  DateTime? _dob;
  bool _dobTouched = false;
  Gender _gender = Gender.unknown;
  BloodType _bloodType = BloodType.unknown;
  ExaminationType _examType = ExaminationType.routineCheckup;
  bool _consent = false;
  DateTime? _consentAt;
  Patient? _existing;
  bool _loaded = false;
  bool _saving = false;
  String? _saveError;

  bool get _isNew => widget.patientId == null;

  List<TextEditingController> get _all => [
    _first,
    _last,
    _medicalId,
    _ethnicity,
    _phone,
    _email,
    _allergies,
    _medications,
    _conditions,
    _purpose,
    _performedBy,
    _referredBy,
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.patientId;
    if (id != null) {
      final p = await ref.read(repositoryProvider).getPatient(id);
      if (p != null && mounted) {
        setState(() {
          _existing = p;
          _first.text = p.firstName;
          _last.text = p.lastName;
          _medicalId.text = p.medicalId;
          _ethnicity.text = p.ethnicity;
          _phone.text = p.phone;
          _email.text = p.email;
          _allergies.text = p.allergies;
          _medications.text = p.medications;
          _conditions.text = p.conditions;
          _purpose.text = p.examPurpose;
          _performedBy.text = p.performedBy;
          _referredBy.text = p.referredBy;
          _dob = p.dob;
          _gender = p.gender;
          _bloodType = p.bloodType;
          _examType = p.examType;
          _consent = p.consentGiven;
          _consentAt = p.consentAt;
        });
      }
    }
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30),
      firstDate: DateTime(now.year - 150),
      lastDate: now,
      helpText: 'Date of birth',
    );
    setState(() {
      _dobTouched = true;
      if (picked != null) _dob = picked;
    });
  }

  Future<void> _save() async {
    setState(() => _dobTouched = true);
    final valid =
        _formKey.currentState!.validate() &&
        ValidationService.validateDateOfBirth(_dob).isValid;
    if (!valid) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    final base = _existing;
    final patient =
        (base ??
                Patient(medicalId: '', firstName: '', lastName: '', dob: _dob!))
            .copyWith(
              medicalId: _medicalId.text.trim(),
              firstName: _first.text.trim(),
              lastName: _last.text.trim(),
              dob: _dob,
              gender: _gender,
              ethnicity: _ethnicity.text.trim(),
              phone: _phone.text.trim(),
              email: _email.text.trim(),
              bloodType: _bloodType,
              allergies: _allergies.text.trim(),
              medications: _medications.text.trim(),
              conditions: _conditions.text.trim(),
              examPurpose: _purpose.text.trim(),
              examType: _examType,
              performedBy: _performedBy.text.trim(),
              referredBy: _referredBy.text.trim(),
              consentGiven: _consent,
              consentAt: _consent ? (_consentAt ?? DateTime.now()) : null,
              clearConsentAt: !_consent,
            );
    try {
      await ref.read(repositoryProvider).savePatient(patient, isNew: _isNew);
      if (mounted) context.pop();
    } on DuplicateMedicalIdException catch (e) {
      setState(() => _saveError = e.toString());
    } catch (e) {
      setState(() => _saveError = 'Could not save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _check(ValidationResult r) => r.error;

  @override
  Widget build(BuildContext context) {
    final dobError = _dobTouched
        ? ValidationService.validateDateOfBirth(_dob).error
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New patient' : 'Edit patient'),
        actions: [
          TextButton(
            onPressed: _saving || !_loaded ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : AdaptiveBody(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    const SectionTitle('Demographics'),
                    _field(
                      _first,
                      'First name',
                      validator: (v) => _check(
                        ValidationService.validateName(v ?? '', 'First name'),
                      ),
                      cap: TextCapitalization.words,
                    ),
                    _field(
                      _last,
                      'Last name',
                      validator: (v) => _check(
                        ValidationService.validateName(v ?? '', 'Last name'),
                      ),
                      cap: TextCapitalization.words,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: _pickDob,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of birth',
                            errorText: dobError,
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                            ),
                          ),
                          child: Text(
                            _dob == null
                                ? 'Select date'
                                : DateFormat.yMMMd().format(_dob!),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EnumDropdown<Gender>(
                        label: 'Gender',
                        value: _gender,
                        values: Gender.values,
                        labelOf: (g) => g.title,
                        onChanged: (v) => setState(() => _gender = v),
                      ),
                    ),
                    _field(_ethnicity, 'Ethnicity (optional)'),
                    const SectionTitle('Contact'),
                    _field(
                      _phone,
                      'Phone (optional)',
                      keyboard: TextInputType.phone,
                      validator: (v) =>
                          _check(ValidationService.validatePhone(v ?? '')),
                    ),
                    _field(
                      _email,
                      'Email (optional)',
                      keyboard: TextInputType.emailAddress,
                      validator: (v) =>
                          _check(ValidationService.validateEmail(v ?? '')),
                    ),
                    const SectionTitle('Medical'),
                    _field(
                      _medicalId,
                      'Medical ID',
                      validator: (v) =>
                          _check(ValidationService.validateMedicalId(v ?? '')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EnumDropdown<BloodType>(
                        label: 'Blood type',
                        value: _bloodType,
                        values: BloodType.values,
                        labelOf: (b) => b.label,
                        onChanged: (v) => setState(() => _bloodType = v),
                      ),
                    ),
                    _field(_allergies, 'Allergies (optional)', lines: 2),
                    _field(_medications, 'Medications (optional)', lines: 2),
                    _field(
                      _conditions,
                      'Health conditions (optional)',
                      lines: 2,
                    ),
                    const SectionTitle('Examination'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EnumDropdown<ExaminationType>(
                        label: 'Type of examination',
                        value: _examType,
                        values: ExaminationType.values,
                        labelOf: (e) => e.label,
                        onChanged: (v) => setState(() => _examType = v),
                      ),
                    ),
                    _field(_purpose, 'Purpose of examination (optional)'),
                    _field(_performedBy, 'Performed by (optional)'),
                    _field(_referredBy, 'Referred by (optional)'),
                    const SectionTitle('Privacy'),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _consent,
                      onChanged: (v) => setState(() => _consent = v),
                      title: const Text(
                        'Patient consents to storing data on the health server',
                      ),
                      subtitle: const Text(
                        'Without consent, data stays on this device and is never uploaded.',
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: Text(_saving ? 'Saving…' : 'Save patient'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    String? Function(String?)? validator,
    TextInputType? keyboard,
    int lines = 1,
    TextCapitalization cap = TextCapitalization.none,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      validator: validator,
      keyboardType: keyboard,
      minLines: lines,
      maxLines: lines,
      textCapitalization: cap,
      decoration: InputDecoration(labelText: label),
    ),
  );
}
