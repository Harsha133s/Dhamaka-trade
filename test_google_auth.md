# 🚀 Quick Test: Google OAuth

## ✅ What's Already Done

Your app is ready for Google OAuth! Here's what's already implemented:

1. ✅ **UI Components**
   - Google Sign-In button on login page
   - Google Sign-In button on signup page
   - Professional styling with Google logo

2. ✅ **Backend Code**
   - `signInWithGoogle()` method in `auth_service.dart`
   - Proper OAuth flow with Supabase
   - Automatic user profile creation
   - Session management

3. ✅ **Android Configuration**
   - Deep link scheme added to AndroidManifest.xml
   - Package name: `com.tradeverse.tradeverse_ai`
   - Intent filter for OAuth callback

## 🔧 What You Need To Do Now

### Step 1: Enable Google OAuth in Supabase (2 minutes)

1. Open your browser and go to:
   ```
   https://supabase.com/dashboard/project/kqnaxjjeknlymalakoyk/auth/providers
   ```

2. Find **Google** in the providers list

3. Toggle it to **Enabled**

4. Choose one option:
   - **EASY (for testing)**: Click "Use Supabase's OAuth credentials" ✅ Recommended
   - **Advanced (for production)**: Add your own Google OAuth credentials (see GOOGLE_AUTH_SETUP.md)

5. Click **Save**

### Step 2: Configure Redirect URL (1 minute)

1. In the same Supabase dashboard, go to:
   ```
   Authentication → URL Configuration
   ```

2. Add these to **Redirect URLs**:
   ```
   io.supabase.tradeverse://login-callback/
   http://localhost:*/**
   ```

3. Click **Save**

### Step 3: Test on Your Device (1 minute)

Run the app on your Android device:

```bash
flutter run -d R9ZTA0E63GZ
```

Or test on Chrome (web):

```bash
flutter run -d chrome
```

### Step 4: Try Google Sign-In

1. On the login screen, click **"Continue with Google"**
2. Browser/WebView will open
3. Select your Google account
4. Grant permissions
5. You'll be redirected back to the app
6. You should be logged in! 🎉

### Step 5: Verify It Worked

Check Supabase Dashboard → Authentication → Users

You should see a new user with:
- Email from Google
- `provider: google`
- User metadata from Google (name, avatar)

## 🐛 If Something Goes Wrong

### "OAuth flow cancelled" or "No session found"
- Make sure Google provider is **enabled** in Supabase
- Check redirect URLs are saved correctly
- Try again (sometimes first attempt needs retry)

### Browser doesn't open on mobile
- Check AndroidManifest.xml has the deep link (we just added it!)
- Make sure you're testing on a real device, not emulator without Google Play

### "Invalid OAuth configuration"
- Verify you clicked "Save" in Supabase after enabling Google
- Wait 30 seconds and try again (config propagation)

### Web: "Popup blocked"
- Allow popups for localhost in browser settings
- Or use `flutter run -d chrome --web-browser-flag "--disable-popup-blocking"`

## 🎯 Expected Behavior

### On Mobile (Android):
1. Click "Continue with Google"
2. External browser opens with Google login
3. User logs in and grants permissions
4. Browser redirects to: `io.supabase.tradeverse://login-callback/`
5. App receives the callback and completes login
6. User lands on Dashboard screen

### On Web (Chrome):
1. Click "Continue with Google"
2. New tab/popup opens with Google login
3. User logs in and grants permissions
4. Tab closes automatically
5. User lands on Dashboard screen

## 📊 Test Checklist

- [ ] Supabase Google provider enabled
- [ ] Redirect URLs configured
- [ ] App runs without build errors
- [ ] Google button appears on login page
- [ ] Clicking button opens Google login
- [ ] Can select Google account
- [ ] Redirected back to app
- [ ] Logged in successfully
- [ ] User appears in Supabase dashboard
- [ ] Can navigate to Journal and create trades

## 🚀 All Commands

```bash
# Install dependencies (if needed)
flutter pub get

# Test on Android device
flutter run -d R9ZTA0E63GZ

# Test on Chrome
flutter run -d chrome

# Test on Windows
flutter run -d windows

# Check for build errors
flutter analyze

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 📝 Package Information

- **Package Name**: `com.tradeverse.tradeverse_ai`
- **Deep Link Scheme**: `io.supabase.tradeverse`
- **OAuth Callback**: `io.supabase.tradeverse://login-callback/`
- **Supabase Project**: `kqnaxjjeknlymalakoyk`
- **Supabase URL**: `https://kqnaxjjeknlymalakoyk.supabase.co`

## ✨ After It Works

Once Google OAuth is working, you can:
1. Test with multiple Google accounts
2. Verify profile data syncs correctly
3. Test sign-out and sign-in again
4. Try on different devices
5. Add Apple/GitHub OAuth (similar process)

---

**Total setup time: ~5 minutes** ⚡

Just enable Google in Supabase dashboard and test! The code is already ready. 🎉
