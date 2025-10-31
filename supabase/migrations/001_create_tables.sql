-- Create Users Table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  username TEXT UNIQUE,
  bio TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create Trades Table
CREATE TABLE IF NOT EXISTS public.trades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  side TEXT NOT NULL CHECK (side IN ('long', 'short')),
  entry_price DECIMAL(10, 2) NOT NULL,
  exit_price DECIMAL(10, 2),
  quantity DECIMAL(10, 2) NOT NULL,
  pnl DECIMAL(12, 2),
  tags TEXT[] DEFAULT ARRAY[]::TEXT[],
  notes TEXT,
  image_url TEXT,
  strategy TEXT NOT NULL,
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'closed')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  closed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT positive_quantity CHECK (quantity > 0),
  CONSTRAINT valid_prices CHECK (entry_price > 0 AND (exit_price IS NULL OR exit_price > 0))
);

-- Create Indexes for Performance
CREATE INDEX idx_trades_user_id ON public.trades(user_id);
CREATE INDEX idx_trades_created_at ON public.trades(created_at DESC);
CREATE INDEX idx_trades_status ON public.trades(status);
CREATE INDEX idx_trades_symbol ON public.trades(symbol);
CREATE INDEX idx_users_username ON public.users(username);

-- Enable Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trades ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Users Table
CREATE POLICY "Users can view their own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view public profiles" ON public.users
  FOR SELECT USING (true);

-- RLS Policies for Trades Table
CREATE POLICY "Users can view their own trades" ON public.trades
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create trades" ON public.trades
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own trades" ON public.trades
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own trades" ON public.trades
  FOR DELETE USING (auth.uid() = user_id);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_trades_updated_at BEFORE UPDATE ON public.trades
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Grant Permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON public.users TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON public.users TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.trades TO authenticated;
