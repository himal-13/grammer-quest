import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingTile(
            context,
            'Dark Mode',
            'Switch between light and dark themes',
            Icons.dark_mode_rounded,
            Switch(
              value: settings.isDarkMode,
              onChanged: (_) => settings.toggleDarkMode(),
              activeColor: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            context,
            'Sound Effects',
            'Play sounds when you guess correctly or wrong',
            Icons.volume_up_rounded,
            Switch(
              value: settings.soundEnabled,
              onChanged: (_) => settings.toggleSound(),
              activeColor: theme.primaryColor,
            ),
          ),
          const Divider(height: 48),
          const Center(
            child: Text(
              'Grammar Quest v1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget trailing,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}
