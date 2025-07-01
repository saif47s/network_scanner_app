import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'services/notification_service.dart';
import 'services/background_scan_service.dart';
import 'ui/device_inventory.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationService.init();

    // Get networkId
    final networkId = inputData?['networkId'];
    if (networkId != null) {
      await BackgroundScanService.handleBackgroundScan(networkId);
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Inventory',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DeviceInventoryScreen(),
    );
  }
}
