import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/unit_conversion.dart';
import '../domain/validation_service.dart';

/// CSV and PDF export. Files go to the temp directory with PHI-free names.
abstract final class ExportService {
  /// RFC 4180-style CSV: values in canonical units,
  /// fields with commas/quotes/newlines escaped.
  static String csv(List<VitalRecord> records) {
    const types = VitalType.values;
    final header = [
      'Date',
      for (final t in types) '${t.title} (${t.unit})',
      'Symptoms',
    ];
    final sorted = [...records]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final rows = [
      for (final r in sorted)
        [
          r.recordedAt.toUtc().toIso8601String().replaceFirst('.000Z', 'Z'),
          for (final t in types) r.value(t)?.roundTo(1).toString() ?? '',
          r.symptoms,
        ],
    ];
    return [
      header,
      ...rows,
    ].map((row) => row.map(_escape).join(',')).join('\n');
  }

  static String _escape(String s) =>
      s.contains(RegExp(r'[,"\n]')) ? '"${s.replaceAll('"', '""')}"' : s;

  /// Short column headings so they never overlap at the PDF's small font size.
  /// (The built-in PDF font is Latin-1 only, so no subscript characters.)
  static const _pdfHeader = {
    VitalType.systolic: 'Sys mmHg',
    VitalType.diastolic: 'Dia mmHg',
    VitalType.heartRate: 'HR bpm',
    VitalType.temperature: 'Temp °C',
    VitalType.respiratoryRate: 'Resp /min',
    VitalType.spo2: 'SpO2 %',
    VitalType.painLevel: 'Pain /10',
  };

  /// Renders a paginated PDF vitals report; abnormal values are red and
  /// marked with an asterisk (not colour alone).
  static Future<Uint8List> pdf(
    Patient patient,
    List<VitalRecord> records,
  ) async {
    final columns = _pdfHeader.keys.toList();
    final df = DateFormat('MM/dd/yy HH:mm');
    final sorted = [...records]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    const body = pw.TextStyle(fontSize: 8);
    final head = pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final bad = pw.TextStyle(
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.red,
    );

    pw.Widget cell(String text, pw.TextStyle style) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: pw.Text(text, style: style),
    );

    final doc = pw.Document(title: 'Vitals Report');
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Vitals Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              '${patient.fullName} - ID ${patient.medicalId} - DOB ${DateFormat('yyyy-MM-dd').format(patient.dob)}',
              style: body,
            ),
            pw.SizedBox(height: 10),
          ],
        ),
        build: (_) => [
          pw.Table(
            columnWidths: {
              0: const pw.FlexColumnWidth(1.7),
              for (var i = 1; i <= columns.length; i++)
                i: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  cell('Date', head),
                  for (final c in columns) cell(_pdfHeader[c]!, head),
                ],
              ),
              for (final r in sorted)
                pw.TableRow(
                  children: [
                    cell(df.format(r.recordedAt), body),
                    for (final t in columns)
                      () {
                        final v = r.value(t);
                        final abnormal =
                            v != null && ValidationService.isAbnormal(v, t);
                        return cell(_cell(v, t), abnormal ? bad : body);
                      }(),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
    return doc.save();
  }

  static String _cell(double? v, VitalType t) {
    if (v == null) return '-';
    final text = v.roundTo(1).toString();
    return ValidationService.isAbnormal(v, t) ? '$text*' : text;
  }

  /// Writes bytes to a temp file and returns its path for native sharing.
  static Future<File> writeTemp(List<int> bytes, String extension) async {
    final dir = Directory('${(await getTemporaryDirectory()).path}/exports');
    await dir.create(recursive: true);
    for (final f in dir.listSync()) {
      f.deleteSync();
    }
    final file = File(
      '${dir.path}/vitals-${DateTime.now().millisecondsSinceEpoch}.$extension',
    );
    return file.writeAsBytes(bytes, flush: true);
  }
}
