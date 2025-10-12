import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/entities/settings.dart';

class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() {
    _load();
    listenSelf((_, x) => _save(x));
    return const DefautlSettings();
  }

  void enableRoutesCreation() {
    state = state.copyWith(createRoutes: true);
  }

  void disableRoutesCreation() {
    state = state.copyWith(createRoutes: false);
  }

  void setRadius(double radius) {
    if (radius <= 0) return;
    state = state.copyWith(radiusInMeters: radius);
  }

  void setApiKey(String apiKey) {
    apiKey = apiKey.trim();
    if (apiKey.isEmpty) return;
    state = state.copyWith(apiKey: apiKey);
  }

  void toggleShowSettings() {
    state = state.copyWith(showSettings: !state.showSettings);
  }

  // local storage

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('settings');
    if (data == null) return;
    state = Settings.fromJson(data);
  }

  void _save(Settings x) async {
    if (x is DefautlSettings) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', x.toJson());
  }
}

final settingsNotifier = NotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);
