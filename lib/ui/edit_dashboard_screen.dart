import 'package:flutter/material.dart';
import '../models/dashboard_widget.dart';

class EditDashboardScreen extends StatefulWidget {
  final UserDashboardConfig config;

  const EditDashboardScreen({super.key, required this.config});

  @override
  State<EditDashboardScreen> createState() => _EditDashboardScreenState();
}

class _EditDashboardScreenState extends State<EditDashboardScreen> {
  late List<DashboardWidgetConfig> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = List.of(widget.config.widgets);
  }

  void _addWidget(DashboardWidgetType type) {
    setState(() {
      _widgets.add(DashboardWidgetConfig(type: type));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Dashboard")),
      body: ReorderableListView(
        onReorder: (oldIdx, newIdx) {
          setState(() {
            if (newIdx > oldIdx) newIdx--;
            final item = _widgets.removeAt(oldIdx);
            _widgets.insert(newIdx, item);
          });
        },
        children: [
          for (int i = 0; i < _widgets.length; i++)
            ListTile(
              key: ValueKey(_widgets[i].type),
              title: Text(_widgets[i].type.toString().split('.').last),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => setState(() => _widgets.removeAt(i)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final type = await showDialog<DashboardWidgetType>(
            context: context,
            builder: (ctx) => SimpleDialog(
              title: const Text("Add Widget"),
              children: DashboardWidgetType.values
                  .map((t) => SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, t),
                        child: Text(t.toString().split('.').last),
                      ))
                  .toList(),
            ),
          );
          if (type != null) _addWidget(type);
        },
      ),
      persistentFooterButtons: [
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () {
            // Save config (local or cloud)
            Navigator.pop(context, UserDashboardConfig(widgets: _widgets));
          },
        )
      ],
    );
  }
}
