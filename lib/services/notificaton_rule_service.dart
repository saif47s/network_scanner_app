import '../models/device.dart';
import '../models/device_event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

extension RuleEvaluation on NotificationRuleService {
  /// Call this for each new event!
  void checkAndNotify(Device device, DeviceEvent event) {
    for (var rule in _rules) {
      if (_matches(rule, device, event)) {
        _sendNotification(rule, device, event);
      }
    }
  }

  bool _matches(NotificationRule rule, Device device, DeviceEvent event) {
    if (rule.eventType != null && event.type != rule.eventType) return false;
    if (rule.tag != null && !device.tags.contains(rule.tag)) return false;
    if (rule.deviceNameContains != null &&
        !(device.name
                ?.toLowerCase()
                .contains(rule.deviceNameContains!.toLowerCase()) ??
            false)) {
      return false;
    }
    if (rule.deviceIp != null && device.ip != rule.deviceIp) return false;
    if (rule.hourStart != null && rule.hourEnd != null) {
      final hour = event.timestamp.hour;
      final s = rule.hourStart!, e = rule.hourEnd!;
      if (s <= e) {
        if (hour < s || hour > e) return false;
      } else {
        // Overnight (e.g. 22-6)
        if (!(hour >= s || hour <= e)) return false;
      }
    }
    return true;
  }

  void _sendNotification(
      NotificationRule rule, Device device, DeviceEvent event) {
    // Use flutter_local_notifications or another plugin
    // Example:
    FlutterLocalNotificationsPlugin().show(
      0,
      'Network Alert: ${rule.name}',
      'Device ${device.name ?? device.ip} triggered event: ${event.type.toString().split('.').last}',
      const NotificationDetails(
        android: AndroidNotificationDetails('net_alerts', 'Network Alerts'),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
