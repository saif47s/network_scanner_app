class DeviceHistoryEntry {
  final DateTime timestamp;
  final String event;

  DeviceHistoryEntry({required this.timestamp, required this.event});

  Map<String, dynamic> toMap() => {
        'timestamp': timestamp.toIso8601String(),
        'event': event,
      };

  factory DeviceHistoryEntry.fromMap(Map<String, dynamic> map) =>
      DeviceHistoryEntry(
        timestamp: DateTime.parse(map['timestamp']),
        event: map['event'],
      );
}

class Device {
  String id;
  String ip;
  String? name;
  String? mac;
  String? vendor;
  DateTime lastSeen;
  bool isFavorite;
  String? notes;
  String? deviceType;
  String networkId;
  List<String> tags;
  bool isOnline; // <-- yeh field add ki gayi
  List<DeviceHistoryEntry> history; // <-- yeh field add ki gayi

  Device({
    required this.id,
    required this.ip,
    this.name,
    this.mac,
    this.vendor,
    required this.lastSeen,
    this.isFavorite = false,
    this.notes,
    this.deviceType,
    required this.networkId,
    List<String>? tags,
    this.isOnline = false, // <-- default false
    List<DeviceHistoryEntry>? history,
  })  : tags = tags ?? [],
        history = history ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'ip': ip,
        'name': name,
        'mac': mac,
        'vendor': vendor,
        'lastSeen': lastSeen.toIso8601String(),
        'isFavorite': isFavorite,
        'notes': notes,
        'deviceType': deviceType,
        'networkId': networkId,
        'tags': tags,
        'isOnline': isOnline, // <-- new
        'history': history.map((e) => e.toMap()).toList(), // <-- new
      };

  factory Device.fromMap(Map<String, dynamic> map) => Device(
        id: map['id'],
        ip: map['ip'],
        name: map['name'],
        mac: map['mac'],
        vendor: map['vendor'],
        lastSeen: DateTime.parse(map['lastSeen']),
        isFavorite: map['isFavorite'] ?? false,
        notes: map['notes'],
        deviceType: map['deviceType'],
        networkId: map['networkId'],
        tags: List<String>.from(map['tags'] ?? []),
        isOnline: map['isOnline'] ?? false,
        history: map['history'] != null
            ? List<DeviceHistoryEntry>.from((map['history'] as List).map((e) =>
                DeviceHistoryEntry.fromMap(Map<String, dynamic>.from(e))))
            : [],
      );
}
