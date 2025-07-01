import '../models/device_event.dart';

enum DeviceEventField { eventType, tag, timeOfDay, deviceName, deviceIp }

class NotificationRule {
  String id; // UUID or Firestore doc id
  String name;
  DeviceEventType? eventType; // e.g. DeviceEventType.offline
  String? tag; // e.g. "IoT"
  String? deviceNameContains; // optional match on device name
  String? deviceIp; // optional exact IP or CIDR
  int? hourStart; // e.g. 0 for midnight, 23 for 11pm
  int? hourEnd; // e.g. 6 for 6am

  NotificationRule({
    required this.id,
    required this.name,
    this.eventType,
    this.tag,
    this.deviceNameContains,
    this.deviceIp,
    this.hourStart,
    this.hourEnd,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'eventType': eventType?.toString(),
        'tag': tag,
        'deviceNameContains': deviceNameContains,
        'deviceIp': deviceIp,
        'hourStart': hourStart,
        'hourEnd': hourEnd,
      };

  factory NotificationRule.fromMap(Map<String, dynamic> map) =>
      NotificationRule(
        id: map['id'],
        name: map['name'],
        eventType: map['eventType'] != null
            ? DeviceEventType.values
                .firstWhere((e) => e.toString() == map['eventType'])
            : null,
        tag: map['tag'],
        deviceNameContains: map['deviceNameContains'],
        deviceIp: map['deviceIp'],
        hourStart: map['hourStart'],
        hourEnd: map['hourEnd'],
      );
}
