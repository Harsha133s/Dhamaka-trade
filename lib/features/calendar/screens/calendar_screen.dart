import 'package:flutter/material.dart';
import '../../../core/widgets/ui_components.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/glassmorphic_components.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Calendar', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 32),
          SectionHeader(
            title: 'December 2024',
            icon: Icons.calendar_month,
          ),
          GlassContainer(
            child: Column(
              children: [
                GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: List.generate(
                      35,
                      (index) {
                        final isProfitable = index % 3 == 0;
                        final isLoss = index % 5 == 0 && index != 0;
                        return Container(
                          decoration: BoxDecoration(
                            color: isProfitable
                                ? AppColors.success.withValues(alpha: 0.12)
                                : isLoss
                                    ? AppColors.danger.withValues(alpha: 0.12)
                                    : AppColors.glassHighlight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isProfitable
                                  ? AppColors.success
                                  : isLoss
                                      ? AppColors.danger
                                      : AppColors.glassBorder,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (isProfitable || isLoss)
                                  Icon(
                                    isProfitable
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    size: 12,
                                    color: isProfitable ? AppColors.success : AppColors.danger,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          SectionHeader(
            title: 'Trading Days Summary',
            icon: Icons.bar_chart,
          ),
          GlassContainer(
            child: Column(
              children: [
                _CalendarStat(label: 'Profitable Days', value: '12'),
                _CalendarStat(label: 'Loss Days', value: '3'),
                _CalendarStat(label: 'Total P&L', value: '+\$3,240'),
                _CalendarStat(label: 'Best Day', value: '+\$890'),
                _CalendarStat(label: 'Worst Day', value: '-\$325'),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _CalendarStat extends StatelessWidget {
  final String label;
  final String value;

  const _CalendarStat({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
