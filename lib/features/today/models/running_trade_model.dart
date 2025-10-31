/// Running trade model and enums
import 'package:intl/intl.dart';

enum TradeType { buy, sell }

enum TradeStatus { running, closed }

class RunningTrade {
  final String id;
  final String userId;
  final String pair;
  final double entryPrice;
  final double? exitPrice;
  final TradeType type;
  final TradeStatus status;
  final DateTime entryTime;
  final DateTime? exitTime;
  final double? result;
  final String? notes;
  final String? imageUrl;
  final String? audioUrl;

  const RunningTrade({
    required this.id,
    required this.userId,
    required this.pair,
    required this.entryPrice,
    this.exitPrice,
    required this.type,
    required this.status,
    required this.entryTime,
    this.exitTime,
    this.result,
    this.notes,
    this.imageUrl,
    this.audioUrl,
  });

  bool get isRunning => status == TradeStatus.running;
  bool get isClosed => status == TradeStatus.closed;
  bool get isProfitable => (result ?? 0) > 0;
  bool get isLoss => (result ?? 0) < 0;

  bool get hasNotes => (notes != null && notes!.trim().isNotEmpty);
  bool get hasImage => (imageUrl != null && imageUrl!.isNotEmpty);
  bool get hasAudio => (audioUrl != null && audioUrl!.isNotEmpty);

  String get formattedResult {
    final r = (result ?? 0).toDouble();
    final sign = r > 0 ? '+' : r < 0 ? '-' : '';
    return '$sign\$${r.abs().toStringAsFixed(2)}';
  }

  String get typeDisplayName => type == TradeType.buy ? 'BUY / LONG' : 'SELL / SHORT';

  String get formattedDuration {
    final end = exitTime ?? DateTime.now();
    final diff = end.difference(entryTime);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  factory RunningTrade.fromJson(Map<String, dynamic> json) {
    return RunningTrade(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      pair: json['pair'] as String,
      entryPrice: (json['entry_price'] as num).toDouble(),
      exitPrice: (json['exit_price'] as num?)?.toDouble(),
      type: ((json['type'] as String).toLowerCase() == 'buy') ? TradeType.buy : TradeType.sell,
      status: ((json['status'] as String).toLowerCase() == 'closed') ? TradeStatus.closed : TradeStatus.running,
      entryTime: DateTime.parse((json['entry_time'] ?? json['created_at']) as String),
      exitTime: json['exit_time'] != null 
          ? DateTime.parse(json['exit_time'] as String)
          : (json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null),
      result: (json['result'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'pair': pair,
        'entry_price': entryPrice,
        if (exitPrice != null) 'exit_price': exitPrice,
        'type': type.name,
        'status': status == TradeStatus.closed ? 'closed' : 'running',
        'entry_time': entryTime.toIso8601String(),
        if (exitTime != null) 'exit_time': exitTime!.toIso8601String(),
        if (result != null) 'result': result,
        if (notes != null) 'notes': notes,
        if (imageUrl != null) 'image_url': imageUrl,
        if (audioUrl != null) 'audio_url': audioUrl,
      };
}