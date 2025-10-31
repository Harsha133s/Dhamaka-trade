# 🚀 TradeVerse AI - Flutter App

AI-powered trading journal with community features and real-time analytics.

## 📋 Project Structure

```
lib/
├── core/
│   ├── config/      # Supabase, routing, env
│   ├── theme/       # Material 3 themes
│   ├── constants/   # App strings, colors
│   ├── utils/       # Helpers, formatters
│   ├── services/    # API, Supabase services
│   └── widgets/     # Shared components
│
├── features/
│   ├── auth/        # Authentication (sign up/in)
│   ├── dashboard/   # Main dashboard
│   ├── journal/     # Trade logging
│   ├── analytics/   # Trading metrics
│   ├── community/   # Social feed (Phase 2)
│   ├── insights/    # AI insights (Phase 2)
│   ├── discover/    # Discover traders (Phase 2)
│   ├── smart_switch/# Trading modes (Phase 3)
│   ├── calendar/    # Trade calendar (Phase 3)
│   └── settings/    # User settings (Phase 3)
│
├── presentation/
│   └── app_shell.dart  # Main app wrapper + nav
│
└── main.dart        # App entry point
```

## 🔧 Setup Instructions

### 1. Environment Variables

Create `.env` file in project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
PERPLEXITY_API_KEY=ppl_your_api_key
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## 📊 Current Phase

**Phase 1A: Foundation** ✅
- [x] Flutter project structure
- [x] Supabase integration
- [x] Material 3 themes (dark/light)
- [x] Authentication screens
- [x] Navigation shell with bottom nav
- [x] Dashboard, Journal, Analytics placeholders

**Next:** Phase 1B - Journal + Trade Entry + AI Extraction

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run lint analysis
flutter analyze

# Run with coverage
flutter test --coverage
```

## 📚 Architecture

- **State Management:** Riverpod (providers + state notifiers)
- **Routing:** Go Router (declarative navigation)
- **Backend:** Supabase (PostgreSQL + Auth + Realtime)
- **AI:** Perplexity API (via Edge Functions)
- **UI:** Material 3 + Flutter built-ins

## 🔐 Security Notes

- Never commit `.env` file
- Supabase RLS policies enforce row-level security
- Auth tokens stored securely via Supabase
- Always use `supabase_flutter` for secure operations
