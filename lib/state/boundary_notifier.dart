import 'package:flutter_map_geojson/flutter_map_geojson.dart' show GeoJsonParser;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '/api/index.dart' as api;
import '/entities/boundary.dart';
import '/entities/cell.dart';
import '/state/settings_notifier.dart';

class BoundaryNotifier extends Notifier<List<Boundary>> {
  @override
  List<Boundary> build() => const [];

  void findBoundaries(LatLng latLng) async {
    final apiKey = ref.read(settingsNotifier).apiKey;
    final details = await api.reverseGeocode(latLng, apiKey);
    final geoJson = await api.fetchGeojson(details['place_id'], apiKey);
    final parser = GeoJsonParser(polygonCreationCallback: Boundary.polygonCreationCallback);
    parser.parseGeoJson(geoJson);

    final boundaries = parser.polygons.map((p) => Boundary(polygon: p)).toList();
    state = [...state, ...boundaries];
  }

  void simplifyAll() async {
    state = [
      for (final boundary in state)
        if (boundary.isSimple) //
          boundary
        else
          boundary.simplify().refresh(),
    ];
  }

  void unsimplifyAll() {
    state = [
      for (final boundary in state)
        if (boundary.isSimple) //
          boundary.unsimplify().refresh()
        else
          boundary,
    ];
  }

  void fillWithCells() {
    final radius = ref.read(settingsNotifier).radiusInMeters;
    state = [
      for (final boundary in state)
        if (boundary.cells.isEmpty) //
          boundary.fillWithCells(radius).refresh()
        else
          boundary,
    ];
  }

  void removeAllCells() {
    state = [
      for (final boundary in state)
        if (boundary.cells.isEmpty) //
          boundary
        else
          boundary.copyWith(cells: const []).refresh(),
    ];
  }

  void scrapPlaces() {
    state = [
      for (final boundary in state)
        boundary
            .copyWith(
              cells: [
                for (final cell in boundary.cells)
                  if (cell.places.isEmpty) //
                    cell.scrapPlaces()
                  else
                    cell,
              ],
            )
            .refresh(),
    ];
  }

  void removeAllPlaces() {
    state = [
      for (final boundary in state)
        boundary
            .copyWith(
              cells: [
                for (final cell in boundary.cells) //
                  Cell(polygon: cell.polygon),
              ],
            )
            .refresh(),
    ];
  }

  void clearAll() {
    state = [];
  }
}

final boundaryNotifier = NotifierProvider<BoundaryNotifier, List<Boundary>>(BoundaryNotifier.new);
