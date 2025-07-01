import 'package:flutter/material.dart';
import '../models/device.dart';
import 'device_tag_editor.dart';

class DeviceEditScreen extends StatefulWidget {
  final Device device;
  final void Function(Device) onSave;

  const DeviceEditScreen(
      {super.key, required this.device, required this.onSave});

  @override
  State<DeviceEditScreen> createState() => _DeviceEditScreenState();
}

class _DeviceEditScreenState extends State<DeviceEditScreen> {
  late Device _device;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Device')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              initialValue: _device.name,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => _device.name = v,
            ),
            // ... other fields ...
            const SizedBox(height: 16),
            const Text("Tags:"),
            DeviceTagEditor(
              initialTags: _device.tags,
              onTagsChanged: (tags) {
                setState(() {
                  _device.tags = tags;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                widget.onSave(_device);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
