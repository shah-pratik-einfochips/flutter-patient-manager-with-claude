import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/environment.dart';
import '../providers.dart';
import '../widgets/common.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _token = TextEditingController();

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final env = ref.watch(environmentProvider);
    final audit = ref.watch(auditProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AdaptiveBody(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle('Server environment'),
            SegmentedButton<AppEnvironment>(
              segments: [
                for (final e in AppEnvironment.values)
                  ButtonSegment(value: e, label: Text(e.title)),
              ],
              selected: {env},
              onSelectionChanged: (v) =>
                  ref.read(environmentProvider.notifier).select(v.first),
            ),
            const SizedBox(height: 8),
            Text(env.baseUrl, style: Theme.of(context).textTheme.bodySmall),
            if (env == AppEnvironment.staging)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'The public test server is shared and not private. Use synthetic data only.',
                ),
              ),
            const SectionTitle('Access token'),
            TextField(
              controller: _token,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Bearer token (optional)',
                helperText: 'Stored in the Keychain / Android Keystore',
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: () async {
                  await ref
                      .read(secureStoreProvider)
                      .saveToken(_token.text.trim());
                  _token.clear();
                  if (context.mounted) showMessage(context, 'Token saved');
                },
                child: const Text('Save token'),
              ),
            ),
            const SectionTitle('Audit log'),
            const Text(
              'Records actions and patient IDs only - never clinical values.',
            ),
            audit.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Text('$e'),
              data: (entries) => entries.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No activity yet.'),
                    )
                  : Column(
                      children: [
                        for (final e in entries)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(e.action),
                            subtitle: Text(
                              '${DateFormat.yMMMd().add_jms().format(e.timestamp)}${e.detail.isEmpty ? '' : ' · ${e.detail}'}',
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
