part of 'index.dart';

List<LatLng> getNearbyPoints(LatLng center, double radius, List<LatLng> points) {
  final bbox = BoundingBox.fromCenter(center, radius);
  return [
    for (final point in points)
      if (bbox.contains(point)) point,
  ];
}
