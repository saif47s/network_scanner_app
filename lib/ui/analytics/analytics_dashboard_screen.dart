import 'package:flutter/material.dart';
import '../../models/device.dart';
import '../../services/analytics_service.dart';
import 'event_type_bar_chart.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  final List<Device> devices;
  final analytics = AnalyticsService();

  AnalyticsDashboardScreen({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    final eventTypeCounts = analytics.eventTypeCounts(devices);
    final topDevices = analytics.mostActiveDevices(devices).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final tagBreakdown = analytics.eventBreakdownByTag(devices);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Event Type Breakdown"),
          EventTypeBarChart(data: eventTypeCounts),
          const SizedBox(height: 24),
          const Text("Most Active Devices (by event count)"),
          ...topDevices.take(10).map((e) => ListTile(
                title: Text(e.key),
                trailing: Text(e.value.toString()),
              )),
          const SizedBox(height: 24),
          const Text("Events by Tag/Group"),
          ...tagBreakdown.entries.map((e) => ListTile(
                title: Text(e.key),
                trailing: Text(e.value.toString()),
              )),
        ],
      ),
    );
  }
}
