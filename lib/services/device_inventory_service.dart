import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device.dart';
import 'notification_service.dart';

class DeviceInventoryService {
  static String _keyForNetwork(String networkId) => 'devices_$networkId';

  Future<List<Device>> getAllDevices(String networkId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyForNetwork(networkId));
    if (data == null) return [];
    final list = json.decode(data) as List;
    return list.map((e) => Device.fromMap(e)).toList();
  }

  Future<void> saveDevice(Device device) async {
    final devices = await getAllDevices(device.networkId);
    final index = devices.indexWhere((d) => d.ip == device.ip);
    if (index >= 0) {
      devices[index] = device;
    } else {
      devices.add(device);
    }
    await _saveDevices(device.networkId, devices);
  }

  Future<void> _saveDevices(String networkId, List<Device> devices) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyForNetwork(networkId),
        json.encode(devices.map((d) => d.toMap()).toList()));
  }

  // New: compare device list and notify for new ones
  Future<void> handleNewDevicesAfterScan(
      List<Device> scannedDevices, String networkId) async {
    final existing = await getAllDevices(networkId);
    final existingIps = existing.map((d) => d.ip).toSet();

    for (final device in scannedDevices) {
      if (!existingIps.contains(device.ip)) {
        // New device found!
        await NotificationService.showNewDeviceNotification(
          device.name?.isNotEmpty == true ? device.name! : device.ip,
        );
      }
      // Save/update device as usual
      await saveDevice(device);
    }
  }
}
