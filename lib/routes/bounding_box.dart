part of 'index.dart';

class BoundingBox {
  final double latMin;
  final double latMax;
  final double lngMin;
  final double lngMax;

  const BoundingBox({
    required this.latMin,
    required this.latMax,
    required this.lngMin,
    required this.lngMax,
  });

  factory BoundingBox.fromCenter(LatLng center, double radius) {
    final lat = center.latitude;
    final lng = center.longitude;

    const metersPerLat = 111320;
    final metersPerLng = metersPerLat * math.cos(lat * _piBy180);

    final dLat = radius / metersPerLat;
    final dLng = radius / metersPerLng;

    return BoundingBox(
      latMin: lat - dLat,
      latMax: lat + dLat,
      lngMin: lng - dLng,
      lngMax: lng + dLng,
    );
  }

  bool contains(LatLng point) {
    final lat = point.latitude;
    final lng = point.longitude;
    return (lat >= latMin && lat <= latMax && lng >= lngMin && lng <= lngMax);
  }
}

const _piBy180 = math.pi / 180;
