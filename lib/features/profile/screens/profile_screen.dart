import 'package:flutter/material.dart';
import '../../../core/widgets/ui_components.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/glassmorphic_components.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 3D glowing avatar ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryAccent, AppColors.primaryAccentLight],
                    ),
                    boxShadow: AppElevation.glowShadow(AppColors.primaryAccent),
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.glassHighlight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Trader Profile',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $userId',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Follow'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Message'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Stats
          SectionHeader(
            title: 'Trading Stats',
            icon: Icons.trending_up,
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              StatCard(
                title: 'Win Rate',
                value: '68%',
                icon: Icons.trending_up,
                color: const Color(0xFF10B981),
              ),
              StatCard(
                title: 'Total Profit',
                value: '\$12,500',
                icon: Icons.attach_money,
                color: const Color(0xFF10B981),
              ),
              StatCard(
                title: 'Total Trades',
                value: '245',
                icon: Icons.receipt,
                color: const Color(0xFF3B82F6),
              ),
              StatCard(
                title: 'Avg Trade',
                value: '\$51',
                icon: Icons.calculate,
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Recent Trades
          SectionHeader(
            title: 'Recent Trades',
            icon: Icons.list_alt,
          ),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TradingCard(
                symbol: ['EUR/USD', 'GBP/USD', 'USD/JPY'][index],
                side: index.isEven ? 'Long' : 'Short',
                entryPrice: '${1.0800 + (index * 0.001)}',
                exitPrice: '${1.0850 + (index * 0.001)}',
                pnl: '${index.isEven ? '+' : '-'}\$${(index + 1) * 150}',
                isProfitable: index.isEven,
                date: '${DateTime.now().subtract(Duration(days: index)).day} Dec',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
