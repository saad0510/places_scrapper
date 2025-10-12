part of 'index.dart';

List<LatLng> simplifyPoints(List<LatLng> points) {
  final coords = points.expandLatLng();
  final polygon = Turf.instance.polygon(coords);
  final simplePolygon = Turf.instance.simplify(polygon);
  final simpleCoords = Turf.instance.decodeGeomtryCoords(simplePolygon);
  return simpleCoords.decodeLatLng();
}
