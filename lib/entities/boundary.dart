import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '/api/index.dart' as api;
import 'cell.dart';

class Boundary {
  final Polygon polygon;
  final Polygon? simplified;
  final List<Cell> cells;

  const Boundary({required this.polygon, this.simplified, this.cells = const []});

  bool get isSimple => simplified != null;

  static Future<List<Boundary>> findBoundaries(LatLng latLng) async {
    try {
      final geoJson = await api.getGeoJson(latLng);
      final parser = GeoJsonParser(polygonCreationCallback: polygonCreationCallback);
      parser.parseGeoJson(geoJson);

      final boundaries = parser.polygons.map((p) => Boundary(polygon: p));
      return boundaries.toList();
    } catch (e) {
      return const [];
    }
  }

  Future<Boundary> simplify() async {
    if (isSimple) return this;
    try {
      final props = polygon.hitValue as Map<String, dynamic>? ?? {};
      props['old_length'] = polygon.points.length;

      final points = await api.simplifyGeoJson(polygon.points);
      final simplePolygon = polygonCreationCallback(points, polygon.holePointsList, props);
      return copyWith(simplified: simplePolygon);
    } catch (e) {
      return this;
    }
  }

  Future<Boundary> fillWithCells() async {
    try {
      final geoJson = await api.createHexagons(polygon.points);
      final parser = GeoJsonParser(polygonCreationCallback: polygonCreationCallback);
      parser.parseGeoJson(geoJson);

      final cells = parser.polygons.map((p) => Cell(polygon: p));
      return copyWith(cells: cells.toList());
    } catch (e) {
      return this;
    }
  }

  Boundary copyWithSimplified(Polygon? simplified) {
    return Boundary(polygon: polygon, simplified: simplified, cells: cells);
  }

  Boundary copyWith({Polygon? polygon, Polygon? simplified, List<Cell>? cells}) {
    return Boundary(
      polygon: polygon ?? this.polygon,
      simplified: simplified ?? this.simplified,
      cells: cells ?? this.cells,
    );
  }

  static Polygon polygonCreationCallback(
    List<LatLng> outerRing,
    List<List<LatLng>>? holesList,
    Map<String, dynamic> props,
  ) {
    final color = _getPolygonColor(outerRing.length);
    final name = props['name'] ?? props['city'] ?? props['formatted'];

    String label = '$name';
    if (props.containsKey('old_length')) {
      label += '\n${outerRing.length} (${props['old_length']}) Points';
    } else {
      label += '\n${outerRing.length} Points';
    }

    return Polygon(
      points: outerRing,
      holePointsList: holesList,
      borderColor: color,
      color: color.withValues(alpha: 0.5),
      borderStrokeWidth: 2,
      label: label,
      labelStyle: TextStyle(color: Colors.white),
      labelPlacement: PolygonLabelPlacement.polylabel,
      hitValue: props,
    );
  }
}

Color _getPolygonColor(int seed) {
  final index = seed % Colors.primaries.length;
  return Colors.primaries[index];
}
