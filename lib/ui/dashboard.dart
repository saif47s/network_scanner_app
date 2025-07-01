import 'package:flutter/material.dart';
import 'package:network_tools/network_tools.dart';

import '../services/network_scan_service.dart';
import '../services/device_inventory_service.dart';
import '../services/scan_service.dart';
import 'device_inventory.dart';
import 'device_detail.dart';
import 'package:workmanager/workmanager.dart';
import '../services/background_scan.dart';
import '../models/device.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NetworkScanService _networkScanService = NetworkScanService();
  final DeviceInventoryService _inventoryService = DeviceInventoryService();
  final ScanService _scanService = ScanService();

  List<ActiveHost> devices = [];
  bool isScanning = false;

  String subnet = '192.168.1.1';

  @override
  void initState() {
    super.initState();
    scheduleBackgroundScan();
    _loadDevicesFromInventory();
  }

  Future<void> _loadDevicesFromInventory() async {
    // Optionally, load devices from inventory on start
    final inventoryDevices = await _inventoryService.getAllDevices();
    setState(() {
      devices = inventoryDevices.map((d) => ActiveHost(address: d.ip)).toList();
    });
  }

  Future<void> _scanNetwork() async {
    setState(() {
      isScanning = true;
      devices = [];
    });

    // 1. Get old inventory IPs
    final inventoryDevices = await _inventoryService.getAllDevices();
    final knownIps = inventoryDevices.map((d) => d.ip).toSet();

    // 2. Scan the network
    final results = await _networkScanService.scanSubnet(subnet);

    // 3. Find new devices
    final foundIps = results.map((h) => h.address).toSet();
    final newDevices = foundIps.difference(knownIps);

    setState(() {
      devices = results;
      isScanning = false;
    });

    // 4. Prepare device data for vendor lookup and saving
    List<Map<String, String>> ipMacList = [];
    for (final host in results) {
      String ip = host.address;
      String mac = ""; // TODO: Replace with real MAC lookup if needed
      ipMacList.add({"ip": ip, "mac": mac});
    }

    // 5. Lookup vendor and save devices
    final scannedDevices = await _scanService.scanNetwork(ipMacList);
    for (final device in scannedDevices) {
      await _inventoryService.saveDevice(device);
    }

    // 6. Show notification if any new device found
    if (newDevices.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New device(s) found: ${newDevices.join(', ')}"),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    // Optionally reload devices from inventory to get custom name, favorite, notes, etc.
    _loadDevicesFromInventory();
  }

  void _openDeviceInventory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DeviceInventoryScreen()),
    );
  }

  void _openDeviceDetail(String ip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailScreen(ipAddress: ip),
      ),
    );
  }

  void _showDeviceOptionsDialog(Device device) {
    final nameController = TextEditingController(text: device.name);
    final notesController = TextEditingController(text: device.notes);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Device'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Custom Name'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              Row(
                children: [
                  Checkbox(
                    value: device.isFavorite,
                    onChanged: (val) {
                      setState(() => device.isFavorite = val ?? false);
                    },
                  ),
                  const Text('Favorite'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                device.name = nameController.text;
                device.notes = notesController.text;
                await _inventoryService.saveDevice(device);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // For showing favorites first
    List<Device> inventoryDevices = devices.map((e) {
      // Try to get inventory model for each IP if possible
      if (e is Device) return e;
      // Fallback: create a Device from ActiveHost info
      return Device(ip: e.address, lastSeen: DateTime.now());
    }).toList();
    inventoryDevices.sort((a, b) => b.isFavorite.compareTo(a.isFavorite));

    return Scaffold(
      appBar: AppBar(title: const Text('Network Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isScanning ? null : _scanNetwork,
                    child: Text(isScanning ? 'Scanning...' : 'Scan Network'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openDeviceInventory,
                    child: const Text("Device Inventory"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: inventoryDevices.isEmpty
                  ? const Center(child: Text('No devices found'))
                  : ListView.builder(
                      itemCount: inventoryDevices.length,
                      itemBuilder: (ctx, i) {
                        final device = inventoryDevices[i];
                        return ListTile(
                          leading: Icon(
                            device.isFavorite ? Icons.star : Icons.devices,
                            color: device.isFavorite ? Colors.amber : null,
                          ),
                          title: Text(
                            (device.name?.isNotEmpty == true)
                                ? device.name!
                                : device.ip,
                          ),
                          subtitle: Text(device.notes ?? ''),
                          onTap: () => _openDeviceDetail(device.ip),
                          onLongPress: () => _showDeviceOptionsDialog(device),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

void scheduleBackgroundScan() {
  Workmanager().registerPeriodicTask(
    "uniqueScanTaskId",
    backgroundScanTask,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}
