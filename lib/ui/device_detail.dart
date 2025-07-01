import 'package:flutter/material.dart';
import '../models/device.dart';
import 'package:network_tools/network_tools.dart';
import '../services/device_inventory_service.dart';

const deviceTypes = [
  "Unknown",
  "Phone",
  "PC",
  "Printer",
  "Router",
  "Camera",
  "Tablet",
  "TV",
  "IoT",
];

// ---- Online/Offline Helper ----
bool isDeviceOnline(Device device,
    {Duration threshold = const Duration(minutes: 3)}) {
  return DateTime.now().difference(device.lastSeen) < threshold;
}

class DeviceDetailScreen extends StatefulWidget {
  final String ipAddress;
  const DeviceDetailScreen({super.key, required this.ipAddress});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  Device? device;
  bool isLoading = true;
  bool isPortScanning = false;
  List<OpenPort> openPorts = [];

  final DeviceInventoryService _inventoryService = DeviceInventoryService();

  @override
  void initState() {
    super.initState();
    _loadDevice();
  }

  Future<void> _loadDevice() async {
    final foundDevice = await _inventoryService.getDeviceByIp(widget.ipAddress);
    setState(() {
      device = foundDevice;
      isLoading = false;
    });
  }

  Future<void> _scanPorts(BuildContext context, String ip) async {
    setState(() {
      isPortScanning = true;
      openPorts = [];
    });

    List<OpenPort> foundPorts = [];
    try {
      await for (final port in HostScanner.discoverOpenPorts(
        ip,
        startPort: 1,
        endPort: 1024,
        timeout: const Duration(milliseconds: 200),
      )) {
        foundPorts.add(port);
      }
    } catch (e) {
      // handle error if needed
    }

    setState(() {
      isPortScanning = false;
      openPorts = foundPorts;
    });

    showDialog(
      context: context,
      builder: (ctx) {
        if (openPorts.isEmpty) {
          return AlertDialog(
            title: const Text('No Open Ports Found'),
            content: Text('No open ports detected on $ip in range 1-1024.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          );
        }
        return AlertDialog(
          title: Text('Open Ports for $ip'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: openPorts
                  .map(
                    (p) => Text(
                        'Port ${p.port}${p.service != null && p.service!.isNotEmpty ? " (${p.service})" : ""}'),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(Device device) {
    final nameController = TextEditingController(text: device.name);
    final notesController = TextEditingController(text: device.notes);
    String? selectedType = device.deviceType ?? deviceTypes.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Device'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
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
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: "Device Type"),
                    items: deviceTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedType = val;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: device.isFavorite,
                        onChanged: (val) {
                          setState(() => device.isFavorite = val ?? false);
                          setDialogState(() {});
                        },
                      ),
                      const Text('Favorite'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                device.name = nameController.text;
                device.notes = notesController.text;
                device.deviceType = selectedType;
                await _inventoryService.saveDevice(device);
                setState(() {});
                Navigator.pop(context);
                _loadDevice();
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

  Icon _getDeviceIcon(Device device) {
    switch (device.deviceType) {
      case "Phone":
        return const Icon(Icons.smartphone, size: 36);
      case "PC":
        return const Icon(Icons.computer, size: 36);
      case "Printer":
        return const Icon(Icons.print, size: 36);
      case "Router":
        return const Icon(Icons.router, size: 36);
      case "Camera":
        return const Icon(Icons.videocam, size: 36);
      case "Tablet":
        return const Icon(Icons.tablet, size: 36);
      case "TV":
        return const Icon(Icons.tv, size: 36);
      case "IoT":
        return const Icon(Icons.devices_other, size: 36);
      default:
        return const Icon(Icons.devices, size: 36);
    }
  }

  Widget _buildOnlineStatusBadge(Device device) {
    return Row(
      children: [
        Icon(Icons.circle,
            color: isDeviceOnline(device) ? Colors.green : Colors.grey,
            size: 14),
        const SizedBox(width: 6),
        Text(
          isDeviceOnline(device) ? "Online" : "Offline",
          style: TextStyle(
            color: isDeviceOnline(device) ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || device == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Device Detail")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(device!.name?.isNotEmpty == true ? device!.name! : device!.ip),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(device!),
            tooltip: 'Edit Device',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              leading: _getDeviceIcon(device!),
              title: Text('IP: ${device!.ip}'),
              subtitle: device!.deviceType != null &&
                      device!.deviceType!.isNotEmpty &&
                      device!.deviceType != "Unknown"
                  ? Text('Type: ${device!.deviceType}')
                  : null,
              trailing: _buildOnlineStatusBadge(device!),
            ),
            if (device!.mac != null && device!.mac!.isNotEmpty)
              ListTile(
                title: Text('MAC: ${device!.mac}'),
              ),
            if (device!.vendor != null && device!.vendor!.isNotEmpty)
              ListTile(
                title: Text('Vendor: ${device!.vendor}'),
              ),
            if (device!.notes != null && device!.notes!.isNotEmpty)
              ListTile(
                title: Text('Notes: ${device!.notes}'),
              ),
            ListTile(
              title: Text(
                'Last Seen: ${device!.lastSeen.toLocal()}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Scan Open Ports'),
              onPressed:
                  isPortScanning ? null : () => _scanPorts(context, device!.ip),
            ),
            if (isPortScanning)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
