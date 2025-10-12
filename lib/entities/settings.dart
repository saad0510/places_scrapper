import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'radiusInMeters': radiusInMeters,
      'apiKey': apiKey,
      'createRoutes': createRoutes,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    const defaultValues = DefautlSettings();
    return Settings(
      radiusInMeters: map['radiusInMeters'] ?? defaultValues.radiusInMeters,
      apiKey: map['apiKey'] ?? defaultValues.apiKey,
      createRoutes: defaultValues.createRoutes,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DefautlSettings extends Settings {
  const DefautlSettings()
    : super(radiusInMeters: 200, apiKey: '202d8c0a3a9d433b8a22394c4d487990', createRoutes: false);
}
