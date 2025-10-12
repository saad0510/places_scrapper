import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';

import '/api/index.dart' as api;

class Cell {
  final Polygon polygon;
  final List<CircleMarker> places;

  const Cell._({required this.polygon, this.places = const []});

  factory Cell({required Polygon polygon}) {
    return Cell._(polygon: polygonCreationCallback(polygon, Colors.white));
  }

  Cell scrapPlaces() {
    final geoJson = api.scrapPlaces(polygon.points);
    final parser = GeoJsonParser();
    parser.parseGeoJson(geoJson);

    final newPlaces = [
      for (final m in parser.markers)
        CircleMarker(point: m.point, radius: 10, useRadiusInMeter: true),
    ];
    final newPolygon = polygonCreationCallback(polygon, Colors.black);
    return copyWith(places: newPlaces, polygon: newPolygon);
  }

  Cell clean() {
    final newPolygon = polygonCreationCallback(polygon, Colors.white);
    return copyWith(places: const [], polygon: newPolygon);
  }

  Cell copyWith({Polygon? polygon, List<CircleMarker>? places}) {
    return Cell._(polygon: polygon ?? this.polygon, places: places ?? this.places);
  }

  static Polygon polygonCreationCallback(Polygon polygon, Color color) {
    return Polygon(
      points: polygon.points,
      holePointsList: polygon.holePointsList,
      borderColor: color,
      color: color.withValues(alpha: 0.5),
      borderStrokeWidth: 2,
      labelStyle: TextStyle(color: Colors.white),
      labelPlacement: PolygonLabelPlacement.polylabel,
      hitValue: polygon.hitValue,
    );
  }
}
