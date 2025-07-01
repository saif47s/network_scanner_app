import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/device_event.dart';

class EventTypeBarChart extends StatelessWidget {
  final Map<DeviceEventType, int> data;
  const EventTypeBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bars = data.entries.toList();
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            for (var i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].value.toDouble(),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (i, meta) => Text(
                  bars[i.toInt()].key.toString().split('.').last,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
        ),
      ),
    );
  }
}
