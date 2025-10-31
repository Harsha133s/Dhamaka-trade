/// App Header
/// Top bar with logo, search, notifications, and side panel toggle

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onToggleSidePanel;
  final bool showToggleButton;
  final bool isSidePanelExpanded;
  
  const AppHeader({
    Key? key,
    this.onToggleSidePanel,
    this.showToggleButton = false,
    this.isSidePanelExpanded = true,
  }) : super(key: key);
  
  // Check if platform supports side panel toggle
  bool get _supportsSidePanelToggle => kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final authService = ref.read(authServiceProvider);
    
    return AppBar(
      title: Row(
        children: [
          // Side panel toggle button (only on desktop/web)
          if (showToggleButton && _supportsSidePanelToggle) ...[
            IconButton(
              onPressed: onToggleSidePanel,
              icon: Icon(isSidePanelExpanded ? Icons.menu_open : Icons.menu),
              tooltip: isSidePanelExpanded ? 'Collapse sidebar' : 'Expand sidebar',
            ),
            const SizedBox(width: 8),
          ],
          
          // Logo and title
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'TV',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text('TradeVerse AI'),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search trades...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white10,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        // Notifications icon with badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                _showNotificationsMenu(context);
              },
              tooltip: 'Notifications',
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        // Profile menu
        PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: const Color(0xFF3B82F6),
            child: Text(
              currentUser?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          tooltip: 'Profile',
          offset: const Offset(0, 50),
          onSelected: (value) async {
            switch (value) {
              case 'profile':
                // Navigate to profile
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigate to Profile')),
                  );
                }
                break;
              case 'settings':
                // Navigate to settings
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigate to Settings')),
                  );
                }
                break;
              case 'notifications':
                // Navigate to notifications
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigate to Notifications')),
                  );
                }
                break;
              case 'logout':
                // Show logout confirmation
                if (context.mounted) {
                  _showLogoutDialog(context, authService);
                }
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.userMetadata?['full_name'] ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currentUser?.email ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.account_circle_outlined),
                  SizedBox(width: 12),
                  Text('View Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'notifications',
              child: Row(
                children: [
                  Icon(Icons.notifications_outlined),
                  SizedBox(width: 12),
                  Text('Notifications'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
  
  /// Show notifications bottom sheet
  void _showNotificationsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Mark all as read'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: Icons.trending_up,
              color: Colors.green,
              title: 'Trade Completed',
              message: 'Your BTC/USD trade closed with +5.2% profit',
              time: '2m ago',
            ),
            _buildNotificationItem(
              icon: Icons.emoji_events,
              color: Colors.amber,
              title: 'Achievement Unlocked!',
              message: 'You\'ve completed the "Week Warrior" challenge',
              time: '1h ago',
            ),
            _buildNotificationItem(
              icon: Icons.people,
              color: Colors.blue,
              title: 'New Follower',
              message: '@trader_pro started following you',
              time: '3h ago',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    required String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
      trailing: Text(
        time,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }
  
  /// Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
