import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_history_entry.dart';

class NotificationHistoryService {
  static const _historyKey = 'notification_history';
  final List<NotificationHistoryEntry> _history = [];

  List<NotificationHistoryEntry> get history => List.unmodifiable(_history);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_historyKey) ?? [];
    _history
      ..clear()
      ..addAll(
          list.map((e) => NotificationHistoryEntry.fromMap(jsonDecode(e))));
  }

  Future<void> add(NotificationHistoryEntry entry) async {
    _history.insert(0, entry); // newest first
    await _persist();
  }

  Future<void> clear() async {
    _history.clear();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _history.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_historyKey, list);
  }
}
