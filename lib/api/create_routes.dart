part of 'index.dart';

List<MyRoute> createRoutes(List<LatLng> points, double distance) {
  List<MyRoute> routes = [];
  Map<LatLng, bool> visited = {};

  for (final p in points) {
    if (visited.containsKey(p)) continue;

    final rid = nanoid(10);
    final neighbors = _getNearbyPoints(p, distance, points);
    final route = MyRoute(id: rid, center: p, points: neighbors);
    routes.add(route);

    visited[p] = true;
    for (final n in neighbors) {
      visited[n] = true;
    }
  }

  return routes;
}

List<LatLng> _getNearbyPoints(LatLng center, double radius, List<LatLng> points) {
  final bbox = BoundingBox.fromCenter(center, radius);
  return [
    for (final point in points)
      if (bbox.contains(point)) point,
  ];
}
