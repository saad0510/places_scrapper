import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/entities/settings.dart';

class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() => Settings(
    radiusInMeters: 200,
    apiKey: '202d8c0a3a9d433b8a22394c4d487990',
    createRoutes: false,
  );

  void enableRoutesCreation() {
    state = state.copyWith(shouldCreateRoutes: true);
  }

  void disableRoutesCreation() {
    state = state.copyWith(shouldCreateRoutes: false);
  }
}

final settingsNotifier = NotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);
