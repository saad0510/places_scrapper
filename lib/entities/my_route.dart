import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

class MyRoute {
  final String id;
  final LatLng center;
  final List<LatLng> points;

  const MyRoute({
    required this.id,
    required this.center,
    required this.points,
    List<LatLng>? merged,
  });

  Polyline toPolyline() {
    final color = _getPolylineColor(hashCode);
    return Polyline(
      color: color,
      borderColor: color,
      borderStrokeWidth: 2,
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
      points: [
        for (final p in points) ...[p, center],
      ],
    );
  }
}

Color _getPolylineColor(int seed) {
  final index = seed % Colors.primaries.length;
  return Colors.primaries[index];
}
