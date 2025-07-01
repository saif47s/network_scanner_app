import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/device_event.dart';

class DeviceTimelineScreen extends StatelessWidget {
  final Device device;

  const DeviceTimelineScreen({super.key, required this.device});

  String _eventTitle(DeviceEvent event) {
    switch (event.type) {
      case DeviceEventType.discovered:
        return "Discovered";
      case DeviceEventType.online:
        return "Online";
      case DeviceEventType.offline:
        return "Offline";
      case DeviceEventType.updated:
        return "Updated";
      case DeviceEventType.noteAdded:
        return "Note added";
      default:
        return event.type.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = List<DeviceEvent>.from(device.history)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // newest first

    return Scaffold(
      appBar: AppBar(title: Text('${device.name ?? device.ip} Timeline')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (ctx, i) {
          final event = events[i];
          return ListTile(
            leading: Icon(_iconForType(event.type)),
            title: Text(_eventTitle(event)),
            subtitle: Text(
              '${event.timestamp.toLocal()}'
              '\n${event.message ?? ''}',
            ),
            isThreeLine: event.message != null,
          );
        },
      ),
    );
  }

  IconData _iconForType(DeviceEventType type) {
    switch (type) {
      case DeviceEventType.discovered:
        return Icons.new_releases;
      case DeviceEventType.online:
        return Icons.wifi;
      case DeviceEventType.offline:
        return Icons.wifi_off;
      case DeviceEventType.updated:
        return Icons.edit;
      case DeviceEventType.noteAdded:
        return Icons.note;
      default:
        return Icons.device_unknown;
    }
  }
}
