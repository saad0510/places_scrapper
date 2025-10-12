part of 'index.dart';

List<MyRoute> createRoutes(List<LatLng> points, double distance) {
  List<MyRoute> routes = [];

  for (final p in points) {
    final rid = nanoid(10);
    final neighbors = getNearbyPoints(p, distance, points);
    final route = MyRoute(id: rid, center: p, points: neighbors);
    routes.add(route);
  }

  return routes;
}
