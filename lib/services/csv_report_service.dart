import 'dart:convert';
import 'package:csv/csv.dart';
import '../models/device.dart';
import '../models/notification_history_entry.dart';

class CsvReportService {
  String generateDeviceListCsv(List<Device> devices) {
    final rows = [
      ['Name', 'IP', 'Tags', 'Status', 'Last Seen'],
      ...devices.map((d) => [
            d.name ?? '',
            d.ip,
            d.tags.join(', '),
            d.isOnline ? 'Online' : 'Offline',
            d.lastSeen.toIso8601String() ?? '',
          ]),
    ];
    return const ListToCsvConverter().convert(rows);
  }

  String generateNotificationHistoryCsv(
      List<NotificationHistoryEntry> history) {
    final rows = [
      ['Time', 'Rule', 'Device', 'IP', 'Event', 'Message'],
      ...history.map((e) => [
            e.timestamp.toIso8601String(),
            e.ruleName,
            e.deviceName,
            e.deviceIp,
            e.eventType.toString().split('.').last,
            e.message ?? '',
          ]),
    ];
    return const ListToCsvConverter().convert(rows);
  }
}
