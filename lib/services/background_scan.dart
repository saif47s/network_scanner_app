import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'scan_service.dart';
import 'device_inventory_service.dart';

const String backgroundScanTask = "backgroundScanTask";

// Register this function in main.dart with Workmanager
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == backgroundScanTask) {
      final scanService = ScanService();
      final inventoryService = DeviceInventoryService();

      // TODO: Replace with your subnet and real MAC logic if available
      List<Map<String, String>> ipMacList = [
        {"ip": "192.168.1.2", "mac": ""},
        {"ip": "192.168.1.3", "mac": ""},
      ];
      final scannedDevices = await scanService.scanNetwork(ipMacList);
      for (final device in scannedDevices) {
        await inventoryService.saveDevice(device);
      }

      // Show a local notification that scan ran
      await showNotification(
        "Background Scan",
        "Network scan completed at ${DateTime.now().toLocal()}",
      );
    }
    return Future.value(true);
  });
}

// Local notification helper
Future<void> showNotification(String title, String body) async {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'scan_channel',
    'Background Scans',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails details =
      NotificationDetails(android: androidDetails);

  await notifications.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ));
  await notifications.show(0, title, body, details);
}
