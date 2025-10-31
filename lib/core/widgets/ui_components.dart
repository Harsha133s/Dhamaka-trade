/// Reusable UI Components
/// Shared widgets for consistent Material 3 design

import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';
import 'glassmorphic_components.dart';

/// Section Header with icon and title
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onViewMore;

  const SectionHeader({
    Key? key,
    required this.title,
    this.icon,
    this.onViewMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primaryAccent, size: 24),
            const SizedBox(width: AppSpacing.md),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          if (onViewMore != null)
            TextButton(
              onPressed: onViewMore,
              child: const Text('View More'),
            ),
        ],
      ),
    );
  }
}

/// Stat Card showing a key metric
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? trend;
  final bool trendUp;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.trend,
    this.trendUp = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? const Color(0xFF3B82F6);
    return GlassContainer(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.glassHighlight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: cardColor, size: 20),
                ),
                const Spacer(),
                if (trend != null)
                  Row(
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up : Icons.trending_down,
                        color: trendUp ? AppColors.success : AppColors.danger,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: TextStyle(
                          color: trendUp ? AppColors.success : AppColors.danger,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: cardColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
    );
  }
}

/// Trading Card for displaying trade information
class TradingCard extends StatelessWidget {
  final String symbol;
  final String side;
  final String entryPrice;
  final String exitPrice;
  final String pnl;
  final bool isProfitable;
  final String date;
  final VoidCallback? onTap;

  const TradingCard({
    Key? key,
    required this.symbol,
    required this.side,
    required this.entryPrice,
    required this.exitPrice,
    required this.pnl,
    required this.isProfitable,
    required this.date,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        side,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: side == 'Long' ? AppColors.success : AppColors.danger,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isProfitable
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.danger.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isProfitable ? AppColors.success : AppColors.danger,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      pnl,
                      style: TextStyle(
                        color: isProfitable ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entry',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        entryPrice,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    size: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exit',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        exitPrice,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Info Banner for alerts and messages
class InfoBanner extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;

  const InfoBanner({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryAccent.withValues(alpha: 0.12),
        border: Border.all(
          color: borderColor ?? AppColors.primaryAccent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: borderColor ?? const Color(0xFF3B82F6),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: borderColor ?? AppColors.primaryAccent,
                      ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
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

/// Leaderboard Entry Row
class LeaderboardEntry extends StatelessWidget {
  final int rank;
  final String name;
  final String score;
  final String? avatar;
  final bool isCurrentUser;

  const LeaderboardEntry({
    Key? key,
    required this.rank,
    required this.name,
    required this.score,
    this.avatar,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
        color: isCurrentUser ? AppColors.primaryAccent.withValues(alpha: 0.06) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Win Rate: ${(rank * 5).toString()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              score,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Notification Item
class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.time,
    this.isRead = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(color: AppColors.glassBorder),
          ),
          color: !isRead ? AppColors.primaryAccent.withValues(alpha: 0.06) : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glassHighlight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
