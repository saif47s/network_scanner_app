import 'package:flutter/material.dart';
import '../../models/device.dart';

class FavoriteDevicesWidget extends StatelessWidget {
  final List<Device> devices;

  const FavoriteDevicesWidget({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    final favorites = devices.where((d) => d.isFavorite).toList();
    return Card(
      child: ExpansionTile(
        title: const Text("Favorite Devices"),
        children: favorites.isEmpty
            ? [const ListTile(title: Text("No favorites"))]
            : favorites
                .map((d) => ListTile(title: Text(d.name ?? d.ip)))
                .toList(),
      ),
    );
  }
}
