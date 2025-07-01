enum DashboardWidgetType { quickStats, favoriteDevices, eventChart, tagSummary }

class DashboardWidgetConfig {
  final DashboardWidgetType type;
  final Map<String, dynamic> params; // e.g., {"tag": "IoT"}

  DashboardWidgetConfig({required this.type, this.params = const {}});

  Map<String, dynamic> toMap() => {
        'type': type.toString(),
        'params': params,
      };

  factory DashboardWidgetConfig.fromMap(Map<String, dynamic> map) =>
      DashboardWidgetConfig(
        type: DashboardWidgetType.values
            .firstWhere((e) => e.toString() == map['type']),
        params: Map<String, dynamic>.from(map['params'] ?? {}),
      );
}

class UserDashboardConfig {
  final List<DashboardWidgetConfig> widgets;

  UserDashboardConfig({this.widgets = const []});

  Map<String, dynamic> toMap() => {
        'widgets': widgets.map((w) => w.toMap()).toList(),
      };

  factory UserDashboardConfig.fromMap(Map<String, dynamic> map) =>
      UserDashboardConfig(
        widgets: (map['widgets'] as List<dynamic>? ?? [])
            .map((w) =>
                DashboardWidgetConfig.fromMap(Map<String, dynamic>.from(w)))
            .toList(),
      );
}
