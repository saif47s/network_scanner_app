enum DeviceEventType {
  discovered,
  online,
  offline,
  updated,
  noteAdded,
  ping,
  portScan,
  favorite,
  unfavorite
}

class DeviceEvent {
  final DeviceEventType type;
  final DateTime timestamp;
  final String? message;

  DeviceEvent({
    required this.type,
    required this.timestamp,
    this.message,
  });

  Map<String, dynamic> toMap() => {
        'type': type.toString(),
        'timestamp': timestamp.toIso8601String(),
        'message': message,
      };

  factory DeviceEvent.fromMap(Map<String, dynamic> map) => DeviceEvent(
        type: DeviceEventType.values
            .firstWhere((e) => e.toString() == map['type']),
        timestamp: DateTime.parse(map['timestamp']),
        message: map['message'],
      );
}
