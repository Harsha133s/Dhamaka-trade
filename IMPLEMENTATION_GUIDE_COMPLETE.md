# 🚀 TradeVerse AI - Complete Implementation Guide

**Comprehensive step-by-step guide to implement all missing 70% of features**

---

## 📋 EXECUTION PLAN (20-30 Hours of Development)

This guide breaks down each feature into implementable components with code patterns, Supabase queries, and Flutter widgets.

---

# **PHASE 2: COMMUNITY SYSTEM (4-6 Hours)**

## Feature: Community Feed with Posts, Comments, Likes

### Backend Schema (Already Created in Supabase)

```sql
-- Already exists in your Supabase:
- community_posts (id, user_id, content, image_url, likes_count, comments_count, created_at)
- comments (id, post_id, user_id, content, created_at)
- likes (id, post_id, user_id, created_at)
```

### Models Created ✅
- `Post` model (`lib/features/community/models/post.dart`)
- `Comment` model (same file)

### 1. Community Providers (`lib/features/community/providers/community_providers.dart`)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradeverse_ai/core/config/supabase_config.dart';
import 'package:tradeverse_ai/features/community/models/post.dart';

// Stream all posts (real-time)
final communityFeedProvider = StreamProvider<List<Post>>((ref) {
  return SupabaseConfig.client
    .from('community_posts')
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: false)
    .map((data) => data.map(Post.fromJson).toList());
});

// Create new post
final createPostProvider = FutureProvider.family<Post, Post>((ref, post) async {
  final response = await SupabaseConfig.client
    .from('community_posts')
    .insert(post.toJson())
    .select()
    .single();
  ref.invalidate(communityFeedProvider);
  return Post.fromJson(response);
});

// Like post
final likePostProvider = FutureProvider.family<void, String>((ref, postId) async {
  await SupabaseConfig.client.from('likes').insert({
    'post_id': postId,
    'user_id': SupabaseConfig.client.auth.currentUser!.id,
  });
  ref.invalidate(communityFeedProvider);
});

// Get comments for post
final postCommentsProvider = StreamProvider.family<List<Comment>, String>((ref, postId) {
  return SupabaseConfig.client
    .from('comments')
    .stream(primaryKey: ['id'])
    .eq('post_id', postId)
    .order('created_at', ascending: true)
    .map((data) => data.map(Comment.fromJson).toList());
});

