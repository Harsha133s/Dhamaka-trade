/// App Scaffold Widget
/// Responsive layout with NavigationRail (desktop) and BottomNav (mobile)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_header.dart';
import 'app_nav_rail.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({Key? key, required this.child}) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppHeader(),
      body: isLargeScreen
          ? Row(
              children: [
                AppNavRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                    _navigateToRoute(context, index);
                  },
                ),
                Expanded(child: widget.child),
              ],
            )
          : widget.child,
      bottomNavigationBar: !isLargeScreen
          ? AppBottomNav(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
                _navigateToRoute(context, index);
              },
            )
          : null,
    );
  }

  void _navigateToRoute(BuildContext context, int index) {
    final routes = [
      '/',
      '/today',
      '/journal',
      '/analytics',
      '/community',
      '/discover',
      '/challenges',
      '/inbox',
      '/calendar',
      '/settings',
    ];

    if (index < routes.length) {
      context.go(routes[index]);
    }
  }
}
