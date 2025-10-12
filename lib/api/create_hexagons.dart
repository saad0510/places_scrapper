part of 'index.dart';

Map<String, dynamic> createHexagons(List<LatLng> points, double radiusInMeters) {
  final coords = points.expandLatLng();
  final polygon = _closedPolygon(coords);
  final bbox = Turf.instance.bbox(polygon);
  final hexagons = Turf.instance.hexGrid(bbox, radiusInMeters);

  return _iterateInFeatures(hexagons, (feature) {
    final center = Turf.instance.centroid(feature);
    final inside = Turf.instance.booleanPointInPolygon(center, polygon);
    if (!inside) return null;

    final coords = Turf.instance.decodeGeomtryCoords(feature, reverse: true);
    return Turf.instance.polygon(coords);
  });
}
