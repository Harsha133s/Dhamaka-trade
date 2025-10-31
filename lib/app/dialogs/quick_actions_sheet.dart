/// Quick Actions Bottom Sheet
/// Frosted glass bottom sheet with action tiles for quick access to common tasks

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../core/theme/app_tokens.dart';

class QuickActionsSheet extends StatelessWidget {
  const QuickActionsSheet({super.key});
  
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const QuickActionsSheet(),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: AppBlur.modal,
          sigmaY: AppBlur.modal,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Title
                Text(
                  'Quick Actions',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Action tiles in 2 columns
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ActionTile(
                      icon: Icons.person_add,
                      title: 'Add Friend',
                      gradient: AppColors.communityGradient,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Show add friend dialog
                      },
                    ),
                    _ActionTile(
                      icon: Icons.group_add,
                      title: 'Create Group',
                      gradient: AppColors.communityGradient,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Show create group dialog
                      },
                    ),
                    _ActionTile(
                      icon: Icons.note_add,
                      title: 'Log Note',
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF818CF8), Color(0xFF1E293B)],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Show log note dialog
                      },
                    ),
                    _ActionTile(
                      icon: Icons.photo_library,
                      title: 'Upload Media',
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF472B6), Color(0xFF1E293B)],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Show media picker
                      },
                    ),
                    _ActionTile(
                      icon: Icons.insights,
                      title: 'AI Insights',
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF34D399), Color(0xFF1E293B)],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Show AI insights
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onTap;
  
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppElevation.softShadow(),
        ),
        child: Stack(
          children: [
            const GrainOverlay(opacity: 0.04),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.input),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
