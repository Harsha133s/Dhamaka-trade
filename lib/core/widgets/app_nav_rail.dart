/// Navigation Rail
/// Vertical navigation for desktop/tablet

import 'package:flutter/material.dart';

class AppNavRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final bool extended;

  const AppNavRail({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If we're in drawer mode (not extended), return ListView with ListTiles
    if (!extended && MediaQuery.of(context).size.width <= 1200) {
      return ListView(
        children: [
          _buildNavTile(0, Icons.today_outlined, Icons.today, 'Today'),
          _buildNavTile(1, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
          _buildNavTile(2, Icons.book_outlined, Icons.book, 'Journal'),
          _buildNavTile(3, Icons.analytics_outlined, Icons.analytics, 'Analytics'),
          _buildNavTile(4, Icons.group_outlined, Icons.group, 'Community'),
          _buildNavTile(5, Icons.explore_outlined, Icons.explore, 'Discover'),
          _buildNavTile(6, Icons.emoji_events_outlined, Icons.emoji_events, 'Challenges'),
          _buildNavTile(7, Icons.mail_outlined, Icons.mail, 'Inbox'),
          _buildNavTile(8, Icons.calendar_month_outlined, Icons.calendar_month, 'Calendar'),
          _buildNavTile(9, Icons.settings_outlined, Icons.settings, 'Settings'),
        ],
      );
    }
    
    // NavigationRail for large screens (both extended and collapsed)
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      // Show labels when collapsed (icon-only mode), hide when extended
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.today_outlined),
          selectedIcon: Icon(Icons.today),
          label: Text('Today'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.book_outlined),
          selectedIcon: Icon(Icons.book),
          label: Text('Journal'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: Text('Analytics'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.group_outlined),
          selectedIcon: Icon(Icons.group),
          label: Text('Community'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: Text('Discover'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.emoji_events_outlined),
          selectedIcon: Icon(Icons.emoji_events),
          label: Text('Challenges'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.mail_outlined),
          selectedIcon: Icon(Icons.mail),
          label: Text('Inbox'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: Text('Calendar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }

  Widget _buildNavTile(int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = selectedIndex == index;
    
    return Builder(
      builder: (context) => ListTile(
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : null,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => onDestinationSelected(index),
      ),
    );
  }
}
