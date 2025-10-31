## 🗄️ Supabase Setup Guide for TradeVerse AI

### Step 1: Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Click **New Project**
3. Enter project name: `tradeverse-ai`
4. Choose a region close to you
5. Set a strong database password
6. Click **Create new project**

### Step 2: Get API Keys

1. Go to **Settings** → **API**
2. Copy **Project URL** → Add to `.env` as `SUPABASE_URL`
3. Copy **anon public** key → Add to `.env` as `SUPABASE_ANON_KEY`

Your `.env` should look like:
```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
PERPLEXITY_API_KEY=ppl_your_api_key
```

### Step 3: Apply Database Migrations

#### Option A: Using Supabase Web Console (Recommended for beginners)

1. Go to **SQL Editor** in your Supabase dashboard
2. Click **New Query**
3. Copy the contents of `supabase/migrations/001_create_tables.sql`
4. Paste into the SQL editor
5. Click **Run**
6. You should see "0 rows" indicating success

#### Option B: Using Supabase CLI (Advanced)

```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase link --project-ref xxxxx

# Apply migrations
supabase db push
```

### Step 4: Verify Tables Were Created

In Supabase dashboard, go to **Table Editor** and verify:
- ✅ `users` table exists
- ✅ `trades` table exists
- ✅ Both have RLS policies enabled

### Step 5: Test Authentication

1. Run the Flutter app:
   ```bash
   flutter run
   ```
2. Try signing up with an email/password
3. Check Supabase **Auth** → **Users** to see your user created

### Step 6: Test Trade Creation

1. After login, tap the **+** button on Journal screen
2. Fill in trade details:
   - Symbol: `AAPL`
   - Side: `LONG`
   - Entry Price: `150.00`
   - Quantity: `10`
   - Strategy: `Scalp`
3. Click **Create Trade**
4. Go to Supabase **Table Editor** → **trades** and verify the trade appears

---

## 🔧 Database Schema

### Users Table
Extends Supabase's built-in `auth.users` table:
- `id` - UUID (primary key, references auth.users)
- `email` - User's email
- `display_name` - Public display name
- `username` - Unique username
- `bio` - User bio
- `avatar_url` - Avatar image URL
- `created_at` / `updated_at` - Timestamps

### Trades Table
- `id` - UUID (auto-generated)
- `user_id` - Reference to user
- `symbol` - Stock symbol (e.g., AAPL)
- `side` - "long" or "short"
- `entry_price` - Trade entry price
- `exit_price` - Trade exit price (nullable for open trades)
- `quantity` - Position size
- `pnl` - Profit/Loss (auto-calculated)
- `tags` - Array of tags for categorization
- `notes` - Trade notes
- `strategy` - Strategy type (scalp/swing/position/news)
- `status` - "open" or "closed"
- `created_at` / `closed_at` / `updated_at` - Timestamps

---

## 🔐 Security (RLS Policies)

All tables have **Row Level Security** enabled:

- **Users**: Each user can view their own profile and update it. Other profiles are publicly readable.
- **Trades**: Users can only view, create, update, and delete their own trades.

This is enforced at the database level for maximum security.

---

## 📝 Next Steps

After Supabase is set up:

1. **Phase 1B continuation**: Test the journal with real data
2. **Phase 2**: Add analytics dashboard with charts
3. **Phase 3**: Implement AI extraction using Perplexity API
4. **Phase 4**: Add community features

---

## 🆘 Troubleshooting

### "Cannot INSERT into trades" error
- ✅ Check RLS is enabled
- ✅ Verify user is authenticated
- ✅ Check `.env` credentials are correct

### "User not found" error
- ✅ Sign up first through the app
- ✅ Check Supabase Auth users list

### "No trades showing" error
- ✅ Create at least one trade
- ✅ Check browser console for errors
- ✅ Verify user_id matches in database

---

**Once Supabase is configured, the app is fully functional for Phase 1B!** 🎉
