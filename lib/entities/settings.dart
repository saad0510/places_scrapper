class Settings {
  final double radiusInMeters;
  final String apiKey;
  final bool createRoutes;

  const Settings({required this.radiusInMeters, required this.apiKey, required this.createRoutes});

  Settings copyWith({double? radiusInMeters, String? apiKey, bool? shouldCreateRoutes}) {
    return Settings(
      radiusInMeters: radiusInMeters ?? this.radiusInMeters,
      apiKey: apiKey ?? this.apiKey,
      createRoutes: shouldCreateRoutes ?? createRoutes,
    );
  }
}
