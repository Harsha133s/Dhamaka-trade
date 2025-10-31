import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bottom Navigation Bar
/// Navigation for mobile devices - Android and iOS only
/// Shows only: Today, Calendar, Analytics, Community

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.today_outlined,
                activeIcon: Icons.today,
                label: 'Today',
                isSelected: selectedIndex == 0,
              ),
              _buildNavItem(
                context: context,
                index: 8, // Calendar is index 8 in the main route mapping
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Calendar',
                isSelected: selectedIndex == 8,
              ),
              _buildNavItem(
                context: context,
                index: 3, // Analytics is index 3 in the main route mapping
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: 'Analytics',
                isSelected: selectedIndex == 3,
              ),
              _buildNavItem(
                context: context,
                index: 4, // Community is index 4 in the main route mapping
                icon: Icons.group_outlined,
                activeIcon: Icons.group,
                label: 'Community',
                isSelected: selectedIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          // Haptic feedback for touch interaction
          HapticFeedback.lightImpact();
          onDestinationSelected(index);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected 
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with smooth transition and glow effect
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ] : null,
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    size: 26,
                    color: isSelected 
                        ? primaryColor 
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Label with fade animation
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.7,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: isSelected 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                    color: isSelected 
                        ? primaryColor 
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
