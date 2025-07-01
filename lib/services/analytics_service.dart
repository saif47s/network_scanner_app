import '../models/device.dart';
import '../models/device_event.dart';

class AnalyticsService {
  /// Returns a map of DeviceEventType to counts
  Map<DeviceEventType, int> eventTypeCounts(List<Device> devices) {
    final counts = <DeviceEventType, int>{};
    for (final device in devices) {
      if (device.history != null) {
        for (final event in device.history) {
          counts[event.eventType] = (counts[event.eventType] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

  /// Returns a map of device name/IP to event count
  Map<String, int> mostActiveDevices(List<Device> devices) {
    final counts = <String, int>{};
    for (final device in devices) {
      counts[device.name ?? device.ip] = device.history.length;
    }
    return counts;
  }

  /// Returns a map of tag to number of events
  Map<String, int> eventBreakdownByTag(List<Device> devices) {
    final tagCounts = <String, int>{};
    for (final device in devices) {
      for (final tag in device.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + device.history.length;
      }
    }
    return tagCounts;
  }
}
