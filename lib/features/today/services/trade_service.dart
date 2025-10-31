/// Trade service for Supabase integration and daily stats + AI summary
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/running_trade_model.dart';

class TradeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<RunningTrade>> getRunningTrades() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('trades')
        .select()
        .eq('user_id', userId)
        .eq('status', 'running')
        .order('created_at', ascending: false);

    return (response as List)
        .map((j) => RunningTrade.fromJson(j))
        .toList();
  }

  Future<List<RunningTrade>> getClosedTrades({int limit = 50}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('trades')
        .select()
        .eq('user_id', userId)
        .eq('status', 'closed')
        .order('exit_time', ascending: false)
        .limit(limit);

    return (response as List)
        .map((j) => RunningTrade.fromJson(j))
        .toList();
  }

  Future<RunningTrade> createTrade({
    required String pair,
    required double entryPrice,
    required TradeType type,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final tradeData = {
      'user_id': userId,
      'pair': pair,
      'entry_price': entryPrice,
      'type': type.name,
      'status': 'running',
      // rely on created_at default timestamp in DB
    };

    final response = await _supabase
        .from('trades')
        .insert(tradeData)
        .select()
        .single();

    return RunningTrade.fromJson(response);
  }

  Future<RunningTrade> closeTrade({
    required String tradeId,
    required double exitPrice,
    required double result,
    File? imageFile,
    File? audioFile,
    String? notes,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    String? imageUrl;
    String? audioUrl;

    if (imageFile != null) {
      imageUrl = await _upload('trade-images', userId, tradeId, imageFile);
    }
    if (audioFile != null) {
      audioUrl = await _upload('trade-audio', userId, tradeId, audioFile);
    }

    final updateData = {
      'status': 'closed',
      'exit_price': exitPrice,
      'result': result,
      'exit_time': DateTime.now().toIso8601String(),
      if (imageUrl != null) 'image_url': imageUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (notes != null) 'notes': notes,
    };

    final response = await _supabase
        .from('trades')
        .update(updateData)
        .eq('id', tradeId)
        .eq('user_id', userId)
        .select()
        .single();

    return RunningTrade.fromJson(response);
  }

  Future<String> _upload(String bucket, String userId, String tradeId, File file) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final path = '$userId/$tradeId-$ts${file.path.split('.').last}';
    await _supabase.storage.from(bucket).upload(path, file);
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  Future<Map<String, dynamic>> getTodayStats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final response = await _supabase
        .from('trades')
        .select()
        .eq('user_id', userId)
        .gte('created_at', startOfDay.toIso8601String());

    final trades = (response as List)
        .map((e) => RunningTrade.fromJson(e as Map<String, dynamic>))
        .toList();
    final closed = trades.where((t) => t.isClosed).toList();
    final running = trades.where((t) => t.isRunning).toList();

    final totalPnL = closed.fold<double>(0, (s, t) => s + (t.result ?? 0));
    final winning = closed.where((t) => (t.result ?? 0) > 0).length;
    final winRate = closed.isEmpty ? 0.0 : (winning / closed.length) * 100;

    return {
      'total_trades': trades.length,
      'running_trades': running.length,
      'closed_trades': closed.length,
      'total_pnl': totalPnL,
      'win_rate': winRate,
    };
  }

  Future<List<RunningTrade>> getTradesForToday({int limit = 50}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).toIso8601String();

    final response = await _supabase
        .from('trades')
        .select()
        .eq('user_id', userId)
        .eq('status', 'closed')
        .gte('created_at', start)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((e) => RunningTrade.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Pair management
  Future<List<String>> getPairs() async {
    final response = await _supabase
        .from('trade_pairs')
        .select('symbol')
        .order('symbol');
    return (response as List).map((e) => (e['symbol'] as String)).toList();
  }

  Future<void> addPair(String symbol, {String? category}) async {
    await _supabase
        .from('trade_pairs')
        .insert({'symbol': symbol, if (category != null) 'category': category})
        .select()
        .maybeSingle();
  }

  // Simple heuristic AI summary
  Future<String> getAiSummary() async {
    final stats = await getTodayStats();
    final pnl = (stats['total_pnl'] as num).toDouble();
    final wr = (stats['win_rate'] as num).toDouble();
    final trades = stats['total_trades'] as int;
    final parts = <String>[];
    parts.add(pnl > 0 ? 'Profitable day +' : pnl < 0 ? 'Losing day ' : 'Breakeven day ');
    parts.add('\$${pnl.toStringAsFixed(2)}');
    parts.add(' • Win rate ${wr.toStringAsFixed(0)}%');
    parts.add(' • Trades $trades');
    return parts.join('');
  }
}