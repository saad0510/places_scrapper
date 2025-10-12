import 'dart:js_interop';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:js_util' as js_util;

typedef JsMap = Map<String, dynamic>;
typedef JsCoords = List<List<double>>;

class Turf {
  const Turf._();
  static const instance = Turf._();

  JsMap point(List<double> coord) {
    final result = _call('point', [coord]);
    final map = decodeJsMap(result);
    map['properties'] = Map<String, dynamic>.from(map['properties'] ?? {});
    return map;
  }

  JsMap polygon(JsCoords points) {
    final coords = [points];
    final result = _call('polygon', [coords]);
    final map = decodeJsMap(result);
    map['properties'] = Map<String, dynamic>.from(map['properties'] ?? {});
    return map;
  }

  JsMap simplify(JsMap polygon) {
    final options = {'tolerance': 0.001};
    final result = _call('simplify', [polygon, options]);
    return decodeJsMap(result);
  }

  List bbox(JsMap polygon) {
    final result = _call('bbox', [polygon]);
    return js_util.dartify(result) as List? ?? [];
  }

  JsMap centroid(JsMap feature) {
    final result = _call('centroid', [feature]);
    return decodeJsMap(result);
  }

  bool booleanPointInPolygon(JsMap point, JsMap polygon) {
    final result = _call('booleanPointInPolygon', [point, polygon]);
    return js_util.dartify(result) as bool? ?? false;
  }

  JsMap hexGrid(List bbox, double radiusInMeters) {
    final options = {'units': 'meters'};
    final result = _call('hexGrid', [bbox, radiusInMeters, options]);
    return decodeJsMap(result);
  }

  JsMap randomPoint(int count, List bbox) {
    final options = {'bbox': bbox};
    final result = _call('randomPoint', [count, options]);
    return decodeJsMap(result);
  }

  // decoders

  JsMap decodeJsMap(dynamic result) {
    return Map<String, dynamic>.from(js_util.dartify(result) as Map? ?? {});
  }

  JsCoords decodeGeomtryCoords(JsMap data, {bool reverse = false}) {
    final i = reverse ? 1 : 0;
    final j = reverse ? 0 : 1;

    final geoCoords = List.from(data['geometry']['coordinates'] ?? []);
    if (geoCoords.isEmpty) return [];

    final coords = geoCoords.length == 2 ? [geoCoords] : List.from(geoCoords.first);
    return [
      for (final coord in coords)
        [
          (coord[i] as num).toDouble(),
          (coord[j] as num).toDouble(), //
        ],
    ];
  }

  dynamic _call(String method, List<Object?> args) {
    final turf = js_util.getProperty(js_util.globalThis, 'turf');
    final jsArgs = [
      for (final arg in args)
        if (arg != null) arg.jsify(),
    ];
    return js_util.callMethod(turf, method, jsArgs);
  }
}
