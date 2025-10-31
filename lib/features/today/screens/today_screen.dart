import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import '../models/running_trade_model.dart';
import '../services/trade_service.dart';
import '../dialogs/new_trade_dialog_enhanced.dart';
import '../dialogs/close_trade_dialog.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _service = TradeService();
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _stats = const {};
  List<RunningTrade> _running = const [];
  List<RunningTrade> _today = const [];
  String _ai = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _service.getTodayStats(),
        _service.getRunningTrades(),
        _service.getTradesForToday(limit: 20),
        _service.getAiSummary(),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as Map<String, dynamic>;
        _running = results[1] as List<RunningTrade>;
        _today = results[2] as List<RunningTrade>;
        _ai = results[3] as String;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewTrade(),
        icon: const Icon(Icons.add),
        label: const Text('New Trade'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                if (_error != null)
                  Container(padding: const EdgeInsets.all(12), decoration: _cardDeco(), child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
                const SizedBox(height: 8),
                _buildKPIs(),
                const SizedBox(height: 24),
                _buildRunningSection(),
                const SizedBox(height: 24),
                _buildTradesForToday(),
                const SizedBox(height: 24),
                _buildAiSummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Trading', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(DateFormat('EEEE, MMM d').format(now), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildKPIs() {
    final pnl = (_stats['total_pnl'] as num? ?? 0).toDouble();
    final wr = (_stats['win_rate'] as num? ?? 0).toDouble();
    final total = _stats['total_trades'] ?? 0;

    Widget card(String title, String value, {Color? color, String? subtitle}) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDeco(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color ?? Colors.white, fontWeight: FontWeight.w700)),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ]),
      );
    }

    return Column(
      children: [
        Row(children: [
          Expanded(child: card('Today\'s P/L', '${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(2)}', color: pnl >= 0 ? const Color(0xFF00D97E) : const Color(0xFFFF5C5C))),
          const SizedBox(width: 16),
          Expanded(child: card('Win Rate', '${wr.toStringAsFixed(0)}%', color: const Color(0xFF5B7CFF))),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: card('Total Trades', '$total', subtitle: '+2 ↑')),
          const SizedBox(width: 16),
          const Expanded(child: SizedBox()),
        ]),
      ],
    );
  }

  Widget _buildRunningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Running Trades', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        if (_loading)
          Container(height: 100, decoration: _cardDeco())
        else if (_running.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDeco(),
            child: Column(children: const [
              SizedBox(height: 12),
              Icon(Icons.show_chart, color: Colors.grey),
              SizedBox(height: 8),
              Text('No Running Trades', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 12),
            ]),
          )
        else
          Column(children: _running.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _runningCard(t))).toList()),
      ],
    );
  }

  Widget _runningCard(RunningTrade t) {
    final color = t.type == TradeType.buy ? const Color(0xFF00D97E) : const Color(0xFFFF5C5C);
    return InkWell(
      onTap: () => _showClose(t),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDeco(),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.trending_up, color: color, size: 18)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.pair, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Entry ${t.entryPrice.toStringAsFixed(2)} • ${t.typeDisplayName}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ])),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF5B7CFF).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)), child: const Text('OPEN', style: TextStyle(color: Color(0xFF5B7CFF), fontWeight: FontWeight.w600)))
          ],
        ),
      ),
    );
  }

  Widget _buildTradesForToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trades For Today', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        if (_loading)
          Column(children: List.generate(2, (i) => const Padding(padding: EdgeInsets.only(bottom: 12), child: SizedBox(height: 84))).toList())
        else if (_today.isEmpty)
          Container(padding: const EdgeInsets.all(16), decoration: _cardDeco(), child: Text('No trades closed today', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)))
        else
          Column(children: _today.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _closedRow(t))).toList()),
      ],
    );
  }

  Widget _closedRow(RunningTrade t) {
    final pnl = (t.result ?? 0).toDouble();
    final pnlColor = pnl >= 0 ? const Color(0xFF00D97E) : const Color(0xFFFF5C5C);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pnlColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)), child: Icon(pnl >= 0 ? Icons.trending_up : Icons.trending_down, color: pnlColor, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.pair, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text('Status: Closed', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
          const SizedBox(height: 2),
          Text('Entry: ${t.entryPrice.toStringAsFixed(2)}, Exit: ${t.exitPrice?.toStringAsFixed(2) ?? '-'}', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
        ])),
        const SizedBox(width: 12),
        Text('${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(2)}', style: TextStyle(color: pnlColor, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _buildAiSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Row(children: const [
        CircleAvatar(radius: 16, backgroundColor: Color(0xFF8B5CF6), child: Icon(Icons.auto_awesome, color: Colors.white, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text('', style: TextStyle(color: Colors.white70))),
      ]),
    );
  }

  Future<void> _showNewTrade() async {
    final ok = await showDialog(context: context, builder: (_) => const NewTradeDialogEnhanced());
    if (ok == true) await _refresh();
  }

  Future<void> _showClose(RunningTrade t) async {
    final ok = await showDialog(context: context, builder: (_) => CloseTradeDialog(trade: t));
    if (ok == true) await _refresh();
  }
  // Simple card decoration similar to glass look
  BoxDecoration _cardDeco() => BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x33FFFFFF), width: 1),
      );
}
