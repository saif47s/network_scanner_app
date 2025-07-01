import 'device_event.dart';

class NotificationHistoryEntry {
  final String id; // UUID or timestamp-based
  final DateTime timestamp;
  final String ruleName;
  final String deviceName;
  final String deviceIp;
  final DeviceEventType eventType;
  final String? message;

  NotificationHistoryEntry({
    required this.id,
    required this.timestamp,
    required this.ruleName,
    required this.deviceName,
    required this.deviceIp,
    required this.eventType,
    this.message,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'ruleName': ruleName,
        'deviceName': deviceName,
        'deviceIp': deviceIp,
        'eventType': eventType.toString(),
        'message': message,
      };

  factory NotificationHistoryEntry.fromMap(Map<String, dynamic> map) =>
      NotificationHistoryEntry(
        id: map['id'],
        timestamp: DateTime.parse(map['timestamp']),
        ruleName: map['ruleName'],
        deviceName: map['deviceName'],
        deviceIp: map['deviceIp'],
        eventType: DeviceEventType.values
            .firstWhere((e) => e.toString() == map['eventType']),
        message: map['message'],
      );
}