// Add comment
final addCommentProvider = FutureProvider.family<Comment, (String, String)>((ref, args) async {
  final (postId, content) = args;
  final response = await SupabaseConfig.client
    .from('comments')
    .insert({
      'post_id': postId,
      'user_id': SupabaseConfig.client.auth.currentUser!.id,
      'content': content,
    })
    .select()
    .single();
  ref.invalidate(postCommentsProvider(postId));
  return Comment.fromJson(response);
});
```

### 2. Community Screen (`lib/features/community/screens/community_screen.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(communityFeedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Community Feed')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => CreatePostDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      body: feedAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Text('No posts yet. Be the first!'),
            );
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(
              post: posts[index],
              onLike: () => ref.read(likePostProvider(posts[index].id).future),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

---

# **PHASE 3: ADVANCED FEATURES (6-8 Hours)**

## Feature 1: Challenges & Leaderboard

### Models (`lib/features/challenges/models/challenge.dart`)

```dart
class Challenge {
  final String id;
  final String name;
  final String description;
  final String goalType; // 'win_rate', 'total_pnl', 'trades_count'
  final int goalValue;
  final String rewardBadge;
  final int rewardXp;
  final DateTime createdAt;

  const Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.goalType,
    required this.goalValue,
    required this.rewardBadge,
    required this.rewardXp,
    required this.createdAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    goalType: json['goal_type'] as String,
    goalValue: json['goal_value'] as int,
    rewardBadge: json['reward_badge'] as String,
    rewardXp: json['reward_xp'] as int? ?? 0,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

class UserChallenge {
  final String id;
  final String userId;
  final String challengeId;
  final String status; // 'active', 'completed', 'failed'
  final int progress;
  final DateTime startedAt;
  final DateTime? completedAt;

  const UserChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.status,
    required this.progress,
    required this.startedAt,
    this.completedAt,
  });

  factory UserChallenge.fromJson(Map<String, dynamic> json) => UserChallenge(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    challengeId: json['challenge_id'] as String,
    status: json['status'] as String,
    progress: json['progress'] as int? ?? 0,
    startedAt: DateTime.parse(json['started_at'] as String),
    completedAt: json['completed_at'] != null 
      ? DateTime.parse(json['completed_at'] as String)
      : null,
  );
}
```

### Providers (`lib/features/challenges/providers/challenges_providers.dart`)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Get all challenges
final allChallengesProvider = FutureProvider<List<Challenge>>((ref) async {
  final response = await SupabaseConfig.client
    .from('challenges')
    .select();
  return (response as List).map(Challenge.fromJson).toList();
});

// Get user challenges
final userChallengesProvider = FutureProvider<List<UserChallenge>>((ref) async {
  final userId = SupabaseConfig.client.auth.currentUser!.id;
  final response = await SupabaseConfig.client
    .from('user_challenges')
    .select()
    .eq('user_id', userId);
  return (response as List).map(UserChallenge.fromJson).toList();
});

// Join challenge
final joinChallengeProvider = FutureProvider.family<void, String>((ref, challengeId) async {
  await SupabaseConfig.client.from('user_challenges').insert({
    'user_id': SupabaseConfig.client.auth.currentUser!.id,
    'challenge_id': challengeId,
    'status': 'active',
    'progress': 0,
    'started_at': DateTime.now().toIso8601String(),
  });
  ref.invalidate(userChallengesProvider);
});

// Get leaderboard
final leaderboardProvider = FutureProvider.family<List<dynamic>, String>((ref, challengeId) async {
  final response = await SupabaseConfig.client
    .from('user_challenges')
    .select('user_id, users(display_name, avatar_url), progress')
    .eq('challenge_id', challengeId)
    .eq('status', 'active')
    .order('progress', ascending: false)
    .limit(100);
  return response as List;
});
```

## Feature 2: Inbox & Notifications

### Models (`lib/features/inbox/models/notification.dart`)

```dart
class AppNotification {
  final String id;
  final String userId;
  final String type; // 'follow', 'like', 'comment', 'challenge_reward'
  final String title;
  final String message;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    this.data,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    isRead: json['is_read'] as bool? ?? false,
    data: json['data'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
```

### Providers (`lib/features/inbox/providers/inbox_providers.dart`)

```dart
// Get all notifications (real-time)
final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final userId = SupabaseConfig.client.auth.currentUser!.id;
  return SupabaseConfig.client
    .from('notifications')
    .stream(primaryKey: ['id'])
    .eq('user_id', userId)
    .order('created_at', ascending: false)
    .map((data) => data.map(AppNotification.fromJson).toList());
});

// Mark notification as read
final markNotificationReadProvider = FutureProvider.family<void, String>((ref, notifId) async {
  await SupabaseConfig.client
    .from('notifications')
    .update({'is_read': true})
    .eq('id', notifId);
  ref.invalidate(notificationsProvider);
});

// Get unread count
final unreadCountProvider = FutureProvider<int>((ref) async {
  final userId = SupabaseConfig.client.auth.currentUser!.id;
  final response = await SupabaseConfig.client
    .from('notifications')
    .select()
    .eq('user_id', userId)
    .eq('is_read', false);
  return (response as List).length;
});
```

## Feature 3: Calendar with Heatmap

### Models (`lib/features/calendar/models/calendar_event.dart`)

```dart
class CalendarEvent {
  final DateTime date;
  final double pnl;
  final int tradesCount;
  final bool isProfitable;

  const CalendarEvent({
    required this.date,
    required this.pnl,
    required this.tradesCount,
    required this.isProfitable,
  });
}
```

### Providers (`lib/features/calendar/providers/calendar_providers.dart`)

```dart
// Get calendar data for month
final monthCalendarProvider = FutureProvider.family<List<CalendarEvent>, DateTime>((ref, date) async {
  final userId = SupabaseConfig.client.auth.currentUser!.id;
  final monthStart = DateTime(date.year, date.month, 1);
  final monthEnd = DateTime(date.year, date.month + 1, 0);

  final response = await SupabaseConfig.client
    .from('trades')
    .select()
    .eq('user_id', userId)
    .eq('status', 'closed')
    .gte('closed_at', monthStart.toIso8601String())
    .lte('closed_at', monthEnd.toIso8601String());

  // Aggregate by date
  final Map<String, CalendarEvent> events = {};
  for (var trade in response) {
    final date = DateTime.parse(trade['closed_at'] as String);
    final dateKey = '${date.year}-${date.month}-${date.day}';
    
    if (events.containsKey(dateKey)) {
      final existing = events[dateKey]!;
      events[dateKey] = CalendarEvent(
        date: date,
        pnl: existing.pnl + (trade['pnl'] as num? ?? 0).toDouble(),
        tradesCount: existing.tradesCount + 1,
        isProfitable: (existing.pnl + (trade['pnl'] as num? ?? 0).toDouble()) > 0,
      );
    } else {
      events[dateKey] = CalendarEvent(
        date: date,
        pnl: (trade['pnl'] as num? ?? 0).toDouble(),
        tradesCount: 1,
        isProfitable: (trade['pnl'] as num? ?? 0) > 0,
      );
    }
  }

  return events.values.toList();
});
```

---

# **PHASE 4: AI INTEGRATION (4-6 Hours)**

## Supabase Edge Functions to Deploy

### 1. Extract Trade (`/functions/extract_trade/index.ts`)

```typescript
import { serve } from "https://deno.land/std@0.131.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const supabaseUrl = Deno.env.get("SUPABASE_URL")
const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
const supabase = createClient(supabaseUrl, supabaseKey)

serve(async (req) => {
  const { notes } = await req.json()
  
  // Call Perplexity API or use simple parsing
  const prompt = `Extract trading data from this note: "${notes}". 
    Return JSON: {symbol, side (long/short), entry_price, exit_price, quantity, strategy}`
  
  // For now, return placeholder - integrate Perplexity API
  return new Response(
    JSON.stringify({
      symbol: "AAPL",
      side: "long",
      entry_price: 150.0,
      exit_price: 155.5,
      quantity: 10,
      strategy: "scalp"
    }),
    { headers: { "Content-Type": "application/json" } }
  )
})
```

### 2. Generate Insights (`/functions/generate_insights/index.ts`)

```typescript
serve(async (req) => {
  const { trade_id } = await req.json()
  
  // Fetch trade from Supabase
  const { data: trade } = await supabase
    .from("trades")
    .select()
    .eq("id", trade_id)
    .single()

  // Generate insight using AI
  const insight = {
    trade_id: trade_id,
    content: `Great ${trade.side} trade on ${trade.symbol}! Entry at ${trade.entry_price}, exit at ${trade.exit_price}.`,
    confidence: 0.85,
    created_at: new Date().toISOString()
  }

  // Store in database
  await supabase.from("ai_insights").insert(insight)

  return new Response(JSON.stringify(insight), {
    headers: { "Content-Type": "application/json" }
  })
})
```

### 3. Recommend Traders (`/functions/recommend_traders/index.ts`)

```typescript
serve(async (req) => {
  const { user_id } = await req.json()

  // Get user stats
  const { data: userStats } = await supabase
    .rpc("get_user_stats", { p_user_id: user_id })

  // Find similar traders
  const { data: similarTraders } = await supabase
    .from("users")
    .select("id, display_name, avatar_url, win_rate, total_pnl")
    .neq("id", user_id)
    .order("win_rate", { ascending: false })
    .limit(10)

  return new Response(JSON.stringify(similarTraders), {
    headers: { "Content-Type": "application/json" }
  })
})
```

---

# **PHASE 5: GOOGLE DRIVE BACKUP (2-3 Hours)**

## Integration Steps

### 1. Add Dependencies

```yaml
google_sign_in: ^6.0.0
googleapis: ^12.0.0
file_picker: ^5.0.0
```

### 2. Google Drive Service (`lib/core/services/google_drive_service.dart`)

```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  // Authenticate
  Future<void> authenticate() async {
    await _googleSignIn.signIn();
  }

  // Upload backup
  Future<String> uploadBackup(String fileName, List<int> fileBytes) async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw Exception('Not authenticated');

    final authClient = await account.authHeaders;
    final httpClient = _make_authenticated_request(authClient);
    final driveApi = drive.DriveApi(httpClient);

    // Create or get backup folder
    final folderId = await _getOrCreateFolder(driveApi, 'TradeVerse Backups');

    // Upload file
    final file = drive.File()
      ..name = fileName
      ..parents = [folderId];

    final media = drive.Media(Stream.fromIterable([fileBytes]), fileBytes.length);
    final response = await driveApi.files.create(file, uploadMedia: media);

    return response.id!;
  }

  // Download backup
  Future<List<int>> downloadBackup(String fileId) async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw Exception('Not authenticated');

    final authClient = await account.authHeaders;
    final httpClient = _make_authenticated_request(authClient);
    final driveApi = drive.DriveApi(httpClient);

    final media = await driveApi.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia);
    return (media as drive.Media).stream.toList();
  }

  Future<String> _getOrCreateFolder(drive.DriveApi api, String folderName) async {
    // Implementation to find or create folder
    // Return folder ID
  }
}
```

### 3. Backup Provider (`lib/core/services/backup_service.dart`)

```dart
class BackupService {
  final GoogleDriveService _driveService;

