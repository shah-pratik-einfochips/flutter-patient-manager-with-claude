import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Dropdown with a visible label, used for enum pickers.
class EnumDropdown<T> extends StatelessWidget {
  const EnumDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });
  final String label;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
    initialValue: value,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      for (final v in values)
        DropdownMenuItem(value: v, child: Text(labelOf(v))),
    ],
    onChanged: (v) {
      if (v != null) onChanged(v);
    },
  );
}

/// A section heading that screen readers announce as a header.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
  );
}

/// Constrains content to a readable width on tablets and in landscape.
class AdaptiveBody extends StatelessWidget {
  const AdaptiveBody({super.key, required this.child, this.maxWidth = 720});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

String formatDate(DateTime d) => DateFormat.yMMMd().format(d);

String formatDateTime(DateTime d) => DateFormat.yMMMd().add_jm().format(d);

void showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
