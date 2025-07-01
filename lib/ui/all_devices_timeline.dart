import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/device_event.dart';

class AllDevicesTimelineScreen extends StatefulWidget {
  final List<Device> allDevices;

  const AllDevicesTimelineScreen({super.key, required this.allDevices});

  @override
  State<AllDevicesTimelineScreen> createState() =>
      _AllDevicesTimelineScreenState();
}

class _AllDevicesTimelineScreenState extends State<AllDevicesTimelineScreen> {
  String _searchQuery = '';
  final Set<DeviceEventType> _selectedTypes = {};

  @override
  Widget build(BuildContext context) {
    // Flatten all events and pair with device
    final allEvents = <MapEntry<Device, DeviceEvent>>[];
    for (final d in widget.allDevices) {
      for (final e in d.history) {
        allEvents.add(MapEntry(d, e));
      }
    }
    // Search and filter
    final filteredEvents = allEvents.where((entry) {
      final d = entry.key;
      final e = entry.value;
      final matchesType =
          _selectedTypes.isEmpty || _selectedTypes.contains(e.type);
      final matchesSearch = _searchQuery.isEmpty ||
          (d.name?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) ||
          d.ip.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (e.message?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList()
      ..sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));

    return Scaffold(
      appBar: AppBar(title: const Text('All Devices Timeline')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search by name, IP, or message",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (q) => setState(() => _searchQuery = q),
            ),
          ),
          // Filter chips for event type
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: DeviceEventType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: _selectedTypes.contains(type),
                    label: Text(type.toString().split('.').last),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTypes.add(type);
                        } else {
                          _selectedTypes.remove(type);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 0),
          // Timeline
          Expanded(
            child: filteredEvents.isEmpty
                ? const Center(child: Text('No events found'))
                : ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (ctx, i) {
                      final entry = filteredEvents[i];
                      final d = entry.key;
                      final e = entry.value;
                      return ListTile(
                        leading: Icon(_iconForType(e.type)),
                        title: Text('${_eventTitle(e)} — ${d.name ?? d.ip}'),
                        subtitle: Text(
                          '${e.timestamp.toLocal()}'
                          '\n${e.message ?? ''}',
                        ),
                        isThreeLine: e.message != null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(DeviceEventType type) {
    // ...same as previous implementation...
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
      case DeviceEventType.ping:
        return Icons.network_ping;
      case DeviceEventType.portScan:
        return Icons.security;
      case DeviceEventType.favorite:
        return Icons.star;
      case DeviceEventType.unfavorite:
        return Icons.star_border;
      default:
        return Icons.device_unknown;
    }
  }

  String _eventTitle(DeviceEvent event) {
    // ...same as previous implementation...
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
      case DeviceEventType.ping:
        return "Ping";
      case DeviceEventType.portScan:
        return "Port scan";
      case DeviceEventType.favorite:
        return "Marked favorite";
      case DeviceEventType.unfavorite:
        return "Unmarked favorite";
      default:
        return event.type.toString();
    }
  }
}
