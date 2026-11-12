import 'dart:convert';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/export_service.dart';
import '../../domain/dashboard_calculator.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../domain/unit_conversion.dart';
import '../providers.dart';
import '../widgets/common.dart';

enum _View { chart, table }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, required this.patientId});
  final String patientId;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  VitalType _type = VitalType.heartRate;
  _View _view = _View.chart;
  bool _exporting = false;

  Future<void> _export(
    String kind,
    Patient patient,
    List<VitalRecord> records,
    BuildContext buttonContext,
  ) async {
    final box = buttonContext.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    final repo = ref.read(repositoryProvider);
    setState(() => _exporting = true);
    try {
      final file = kind == 'csv'
          ? await ExportService.writeTemp(
              utf8.encode(ExportService.csv(records)),
              'csv',
            )
          : await ExportService.writeTemp(
              await ExportService.pdf(patient, records),
              'pdf',
            );
      await repo.log('export.$kind', patient.id);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], sharePositionOrigin: origin),
      );
    } catch (e) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Export failed'),
            content: Text('$e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = ref.watch(patientProvider(widget.patientId)).value;
    final all =
        ref.watch(vitalsProvider(widget.patientId)).value ??
        const <VitalRecord>[];
    final now = DateTime.now();
    final recent = DashboardCalculator.recent(all, now: now);
    final stats = DashboardCalculator.stats(recent, _type);

    return Scaffold(
      appBar: AppBar(title: const Text('Vitals dashboard')),
      body: AdaptiveBody(
        maxWidth: 900,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Past 7 days${patient == null ? '' : ' · ${patient.fullName}'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in VitalType.chartable)
                  ChoiceChip(
                    label: Text(t.title),
                    selected: t == _type,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<_View>(
              segments: const [
                ButtonSegment(
                  value: _View.chart,
                  icon: Icon(Icons.show_chart),
                  label: Text('Chart'),
                ),
                ButtonSegment(
                  value: _View.table,
                  icon: Icon(Icons.table_rows_outlined),
                  label: Text('Table'),
                ),
              ],
              selected: {_view},
              onSelectionChanged: (v) => setState(() => _view = v.first),
            ),
            const SizedBox(height: 16),
            _StatsCard(type: _type, stats: stats),
            const SizedBox(height: 16),
            if (recent.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No vitals recorded in the past 7 days.'),
                ),
              )
            else if (_view == _View.chart)
              _Chart(type: _type, records: recent, now: now)
            else
              _Table(type: _type, records: recent),
            const SectionTitle('Export'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Builder(
                  builder: (ctx) => FilledButton.tonalIcon(
                    onPressed: _exporting || patient == null || all.isEmpty
                        ? null
                        : () => _export('csv', patient, all, ctx),
                    icon: const Icon(Icons.table_view_outlined),
                    label: const Text('Export CSV'),
                  ),
                ),
                Builder(
                  builder: (ctx) => FilledButton.tonalIcon(
                    onPressed: _exporting || patient == null || all.isEmpty
                        ? null
                        : () => _export('pdf', patient, all, ctx),
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Export PDF'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Exports include all recorded vitals. Files are created temporarily and shared through the system share sheet.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.type, required this.stats});
  final VitalType type;
  final VitalStats? stats;

  @override
  Widget build(BuildContext context) {
    final s = stats;
    final range = type.normalMin == null
        ? null
        : 'Normal ${_fmt(type.normalMin!)}–${_fmt(type.normalMax!)} ${type.unit}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${type.title} (${type.unit})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (range != null)
              Text(range, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            if (s == null)
              const Text('No readings in this period.')
            else
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  _stat(
                    context,
                    'Latest',
                    s.latest,
                    abnormal: _abnormal(s.latest),
                  ),
                  _stat(context, 'Average', s.average),
                  _stat(context, 'Min', s.min),
                  _stat(context, 'Max', s.max),
                  _stat(context, 'Readings', s.count.toDouble(), integer: true),
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool _abnormal(double v) =>
      type.normalMin != null && (v < type.normalMin! || v > type.normalMax!);

  Widget _stat(
    BuildContext context,
    String label,
    double v, {
    bool abnormal = false,
    bool integer = false,
  }) {
    final text = integer ? v.toInt().toString() : v.roundTo(1).toString();
    return Semantics(
      label: '$label $text${abnormal ? ', outside normal range' : ''}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            abnormal ? '⚠ $text' : text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

String _fmt(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

/// Diamond marker for abnormal readings so they differ from normal circles by shape, not just colour.
class DiamondDotPainter extends FlDotPainter {
  const DiamondDotPainter({required this.color, this.size = 12});
  final Color color;
  final double size;

  @override
  void draw(Canvas canvas, FlSpot spot, Offset center) {
    final r = size / 2 + 1;
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  Size getSize(FlSpot spot) => Size(size, size);

  @override
  Color get mainColor => color;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => b;

  @override
  List<Object?> get props => [color, size];
}

class _Chart extends StatelessWidget {
  const _Chart({required this.type, required this.records, required this.now});
  final VitalType type;
  final List<VitalRecord> records;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final points = DashboardCalculator.points(records, type);
    if (points.isEmpty)
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No readings to chart.')),
      );
    final start = now.subtract(const Duration(days: 7));
    double x(DateTime t) => t.difference(start).inMinutes / 60.0;

    final values = points.map((p) => p.value);
    var lo = values.reduce(math.min), hi = values.reduce(math.max);
    if (type.normalMin != null) {
      lo = math.min(lo, type.normalMin!);
      hi = math.max(hi, type.normalMax!);
    }
    // Snap the axis to a "nice" step so tick labels never overlap at the ends.
    final span = math.max(hi - lo, 1.0);
    final step = const [
      1.0,
      2.0,
      5.0,
      10.0,
      20.0,
      50.0,
      100.0,
    ].firstWhere((c) => span / c <= 6, orElse: () => 100.0);
    final minY = ((lo - span * 0.1) / step).floorToDouble() * step;
    final maxY = ((hi + span * 0.1) / step).ceilToDouble() * step;

    final abnormalCount = points.where((p) => p.abnormal).length;
    final summary =
        '${type.title} chart, ${points.length} readings over the past 7 days, '
        'from ${_fmt(values.reduce(math.min).roundTo(1))} to ${_fmt(values.reduce(math.max).roundTo(1))} ${type.unit}'
        '${abnormalCount == 0 ? ', none outside the normal range' : ', $abnormalCount outside the normal range'}. Switch to Table view for each reading.';
    final lineColor = scheme.primary;
    final abnormalColor = scheme.error;

    return Semantics(
      label: summary,
      image: true,
      child: ExcludeSemantics(
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 168,
                    minY: minY,
                    maxY: maxY,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: step,
                    ),
                    borderData: FlBorderData(show: false),
                    rangeAnnotations: RangeAnnotations(
                      horizontalRangeAnnotations: [
                        if (type.normalMin != null)
                          HorizontalRangeAnnotation(
                            y1: type.normalMin!,
                            y2: type.normalMax!,
                            color: scheme.tertiaryContainer.withValues(
                              alpha: 0.5,
                            ),
                          ),
                      ],
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          interval: step,
                          getTitlesWidget: (v, meta) => SideTitleWidget(
                            meta: meta,
                            child: Text(
                              _fmt(v.roundTo(1)),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 24,
                          reservedSize: 28,
                          getTitlesWidget: (v, meta) => v > 168
                              ? const SizedBox.shrink()
                              : SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    DateFormat('E d').format(
                                      start.add(Duration(hours: v.toInt())),
                                    ),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (final p in points) FlSpot(x(p.time), p.value),
                        ],
                        isCurved: false,
                        color: lineColor,
                        barWidth: 2.5,
                        dotData: FlDotData(
                          getDotPainter: (spot, _, _, index) =>
                              points[index].abnormal
                              ? DiamondDotPainter(color: abnormalColor)
                              : FlDotCirclePainter(
                                  radius: 4,
                                  color: lineColor,
                                  strokeColor: Colors.white,
                                  strokeWidth: 1.5,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 10, color: lineColor),
                    const SizedBox(width: 4),
                    const Text('Normal reading'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.diamond, size: 12, color: abnormalColor),
                    const SizedBox(width: 4),
                    const Text('Outside normal range'),
                  ],
                ),
                if (type.normalMin != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 10,
                        color: scheme.tertiaryContainer,
                      ),
                      const SizedBox(width: 4),
                      const Text('Normal band'),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.type, required this.records});
  final VitalType type;
  final List<VitalRecord> records;

  @override
  Widget build(BuildContext context) {
    final points = DashboardCalculator.points(records, type).reversed.toList();
    if (points.isEmpty)
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No readings to show.')),
      );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('Date')),
          DataColumn(
            label: Text('${type.title} (${type.unit})'),
            numeric: true,
          ),
          const DataColumn(label: Text('Status')),
        ],
        rows: [
          for (final p in points)
            DataRow(
              cells: [
                DataCell(Text(DateFormat.MMMd().add_jm().format(p.time))),
                DataCell(Text(p.value.roundTo(1).toString())),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        p.abnormal
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(p.abnormal ? 'Abnormal' : 'Normal'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
