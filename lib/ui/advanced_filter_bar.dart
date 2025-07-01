import 'package:flutter/material.dart';
import '../models/device.dart';

class AdvancedFilterBar extends StatelessWidget {
  final List<Device> allDevices;
  final Set<String> selectedTags;
  final bool showOnlyOffline;
  final int? notSeenInDays;
  final void Function(Set<String>) onTagsChanged;
  final void Function(bool) onShowOnlyOfflineChanged;
  final void Function(int?) onNotSeenInDaysChanged;

  const AdvancedFilterBar({
    super.key,
    required this.allDevices,
    required this.selectedTags,
    required this.showOnlyOffline,
    required this.notSeenInDays,
    required this.onTagsChanged,
    required this.onShowOnlyOfflineChanged,
    required this.onNotSeenInDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tags = allDevices.expand((d) => d.tags).toSet().toList();
    return Column(
      children: [
        Row(
          children: [
            ...tags.map((tag) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: selectedTags.contains(tag),
                    onSelected: (selected) {
                      final newTags = Set.of(selectedTags);
                      selected ? newTags.add(tag) : newTags.remove(tag);
                      onTagsChanged(newTags);
                    },
                  ),
                )),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text("Offline"),
              selected: showOnlyOffline,
              onSelected: onShowOnlyOfflineChanged,
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: notSeenInDays,
              hint: const Text("Not seen in..."),
              items: [null, 1, 3, 7, 30]
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: d == null
                            ? const Text("Any time")
                            : Text("$d days"),
                      ))
                  .toList(),
              onChanged: onNotSeenInDaysChanged,
            ),
          ],
        ),
      ],
    );
  }
}
