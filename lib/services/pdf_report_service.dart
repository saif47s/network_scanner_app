import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/device.dart';
import '../models/notification_history_entry.dart';

class PdfReportService {
  Future<Uint8List> generateDeviceListReport(List<Device> devices) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Device List', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: ['Name', 'IP', 'Tags', 'Status', 'Last Seen'],
              data: devices
                  .map((d) => [
                        d.name ?? '',
                        d.ip,
                        d.tags.join(', '),
                        d.isOnline ? 'Online' : 'Offline',
                        d.lastSeen.toIso8601String() ?? '',
                      ])
                  .toList(),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> generateNotificationHistoryReport(
      List<NotificationHistoryEntry> history) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Notification History', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: ['Time', 'Rule', 'Device', 'IP', 'Event', 'Message'],
              data: history
                  .map((e) => [
                        e.timestamp.toIso8601String(),
                        e.ruleName,
                        e.deviceName,
                        e.deviceIp,
                        e.eventType.toString().split('.').last,
                        e.message ?? '',
                      ])
                  .toList(),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }
}
