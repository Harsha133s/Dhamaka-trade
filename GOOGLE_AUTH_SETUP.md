# Google OAuth Setup Guide for TradeVerse AI

## ✅ Current Status
Your app already has the Google Sign-In button UI and the `signInWithGoogle()` method implemented in `auth_service.dart`. Now you need to configure it in Supabase.

## 🔧 Step 1: Enable Google Provider in Supabase

1. Go to your Supabase Dashboard: https://supabase.com/dashboard/project/kqnaxjjeknlymalakoyk
2. Navigate to **Authentication** → **Providers**
3. Find **Google** in the provider list
4. Toggle it to **Enabled**

## 🔑 Step 2: Get Google OAuth Credentials

### Option A: Use Supabase's Google OAuth (Easiest - Recommended for Testing)

Supabase provides a default Google OAuth configuration for development:

1. In the Google provider settings, you'll see a section "Use Supabase's OAuth Credentials"
2. Click **"Use Supabase Credentials"** - this allows you to test without setting up your own Google OAuth app
3. Save the settings

**Note:** This is perfect for development but has limitations. For production, use Option B.

### Option B: Create Your Own Google OAuth App (Production)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **Google+ API**
4. Go to **Credentials** → **Create Credentials** → **OAuth Client ID**
5. Configure OAuth consent screen:
   - User Type: External
   - App name: TradeVerse AI
   - User support email: your email
   - Developer contact: your email
   - Add scopes: `email`, `profile`, `openid`
6. Create OAuth Client ID:
   - Application type: **Web application**
   - Name: TradeVerse AI Web
   - Authorized JavaScript origins:
     - `http://localhost` (for testing)
     - `https://kqnaxjjeknlymalakoyk.supabase.co`
   - Authorized redirect URIs:
     - `https://kqnaxjjeknlymalakoyk.supabase.co/auth/v1/callback`
7. Copy **Client ID** and **Client Secret**
8. Paste them in Supabase → Authentication → Providers → Google

### Option C: For Mobile Apps (Android/iOS)

For Android:
1. In Google Cloud Console, create another OAuth Client ID
2. Application type: **Android**
3. Package name: `com.tradeverse.ai` (or your package name)
4. Get SHA-1 certificate fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Add SHA-1 to Google OAuth Client

For iOS:
1. Create OAuth Client ID with type **iOS**
2. Bundle ID: `com.tradeverse.ai` (or your bundle ID)
3. Add to your iOS app configuration

## 🔄 Step 3: Configure Redirect URLs

In Supabase Dashboard → Authentication → URL Configuration:

Add these redirect URLs:
- **Site URL**: `https://kqnaxjjeknlymalakoyk.supabase.co`
- **Redirect URLs**:
  - `http://localhost:3000/**` (for web testing)
  - `io.supabase.tradeverse://login-callback/` (for mobile)
  - `com.tradeverse.ai://login-callback/` (alternative mobile)

## 📱 Step 4: Update Android Configuration (if building for Android)

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
  <application ...>
    <activity ...>
      <!-- Add this inside <activity> -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
          android:scheme="io.supabase.tradeverse"
          android:host="login-callback" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

## 🍎 Step 5: Update iOS Configuration (if building for iOS)

Edit `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.supabase.tradeverse</string>
    </array>
  </dict>
</array>
```

## 🌐 Step 6: Web Configuration (Optional)

For web builds, no additional configuration needed! The OAuth flow will work automatically.

## ✅ Step 7: Test Google Sign-In

1. Run your app:
   ```bash
   flutter run
   ```

2. Click **"Continue with Google"** button

3. Expected flow:
   - Opens browser with Google OAuth consent screen
   - User selects Google account
   - User grants permissions
   - Redirects back to app
   - User is signed in
   - User profile created in database

4. Check Supabase Dashboard → Authentication → Users to verify user was created

## 🐛 Troubleshooting

### Error: "OAuth flow failed"
- Make sure Google provider is enabled in Supabase
- Check redirect URLs are configured correctly
- Verify OAuth client credentials are valid

### Error: "Invalid redirect URI"
- Ensure redirect URL matches exactly in Google Cloud Console
- Format: `https://kqnaxjjeknlymalakoyk.supabase.co/auth/v1/callback`

### Error: "App not verified"
- This is normal during development
- Click "Advanced" → "Go to TradeVerse AI (unsafe)" for testing
- For production, complete Google's verification process

### Mobile: "Browser not opening"
- Check AndroidManifest.xml or Info.plist has correct intent filters
- Verify deep link scheme matches in auth_service.dart

### Web: CORS errors
- Add your localhost origin to Supabase allowed origins
- Check browser console for specific CORS errors

## 🎯 Quick Test Commands

```bash
# Test on Chrome (Web)
flutter run -d chrome

# Test on Android device
flutter run -d R9ZTA0E63GZ

# Test on Windows desktop
flutter run -d windows
```

## 📊 Verification Checklist

- [ ] Google provider enabled in Supabase
- [ ] OAuth credentials configured (Supabase's or your own)
- [ ] Redirect URLs added to Supabase
- [ ] Mobile deep links configured (if using mobile)
- [ ] Tested sign-in flow
- [ ] User created in Supabase users table
- [ ] Session persists after restart

## 🚀 What's Already Implemented

Your code already has:
- ✅ Google sign-in button UI in login_screen.dart
- ✅ Google sign-in button UI in signup_screen.dart
- ✅ `signInWithGoogle()` method in auth_service.dart
- ✅ Proper error handling
- ✅ User profile creation on first login
- ✅ Session management with Riverpod

All you need to do is configure the Supabase dashboard!

## 📝 Next Steps After Setup

Once Google OAuth is working:
1. Test on multiple devices
2. Add error handling for edge cases
3. Implement Google Sign-Out
4. Add profile photo from Google account
5. Consider adding more OAuth providers (Apple, GitHub, etc.)

---

**After completing these steps, your Google Authentication will be fully functional!** 🎉
