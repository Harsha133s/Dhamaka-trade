import 'package:flutter/material.dart';
import '../models/running_trade_model.dart';
import '../services/trade_service.dart';

class NewTradeDialogEnhanced extends StatefulWidget {
  const NewTradeDialogEnhanced({super.key});

  @override
  State<NewTradeDialogEnhanced> createState() => _NewTradeDialogEnhancedState();
}

class _NewTradeDialogEnhancedState extends State<NewTradeDialogEnhanced> {
  final _formKey = GlobalKey<FormState>();
  final _entryCtrl = TextEditingController();
  TradeType _type = TradeType.buy;
  bool _saving = false;

  // Pairs state (with simple icon text)
  List<String> _pairs = const ['AAPL', 'TSLA', 'EUR/USD', 'GBP/USD', 'BTC/USDT'];
  String _selectedPair = 'AAPL';

  final _service = TradeService();

  @override
  void initState() {
    super.initState();
    _loadPairs();
  }

  Future<void> _loadPairs() async {
    try {
      final remote = await _service.getPairs();
      if (remote.isNotEmpty) {
        setState(() {
          _pairs = remote;
          if (!_pairs.contains(_selectedPair)) {
            _selectedPair = _pairs.first;
          }
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: const Color(0xFF0F1419),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 6)),
                        ],
                      ),
                      child: const Icon(Icons.auto_graph, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start New Trade', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('Select pair, direction, and entry price.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    )
                  ],
                ),

                const SizedBox(height: 16),
                Container(height: 1, color: Colors.white10),

                const SizedBox(height: 16),
                Text('Pair', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._pairs.map((p) => _pairPill(p)),
                    _addPill(),
                  ],
                ),

                const SizedBox(height: 18),
                Text('Direction', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _directionPill(TradeType.buy)),
                    const SizedBox(width: 12),
                    Expanded(child: _directionPill(TradeType.sell)),
                  ],
                ),

                const SizedBox(height: 18),
                Text('Entry Price', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70)),
                const SizedBox(height: 10),
                _glassInput(),

                const Spacer(),
                Row(
                  children: [
                    TextButton(
                      onPressed: _saving ? null : () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    _primaryActionButton(
                      onPressed: _saving ? null : _submit,
                      label: 'Start Trade',
                      loading: _saving,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pairPill(String pair) {
    final selected = pair == _selectedPair;
    return _HoverScale(
      child: InkWell(
        onTap: () => setState(() => _selectedPair = pair),
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: selected
                ? const LinearGradient(colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)])
                : null,
            color: selected ? null : const Color(0x1AFFFFFF),
            boxShadow: selected
                ? const [BoxShadow(color: Color(0x4D5B7CFF), blurRadius: 16, offset: Offset(0, 8))]
                : const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
            border: Border.all(color: selected ? Colors.transparent : Colors.white24),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            _pairIcon(pair),
            const SizedBox(width: 8),
            Text(pair, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }

  Widget _pairIcon(String pair) {
    // Simple mapping with emojis for FX, and generic icon otherwise
    if (pair.contains('/')) {
      // Try to split currency codes for emoji flags (approx)
      final parts = pair.split('/');
      final left = parts.first.trim();
      final right = parts.last.trim();
      return CircleAvatar(
        radius: 10,
        backgroundColor: Colors.transparent,
        child: Text(_flagEmoji(left) + _flagEmoji(right), style: const TextStyle(fontSize: 12)),
      );
    }
    return const Icon(Icons.show_chart, size: 18);
  }

  String _flagEmoji(String code) {
    // Map ISO currency to country (rough)
    final map = {
      'EUR': '🇪🇺',
      'USD': '🇺🇸',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'AUD': '🇦🇺',
      'CAD': '🇨🇦',
      'CHF': '🇨🇭',
      'NZD': '🇳🇿',
      'USDT': '🪙',
      'BTC': '₿',
    };
    return map[code.toUpperCase()] ?? '•';
  }

  Widget _addPill() {
    return _HoverScale(
      child: InkWell(
        onTap: _addPair,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0x1AFFFFFF),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: const [
            Icon(Icons.add, size: 18, color: Colors.white70),
            SizedBox(width: 6),
            Text('Add', style: TextStyle(color: Colors.white70)),
          ]),
        ),
      ),
    );
  }

  Future<void> _addPair() async {
    final pair = await showDialog<String>(
      context: context,
      builder: (ctx) => const _AddPairDialog(),
    );
    if (pair != null && pair.isNotEmpty) {
      await _service.addPair(pair);
      await _loadPairs();
      setState(() => _selectedPair = pair);
    }
  }

  Widget _directionPill(TradeType value) {
    final selected = _type == value;
    final isBuy = value == TradeType.buy;
    final colors = isBuy
        ? const [Color(0xFF10B981), Color(0xFF34D399)]
        : const [Color(0xFFEF4444), Color(0xFFF87171)];

    return _HoverScale(
      child: InkWell(
        onTap: () => setState(() => _type = value),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: selected ? LinearGradient(colors: colors) : null,
            color: selected ? null : const Color(0x1AFFFFFF),
            border: Border.all(color: selected ? Colors.transparent : Colors.white24),
            boxShadow: selected
                ? [BoxShadow(color: (isBuy ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 8))]
                : const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isBuy ? Icons.north_east : Icons.south_west, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(isBuy ? 'Buy / Long' : 'Sell / Short', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassInput() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: const Color(0x11FFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 8)),
          BoxShadow(color: Colors.white10, blurRadius: 4, spreadRadius: -2),
        ],
      ),
      child: TextFormField(
        controller: _entryCtrl,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: 'e.g. 150.25',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => (double.tryParse((v ?? '').trim()) == null) ? 'Enter a valid number' : null,
      ),
    );
  }

  Widget _primaryActionButton({required VoidCallback? onPressed, required String label, bool loading = false}) {
    return _HoverScale(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Color(0x4D5B7CFF), blurRadius: 18, offset: Offset(0, 10)),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                else
                  const Icon(Icons.play_arrow, color: Colors.white),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _service.createTrade(
        pair: _selectedPair,
        entryPrice: double.parse(_entryCtrl.text.trim()),
        type: _type,
      );
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});
  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

