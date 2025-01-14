import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_dark.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Receber Notificações'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Modo Escuro'),
            value: themeNotifier.darkTheme,
            onChanged: (bool value) {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}