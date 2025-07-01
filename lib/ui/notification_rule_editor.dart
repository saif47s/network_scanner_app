import 'package:flutter/material.dart';
import '../models/notification_rule.dart';
import '../models/device_event.dart';

class NotificationRuleEditor extends StatefulWidget {
  final NotificationRule? initialRule;
  final void Function(NotificationRule) onSave;

  const NotificationRuleEditor(
      {super.key, this.initialRule, required this.onSave});

  @override
  State<NotificationRuleEditor> createState() => _NotificationRuleEditorState();
}

class _NotificationRuleEditorState extends State<NotificationRuleEditor> {
  late TextEditingController _nameCtrl;
  DeviceEventType? _eventType;
  String? _tag;
  String? _deviceNameContains;
  String? _deviceIp;
  int? _hourStart;
  int? _hourEnd;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRule;
    _nameCtrl = TextEditingController(text: r?.name ?? '');
    _eventType = r?.eventType;
    _tag = r?.tag;
    _deviceNameContains = r?.deviceNameContains;
    _deviceIp = r?.deviceIp;
    _hourStart = r?.hourStart;
    _hourEnd = r?.hourEnd;
  }

  void _save() {
    widget.onSave(NotificationRule(
      id: widget.initialRule?.id ?? UniqueKey().toString(),
      name: _nameCtrl.text,
      eventType: _eventType,
      tag: _tag,
      deviceNameContains: _deviceNameContains,
      deviceIp: _deviceIp,
      hourStart: _hourStart,
      hourEnd: _hourEnd,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialRule == null
          ? 'Add Notification Rule'
          : 'Edit Notification Rule'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Rule Name'),
            ),
            DropdownButtonFormField<DeviceEventType>(
              value: _eventType,
              items: [
                ...DeviceEventType.values.map(
                  (e) => DropdownMenuItem(
                      value: e, child: Text(e.toString().split('.').last)),
                )
              ],
              onChanged: (e) => setState(() => _eventType = e),
              decoration:
                  const InputDecoration(labelText: 'Event Type (optional)'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Tag (optional)'),
              onChanged: (v) => _tag = v,
              controller: TextEditingController(text: _tag),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Device Name Contains (optional)'),
              onChanged: (v) => _deviceNameContains = v,
              controller: TextEditingController(text: _deviceNameContains),
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Device IP or CIDR (optional)'),
              onChanged: (v) => _deviceIp = v,
              controller: TextEditingController(text: _deviceIp),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Start Hour (0-23, optional)'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _hourStart = int.tryParse(v),
                    controller: TextEditingController(
                        text: _hourStart?.toString() ?? ''),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'End Hour (0-23, optional)'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _hourEnd = int.tryParse(v),
                    controller:
                        TextEditingController(text: _hourEnd?.toString() ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              _save();
              Navigator.pop(context);
            }),
      ],
    );
  }
}
