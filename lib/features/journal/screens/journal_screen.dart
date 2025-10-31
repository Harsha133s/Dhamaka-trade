import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../today/models/running_trade_model.dart';
import '../../today/services/trade_service.dart';
import 'trade_detail_screen.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _tradeService = TradeService();
  List<RunningTrade> _closedTrades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClosedTrades();
  }

  Future<void> _loadClosedTrades() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final trades = await _tradeService.getClosedTrades(limit: 50);
      if (mounted) {
        setState(() {
          _closedTrades = trades;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildTradeList(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade Journal',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Track and analyze your trades',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTradeList(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_closedTrades.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Closed Trades (${_closedTrades.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ..._closedTrades.map((trade) => _buildTradeCard(trade)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.article_outlined,
                size: 64,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Closed Trades Yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Close your first trade to see it here',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeCard(RunningTrade trade) {
    final isProfit = trade.result != null && trade.isProfitable;
    final isLoss = trade.result != null && trade.isLoss;
    final pnlColor = isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final tradeTypeColor = trade.type == TradeType.buy
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    
    return InkWell(
      onTap: () => _showTradeDetail(trade),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F29),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isProfit
                ? const Color(0xFF10B981).withValues(alpha: 0.3)
                : isLoss
                    ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                    : Colors.grey[800]!,
          ),
          boxShadow: [
            if (isProfit || isLoss)
              BoxShadow(
                color: (isProfit
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444))
                    .withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tradeTypeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: tradeTypeColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        trade.typeDisplayName,
                        style: TextStyle(
                          color: tradeTypeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      trade.pair,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      trade.formattedResult,
                      style: TextStyle(
                        color: pnlColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (trade.hasImage || trade.hasAudio)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (trade.hasImage)
                            Icon(
                              Icons.image_rounded,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                          if (trade.hasImage && trade.hasAudio)
                            const SizedBox(width: 4),
                          if (trade.hasAudio)
                            Icon(
                              Icons.mic_rounded,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entry: ${trade.entryPrice.toStringAsFixed(5)} → Exit: ${trade.exitPrice?.toStringAsFixed(5) ?? 'N/A'}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
                Text(
                  trade.formattedDuration,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            if (trade.hasNotes) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trade.notes!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Tap to view details',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTradeDetail(RunningTrade trade) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TradeDetailScreen(trade: trade),
      ),
    );
  }
}