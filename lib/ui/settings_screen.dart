import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const SettingsScreen(
      {super.key,
      required this.initialThemeMode,
      required this.onThemeModeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: _themeMode,
              items: const [
                DropdownMenuItem(
                    value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  setState(() => _themeMode = mode);
                  widget.onThemeModeChanged(mode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
