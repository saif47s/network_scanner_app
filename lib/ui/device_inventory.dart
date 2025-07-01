import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/device_inventory_service.dart';

class DeviceInventoryScreen extends StatefulWidget {
  const DeviceInventoryScreen({super.key});

  @override
  State<DeviceInventoryScreen> createState() => _DeviceInventoryScreenState();
}

class _DeviceInventoryScreenState extends State<DeviceInventoryScreen> {
  final DeviceInventoryService _inventoryService = DeviceInventoryService();
  List<Device> _devices = [];
  List<Device> _filteredDevices = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final devices = await _inventoryService
        .getAllDevices('yourNetworkId'); // Replace with actual network id
    setState(() {
      _devices = devices;
      _filteredDevices = _applySearch(devices, _searchQuery);
      _isLoading = false;
    });
  }

  List<Device> _applySearch(List<Device> devices, String query) {
    if (query.isEmpty) return devices;
    final lower = query.toLowerCase();
    return devices.where((d) {
      return (d.name ?? '').toLowerCase().contains(lower) ||
          d.ip.toLowerCase().contains(lower) ||
          (d.notes ?? '').toLowerCase().contains(lower);
    }).toList();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredDevices = _applySearch(_devices, _searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Inventory'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Search by name, IP or notes",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _onSearch,
                  ),
                ),
                Expanded(
                  child: _filteredDevices.isEmpty
                      ? const Center(child: Text('No devices found'))
                      : ListView.builder(
                          itemCount: _filteredDevices.length,
                          itemBuilder: (ctx, i) {
                            final device = _filteredDevices[i];
                            return ListTile(
                              title: Text(device.name ?? device.ip),
                              subtitle: Text(device.ip),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