/// Dialog to add new trading pair with list of available pairs from Supabase
class _AddPairDialog extends StatefulWidget {
  const _AddPairDialog();

  @override
  State<_AddPairDialog> createState() => _AddPairDialogState();
}

class _AddPairDialogState extends State<_AddPairDialog> {
  final _searchCtrl = TextEditingController();
  final _service = TradeService();
  late Future<List<String>> _pairsFuture;
  List<String> _filteredPairs = [];
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();
    _pairsFuture = _service.getPairs();
    _searchCtrl.addListener(_filterPairs);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filterPairs() {
    final query = _searchCtrl.text.toLowerCase().trim();
    _pairsFuture.then((pairs) {
      setState(() {
        if (query.isEmpty) {
          _filteredPairs = pairs;
          _isCustom = false;
        } else {
          _filteredPairs = pairs
              .where((p) => p.toLowerCase().contains(query))
              .toList();
          // Show custom option if input doesn't match any pair
          _isCustom = _filteredPairs.isEmpty && query.isNotEmpty;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F1419),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Add Pair / Symbol',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Search or create a new trading pair',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildSearchField(),
            ),
            // Pairs list
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _pairsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B7CFF)),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 32),
                            const SizedBox(height: 12),
                            Text(
                              'Error loading pairs',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'No pairs available',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final displayPairs = _searchCtrl.text.isEmpty
                      ? snapshot.data!
                      : _filteredPairs;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: displayPairs.length + (_isCustom ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Custom pair option
                        if (_isCustom && index == displayPairs.length) {
                          return _buildCustomPairOption();
                        }

                        final pair = displayPairs[index];
                        return _buildPairTile(pair);
                      },
                    ),
                  );
                },
              ),
            ),
            // Footer with actions
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        foregroundColor: Colors.white.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
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

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: 'e.g. EUR/USD, BTC, AAPL...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _searchCtrl.clear();
                    _filterPairs();
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.white.withOpacity(0.5),
                    size: 18,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildPairTile(String pair) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, pair),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      pair.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                        pair,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pair.contains('/') ? 'Forex Pair' : 'Stock/Crypto',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomPairOption() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, _searchCtrl.text.trim().toUpperCase()),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B7CFF).withOpacity(0.2), Color(0xFF8B5CF6).withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF5B7CFF).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B7CFF), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _searchCtrl.text.trim().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Create new pair',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF5B7CFF).withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
