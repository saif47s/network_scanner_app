import 'package:flutter/material.dart';
import '../services/notification_history_service.dart';
import '../models/notification_history_entry.dart';

class NotificationHistoryScreen extends StatefulWidget {
  final NotificationHistoryService historyService;

  const NotificationHistoryScreen({super.key, required this.historyService});

  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  String _search = '';
  final Set<String> _eventTypes = {};

  @override
  void initState() {
    super.initState();
    widget.historyService.load().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.historyService.history.where((entry) {
      final matchesSearch = _search.isEmpty ||
          entry.deviceName.toLowerCase().contains(_search.toLowerCase()) ||
          entry.deviceIp.contains(_search) ||
          entry.ruleName.toLowerCase().contains(_search.toLowerCase()) ||
          (entry.message?.toLowerCase().contains(_search.toLowerCase()) ??
              false);
      final matchesType = _eventTypes.isEmpty ||
          _eventTypes.contains(entry.eventType.toString());
      return matchesSearch && matchesType;
    }).toList();

    final allTypes = widget.historyService.history
        .map((e) => e.eventType.toString())
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Clear All",
            onPressed: () async {
              await widget.historyService.clear();
              setState(() {});
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by device, rule, or message',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (s) => setState(() => _search = s),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allTypes
                  .map((type) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type.split('.').last),
                          selected: _eventTypes.contains(type),
                          onSelected: (val) => setState(() {
                            val
                                ? _eventTypes.add(type)
                                : _eventTypes.remove(type);
                          }),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('No notifications yet'))
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (ctx, i) {
                      final e = entries[i];
                      return ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text('${e.ruleName} — ${e.deviceName}'),
                        subtitle: Text(
                            '${e.eventType.toString().split('.').last} • ${e.message ?? ''}'),
                        trailing: Text(
                          "${e.timestamp.hour.toString().padLeft(2, '0')}:${e.timestamp.minute.toString().padLeft(2, '0')}\n"
                          "${e.timestamp.year}-${e.timestamp.month.toString().padLeft(2, '0')}-${e.timestamp.day.toString().padLeft(2, '0')}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12),
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
