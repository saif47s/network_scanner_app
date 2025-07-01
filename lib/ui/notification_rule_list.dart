import 'package:flutter/material.dart';
import '../services/notification_rule_service.dart';
import 'notification_rule_editor.dart';

class NotificationRuleListScreen extends StatefulWidget {
  final NotificationRuleService ruleService;

  const NotificationRuleListScreen({super.key, required this.ruleService});

  @override
  State<NotificationRuleListScreen> createState() =>
      _NotificationRuleListScreenState();
}

class _NotificationRuleListScreenState
    extends State<NotificationRuleListScreen> {
  @override
  Widget build(BuildContext context) {
    final rules = widget.ruleService.rules;
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Rules')),
      body: ListView.builder(
        itemCount: rules.length,
        itemBuilder: (ctx, i) {
          final r = rules[i];
          return ListTile(
            title: Text(r.name),
            subtitle: Text(
                'Event: ${r.eventType?.toString().split('.').last ?? "Any"}'
                '${r.tag != null ? ", Tag: ${r.tag}" : ""}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() => widget.ruleService.removeRule(r.id));
              },
            ),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (ctx) => NotificationRuleEditor(
                  initialRule: r,
                  onSave: (updated) {
                    setState(() => widget.ruleService.addRule(updated));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (ctx) => NotificationRuleEditor(
              onSave: (rule) =>
                  setState(() => widget.ruleService.addRule(rule)),
            ),
          );
        },
      ),
    );
  }
}
