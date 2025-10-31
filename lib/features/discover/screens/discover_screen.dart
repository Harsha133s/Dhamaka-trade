import 'package:flutter/material.dart';
import '../../../core/widgets/ui_components.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Discover', style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 32),
          SectionHeader(
            title: 'AI Recommendations',
            icon: Icons.auto_awesome,
          ),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'T${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top Trader ${index + 1}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.trending_up,
                                    size: 14, color: const Color(0xFF10B981)),
                                const SizedBox(width: 4),
                                Text(
                                  '${65 + index * 3}% Win Rate',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.attach_money,
                                    size: 14, color: const Color(0xFF10B981)),
                                const SizedBox(width: 4),
                                Text(
                                  '+\$${5000 + index * 1000}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