  // Export trades as JSON
  Future<String> exportTrades() async {
    final trades = await SupabaseConfig.client
      .from('trades')
      .select();
    
    return jsonEncode({
      'backup_date': DateTime.now().toIso8601String(),
      'trades': trades,
    });
  }

  // Backup to Drive
  Future<void> backupToDrive() async {
    final jsonData = await exportTrades();
    final bytes = utf8.encode(jsonData);
    final fileName = 'trades_backup_${DateTime.now().toIso8601String()}.json';

    await _driveService.uploadBackup(fileName, bytes);
  }

  // Restore from Drive
  Future<void> restoreFromDrive(String fileId) async {
    final bytes = await _driveService.downloadBackup(fileId);
    final jsonData = utf8.decode(bytes);
    final data = jsonDecode(jsonData);

    // Import trades
    for (var trade in data['trades']) {
      await SupabaseConfig.client
        .from('trades')
        .insert(trade);
    }
  }
}
```

---

# **PHASE 6: REMAINING PAGES & POLISH (3-4 Hours)**

## Missing Pages to Create

1. **Today Screen** (`lib/features/today/screens/today_screen.dart`)
   - Show trades for today
   - Daily stats and summary
   - AI daily suggestion

2. **Discover Screen** (`lib/features/discover/screens/discover_screen.dart`)
   - AI trader recommendations
   - Browse community traders
   - Follow system

3. **Profile Screen** (`lib/features/profile/screens/profile_screen.dart`)
   - View user profile (public/private)
   - User stats and achievements
   - Follower/following lists

4. **Settings Screen** (`lib/features/settings/screens/settings_screen.dart`)
   - Account settings
   - Notification preferences
   - Theme selection
   - Backup settings

5. **Update Router** (`lib/core/config/router.dart`)
   - Add new routes for all pages

---

# **QUICK IMPLEMENTATION SUMMARY**

| Phase | Components | Est. Time | Status |
|-------|-----------|-----------|--------|
| **Phase 2** | Community posts, comments, likes | 4-6 hrs | ⏳ Ready to build |
| **Phase 3** | Challenges, inbox, calendar | 6-8 hrs | ⏳ Ready to build |
| **Phase 4** | Edge Functions, AI features | 4-6 hrs | ⏳ Ready to deploy |
| **Phase 5** | Google Drive backup | 2-3 hrs | ⏳ Ready to build |
| **Phase 6** | Remaining pages, polish | 3-4 hrs | ⏳ Ready to build |

**Total: 20-30 hours to complete all features**

---

# **NEXT STEPS**

1. ✅ Models created (`Post`, `Comment`, `Challenge`, `UserChallenge`, `AppNotification`, `CalendarEvent`)
2. ⏳ Create providers for each feature
3. ⏳ Build screens and widgets
4. ⏳ Deploy Edge Functions to Supabase
5. ⏳ Integrate Google Drive
6. ⏳ Update router with new routes
7. ⏳ Test all features
8. ⏳ Deploy to production

---

**Ready to start building? Use this guide to implement each phase!** 🚀
