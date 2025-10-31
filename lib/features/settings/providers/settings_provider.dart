import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings state class
class SettingsState {
  final bool darkMode;
  final bool notifications;
  final bool soundEnabled;

  const SettingsState({
    required this.darkMode,
    required this.notifications,
    required this.soundEnabled,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? notifications,
    bool? soundEnabled,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

/// Settings notifier to manage settings state and persistence
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(const SettingsState(
          darkMode: true,
          notifications: true,
          soundEnabled: true,
        )) {
    _loadSettings();
  }

  static const String _darkModeKey = 'dark_mode';
  static const String _notificationsKey = 'notifications';
  static const String _soundKey = 'sound_enabled';

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      darkMode: prefs.getBool(_darkModeKey) ?? true,
      notifications: prefs.getBool(_notificationsKey) ?? true,
      soundEnabled: prefs.getBool(_soundKey) ?? true,
    );
  }

  /// Toggle dark mode
  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    state = state.copyWith(darkMode: value);
  }

  /// Toggle notifications
  Future<void> setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
    state = state.copyWith(notifications: value);
  }

  /// Toggle sound
  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);
    state = state.copyWith(soundEnabled: value);
  }
}

/// Provider for settings state
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
