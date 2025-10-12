part of 'index.dart';

extension _ExpandLatLng on List<LatLng> {
  List<List<double>> expandLatLng() {
    return [
      for (final p in this) [p.latitude, p.longitude],
    ];
  }
}

extension _DecodeLatLng on List<List<double>> {
  List<LatLng> decodeLatLng() {
    return [for (final p in this) LatLng(p[0], p[1])];
  }
}

JsMap _closedPolygon(JsCoords points) {
  if (points.length <= 2) return Turf.instance.polygon(points);
  final closed = points.first[0] == points.last[0] && points.first[1] == points.last[1];
  if (!closed) points.add(points.first);
  return Turf.instance.polygon(points);
}

JsMap _iterateInFeatures(JsMap collection, JsMap? Function(JsMap feature) visit) {
  final features = <JsMap>[];
  for (final feature in collection['features']) {
    final newFeature = visit(Map.from(feature));
    if (newFeature != null) features.add(newFeature);
  }
  return {'features': features};
}
