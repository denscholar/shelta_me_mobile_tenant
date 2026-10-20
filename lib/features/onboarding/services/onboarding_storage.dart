import 'package:shared_preferences/shared_preferences.dart';

abstract final class OnboardingStorage {
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';

  static final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  static Future<bool> hasSeenOnboarding() async {
    final hasSeenOnboarding = await _preferences.getBool(_hasSeenOnboardingKey);

    return hasSeenOnboarding ?? false;
  }

  static Future<void> markAsSeen() async {
    await _preferences.setBool(_hasSeenOnboardingKey, true);
  }

  static Future<void> reset() async {
    await _preferences.remove(_hasSeenOnboardingKey);
  }
}
