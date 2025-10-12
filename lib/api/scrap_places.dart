part of 'index.dart';

Map<String, dynamic> scrapPlaces(List<LatLng> points) {
  final coords = points.expandLatLng();
  final polygon = _closedPolygon(coords);
  final bbox = Turf.instance.bbox(polygon);
  final count = Random().nextInt(20);

  final places = Turf.instance.randomPoint(count, bbox);
  return _iterateInFeatures(places, (feature) {
    final coords = Turf.instance.decodeGeomtryCoords(feature, reverse: true);
    return Turf.instance.point(coords.first);
  });
}
