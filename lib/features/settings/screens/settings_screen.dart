import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/ui_components.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 32),
          SectionHeader(
            title: 'Appearance',
            icon: Icons.palette,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dark Mode', style: Theme.of(context).textTheme.titleLarge),
                      Switch(
                        value: settings.darkMode,
                        onChanged: (value) => settingsNotifier.setDarkMode(value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Notifications',
            icon: Icons.notifications,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Enable Notifications', style: Theme.of(context).textTheme.titleLarge),
                      Switch(
                        value: settings.notifications,
                        onChanged: (value) => settingsNotifier.setNotifications(value),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sound', style: Theme.of(context).textTheme.titleLarge),
                      Switch(
                        value: settings.soundEnabled,
                        onChanged: (value) => settingsNotifier.setSoundEnabled(value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Account',
            icon: Icons.account_circle,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile Settings'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.red),
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true && context.mounted) {
                        await Supabase.instance.client.auth.signOut();
                        if (context.mounted) {
                          context.go('/auth');
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'TradeVerse AI v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
