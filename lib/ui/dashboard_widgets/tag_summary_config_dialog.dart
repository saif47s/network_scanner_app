import 'package:flutter/material.dart';

class TagSummaryConfigDialog extends StatefulWidget {
  final Map<String, dynamic> initialParams;
  final List<String> availableTags;

  const TagSummaryConfigDialog(
      {super.key, required this.initialParams, required this.availableTags});

  @override
  State<TagSummaryConfigDialog> createState() => _TagSummaryConfigDialogState();
}

class _TagSummaryConfigDialogState extends State<TagSummaryConfigDialog> {
  String? _selectedTag;
  @override
  void initState() {
    super.initState();
    _selectedTag = widget.initialParams['tag'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Configure Tag Summary"),
      content: DropdownButtonFormField<String>(
        value: _selectedTag,
        decoration: const InputDecoration(labelText: "Tag"),
        items: widget.availableTags
            .map((tag) => DropdownMenuItem(value: tag, child: Text(tag)))
            .toList(),
        onChanged: (val) => setState(() => _selectedTag = val),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {'tag': _selectedTag}),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
