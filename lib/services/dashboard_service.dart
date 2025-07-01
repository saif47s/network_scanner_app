import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/dashboard_widget.dart';

class DashboardService {
  static const _key = "user_dashboard";
  Future<UserDashboardConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return UserDashboardConfig();
    return UserDashboardConfig.fromMap(jsonDecode(data));
  }

  Future<void> save(UserDashboardConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(config.toMap()));
  }
}
