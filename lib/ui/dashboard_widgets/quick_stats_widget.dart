import 'package:flutter/material.dart';
import '../../models/device.dart';

class QuickStatsWidget extends StatelessWidget {
  final List<Device> devices;

  const QuickStatsWidget({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    final online = devices.where((d) => d.isOnline).length;
    final offline = devices.length - online;
    return Card(
      child: ListTile(
        title: const Text("Quick Stats"),
        subtitle: Text(
            "Online: $online  •  Offline: $offline  •  Total: ${devices.length}"),
      ),
    );
  }
}
