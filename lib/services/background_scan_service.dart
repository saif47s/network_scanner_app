import 'device_inventory_service.dart';
import 'network_scan_service.dart';

class BackgroundScanService {
  // This is called in background isolate by callbackDispatcher
  static Future<void> handleBackgroundScan(String networkId) async {
    final scannedDevices = await scanNetwork(networkId); // your scanner
    await DeviceInventoryService()
        .handleNewDevicesAfterScan(scannedDevices, networkId);
  }
}
