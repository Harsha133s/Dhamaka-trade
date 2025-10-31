import 'package:flutter/material.dart';
import '../models/running_trade_model.dart';
import '../services/trade_service.dart';

class CloseTradeDialog extends StatefulWidget {
  final RunningTrade trade;
  const CloseTradeDialog({super.key, required this.trade});

  @override
  State<CloseTradeDialog> createState() => _CloseTradeDialogState();
}

class _CloseTradeDialogState extends State<CloseTradeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _exitCtrl = TextEditingController();
  final _resultCtrl = TextEditingController();
  bool _saving = false;
  final _service = TradeService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Close ${widget.trade.pair}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _exitCtrl,
              decoration: const InputDecoration(labelText: 'Exit Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter number' : null,
              onChanged: (_) => _recalc(),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _resultCtrl,
              decoration: const InputDecoration(labelText: 'Result (P&L)'),
              readOnly: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(
          onPressed: _saving
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _saving = true);
                  try {
                    await _service.closeTrade(
                      tradeId: widget.trade.id,
                      exitPrice: double.parse(_exitCtrl.text.trim()),
                      result: double.parse(_resultCtrl.text.trim()),
                    );
                    if (mounted) Navigator.pop(context, true);
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
          child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Close Trade'),
        )
      ],
    );
  }

  void _recalc() {
    final exit = double.tryParse(_exitCtrl.text.trim());
    if (exit == null) return;
    final isLong = widget.trade.type == TradeType.buy;
    final diff = isLong ? exit - widget.trade.entryPrice : widget.trade.entryPrice - exit;
    _resultCtrl.text = diff.toStringAsFixed(2);
    setState(() {});
  }
}