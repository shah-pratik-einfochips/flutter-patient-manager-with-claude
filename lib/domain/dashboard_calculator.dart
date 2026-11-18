import 'enums.dart';
import 'models.dart';
import 'unit_conversion.dart';
import 'validation_service.dart';

class VitalStats {
  const VitalStats({
    required this.min,
    required this.max,
    required this.average,
    required this.latest,
    required this.count,
  });
  final double min;
  final double max;
  final double average;
  final double latest;
  final int count;
}

class VitalPoint {
  const VitalPoint(this.time, this.value, this.abnormal);
  final DateTime time;
  final double value;
  final bool abnormal;
}

abstract final class DashboardCalculator {
  /// Length of the dashboard window, in days.
  static const windowDays = 7;

  /// Start of the dashboard window ending at [now].
  static DateTime windowStart(DateTime now) =>
      now.subtract(const Duration(days: windowDays));

  /// Records from the last [days] days up to [now], oldest first.
  static List<VitalRecord> recent(
    List<VitalRecord> records, {
    int days = windowDays,
    DateTime? now,
  }) {
    final end = now ?? DateTime.now();
    final start = end.subtract(Duration(days: days));
    return records
        .where(
          (r) => !r.recordedAt.isBefore(start) && !r.recordedAt.isAfter(end),
        )
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  static List<VitalPoint> points(List<VitalRecord> records, VitalType type) => [
    for (final r in records)
      if (r.value(type) case final v?)
        VitalPoint(r.recordedAt, v, ValidationService.isAbnormal(v, type)),
  ];

  static VitalStats? stats(List<VitalRecord> records, VitalType type) =>
      statsOf(points(records, type));

  static VitalStats? statsOf(List<VitalPoint> pts) {
    if (pts.isEmpty) return null;
    final latest = pts.reduce((a, b) => b.time.isAfter(a.time) ? b : a);
    final values = pts.map((p) => p.value);
    final sum = values.fold<double>(0, (a, b) => a + b);
    return VitalStats(
      min: values.reduce((a, b) => a < b ? a : b),
      max: values.reduce((a, b) => a > b ? a : b),
      average: (sum / pts.length).roundTo(1),
      latest: latest.value,
      count: pts.length,
    );
  }
}
