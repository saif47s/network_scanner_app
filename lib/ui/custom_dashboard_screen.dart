import 'package:flutter/material.dart';
import '../models/dashboard_widget.dart';
import '../models/device.dart';
import 'dashboard_widgets/quick_stats_widget.dart';
import 'dashboard_widgets/favorite_devices_widget.dart';
// import other widget files as needed

class CustomDashboardScreen extends StatelessWidget {
  final UserDashboardConfig config;
  final List<Device> devices;

  const CustomDashboardScreen(
      {super.key, required this.config, required this.devices});

  Widget _buildWidget(DashboardWidgetConfig w) {
    switch (w.type) {
      case DashboardWidgetType.quickStats:
        return QuickStatsWidget(devices: devices);
      case DashboardWidgetType.favoriteDevices:
        return FavoriteDevicesWidget(devices: devices);
      // Add more cases for other widget types
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Dashboard")),
      body: ListView(
        children: config.widgets.map(_buildWidget).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.widgets),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => EditDashboardScreen(config: config),
          ));
        },
      ),
    );
  }
}
