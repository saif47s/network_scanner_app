import 'package:flutter/material.dart';

class DeviceTagEditor extends StatefulWidget {
  final List<String> initialTags;
  final void Function(List<String>) onTagsChanged;

  const DeviceTagEditor(
      {super.key, required this.initialTags, required this.onTagsChanged});

  @override
  State<DeviceTagEditor> createState() => _DeviceTagEditorState();
}

class _DeviceTagEditorState extends State<DeviceTagEditor> {
  late List<String> _tags;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  void _addTag(String tag) {
    tag = tag.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() {
      _tags.add(tag);
    });
    widget.onTagsChanged(_tags);
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          children: _tags
              .map((tag) => Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                  ))
              .toList(),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Add tag (e.g. IoT, Printer, Office)",
                ),
                onSubmitted: (value) {
                  _addTag(value);
                  _controller.clear();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addTag(_controller.text);
                _controller.clear();
              },
            )
          ],
        ),
      ],
    );
  }
}
