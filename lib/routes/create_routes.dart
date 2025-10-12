part of 'index.dart';

List<MyRoute> createRoutes(List<LatLng> points, double distance) {
  List<MyRoute> routes = [];
  Map<LatLng, String> pointToRoute = {};

  for (final p in points) {
    if (pointToRoute.containsKey(p)) continue;

    final rid = nanoid(10);
    final neighbors = getNearbyPoints(p, distance, points);
    final route = MyRoute(id: rid, center: p, points: neighbors);
    routes.add(route);

    pointToRoute[p] = rid;
    for (final n in neighbors) {
      pointToRoute[n] = rid;
    }
  }

  return routes;
}
