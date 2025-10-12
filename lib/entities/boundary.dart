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

  Boundary simplify() {
    if (isSimple) return this;
    final props = polygon.hitValue as Map<String, dynamic>? ?? {};
    final points = api.simplifyPoints(polygon.points);
    final simplePolygon = polygonCreationCallback(points, polygon.holePointsList, props);
    return copyWith(simplified: simplePolygon);
  }

  Boundary unsimplify() {
    return Boundary(polygon: polygon, simplified: null, cells: cells);
  }

  Boundary fillWithCells(double radius) {
    final geoJson = api.createHexagons(polygon.points, radius);
    final parser = GeoJsonParser(polygonCreationCallback: polygonCreationCallback);
    parser.parseGeoJson(geoJson);

    final cells = parser.polygons.map((p) => Cell(polygon: p));
    return copyWith(cells: cells.toList());
  }

  Boundary copyWith({Polygon? polygon, Polygon? simplified, List<Cell>? cells}) {
    return Boundary(
      polygon: polygon ?? this.polygon,
      simplified: simplified ?? this.simplified,
      cells: cells ?? this.cells,
    );
  }

  Boundary refresh() {
    return copyWith(
      polygon: polygonCreationCallbackFromPolygon(polygon, this),
      simplified: isSimple ? polygonCreationCallbackFromPolygon(simplified!, this) : null,
    );
  }

  static Polygon polygonCreationCallbackFromPolygon(Polygon polygon, Boundary boundary) {
    return polygonCreationCallback(
      polygon.points,
      polygon.holePointsList,
      polygon.hitValue as Map<String, dynamic>,
      boundary,
    );
  }

  static Polygon polygonCreationCallback(
    List<LatLng> outerRing,
    List<List<LatLng>>? holesList,
    Map<String, dynamic> props, [
    Boundary? prev,
  ]) {
    final color = _getPolygonColor(outerRing.length);
    final label = _getPolygonLabel(outerRing, props, prev);

    return Polygon(
      points: outerRing,
      holePointsList: holesList,
      borderColor: color,
      color: color.withValues(alpha: 0.5),
      borderStrokeWidth: 2,
      label: label,
      labelStyle: const TextStyle(color: Colors.white),
      labelPlacement: PolygonLabelPlacement.polylabel,
      hitValue: props,
    );
  }
}

Color _getPolygonColor(int seed) {
  final index = seed % Colors.primaries.length;
  return Colors.primaries[index];
}

String _getPolygonLabel(List<LatLng> outerRing, Map props, Boundary? prev) {
  final name = props['name'] ?? props['city'] ?? props['formatted'];
  if (prev == null) {
    return name.toString();
  }

  String label = name.toString();

  if (prev.isSimple) {
    label += '\n${prev.simplified?.points.length} (${prev.polygon.points.length}) Points';
  } else {
    label += '\n${prev.polygon.points.length} Points';
  }

  if (prev.cells.isNotEmpty) {
    label += '\n${prev.cells.length} Cells';
  }

  final places = [
    for (final cell in prev.cells)
      for (final place in cell.places) place,
  ];
  if (places.isNotEmpty) {
    label += '\n${places.length} Places';
  }

  return label;
}
