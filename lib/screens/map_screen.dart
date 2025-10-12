import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '/entities/boundary.dart';
import '/routes/index.dart';
import '/screens/my_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Boundary> boundaries = [];
  List<Polyline> polylines = [];

  @override
  Widget build(BuildContext context) {
    final tileUrl = 'https://maps.geoapify.com/v1/tile/{map_id}/{z}/{x}/{y}.png?apiKey={api_key}';

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(24.860, 66.990),
          initialZoom: 11,
          onLongPress: (_, x) => onPress(x),
        ),
        children: [
          TileLayer(
            subdomains: const ['a', 'b', 'c', 'd'],
            urlTemplate: tileUrl
                .replaceFirst('{api_key}', 'b8568cb9afc64fad861a69edbddb2658')
                .replaceFirst('{map_id}', 'dark-matter-dark-grey'),
          ),
          PolygonLayer(
            key: Key('boundaries'),
            polygons: [
              for (final b in boundaries)
                if (!b.isSimple) b.polygon,
            ],
          ),
          PolygonLayer(
            key: Key('simple_boundaries'),
            polygons: [
              for (final b in boundaries)
                if (b.isSimple) b.simplified!,
            ],
          ),
          PolygonLayer(
            key: Key('cells'),
            polygons: [
              for (final b in boundaries)
                for (final cell in b.cells) cell.polygon,
            ],
          ),
          CircleLayer(
            key: Key('places'),
            circles: [
              for (final b in boundaries)
                for (final cell in b.cells) ...cell.places,
            ],
          ),
          PolylineLayer(key: Key('routes'), polylines: polylines),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: boundaries.isEmpty
          ? null
          : Card(
              color: Colors.black45,
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  MyButton(
                    onPressed: simplify,
                    label: 'Simplify Polygons',
                    color: Colors.teal,
                    icon: Icons.line_axis,
                  ),
                  MyButton(
                    onPressed: createHexagonalCells,
                    label: 'Create Cells',
                    color: Colors.blue,
                    icon: Icons.hexagon,
                  ),
                  MyButton(
                    onPressed: scrapPlaces,
                    label: 'Scrap Places',
                    color: Colors.orange,
                    icon: Icons.search,
                  ),
                  MyButton(
                    onPressed: onCreateRoutes,
                    label: 'Create Routes',
                    color: Colors.orange,
                    icon: Icons.pedal_bike_sharp,
                  ),
                  MyButton(
                    onPressed: () => setState(undo),
                    label: 'Undo',
                    color: Colors.red,
                    icon: Icons.undo,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  void onPress(LatLng latLng) async {
    final newBoundaries = await Boundary.findBoundaries(latLng);
    setState(() => boundaries.addAll(newBoundaries));
  }

  void simplify() async {
    for (final (i, boundary) in boundaries.indexed) {
      if (boundary.isSimple) continue;
      boundaries[i] = boundary.simplify();
      setState(() {});
    }
  }

  void createHexagonalCells() async {
    for (final (i, boundary) in boundaries.indexed) {
      if (boundary.cells.isNotEmpty) continue;
      boundaries[i] = boundary.fillWithCells();
      setState(() {});
    }
  }

  void scrapPlaces() async {
    for (final (i, boundary) in boundaries.indexed) {
      for (final (j, cell) in boundary.cells.indexed) {
        if (cell.places.isNotEmpty) continue;
        boundaries[i].cells[j] = cell.scrapPlaces();
      }
      setState(() {});
    }
  }

  void onCreateRoutes() async {
    final points = [
      for (final b in boundaries)
        for (final cell in b.cells)
          for (final p in cell.places) p.point,
    ];

    final routes = createRoutes(points, 200);
    polylines = routes.map((r) => r.toPolyline()).toList();
    setState(() {});
  }

  void undo() {
    bool exit = false;
    if (polylines.isNotEmpty) {
      polylines.clear();
      exit = true;
    }
    if (exit) return;
    for (final (i, boundary) in boundaries.indexed) {
      for (final (j, cell) in boundary.cells.indexed) {
        boundaries[i].cells[j] = cell.clean();
        if (cell.places.isEmpty) continue;
        exit = true;
      }
    }
    if (exit) return;
    for (final boundary in boundaries) {
      if (boundary.cells.isEmpty) continue;
      boundary.cells.clear();
      exit = true;
    }
    if (exit) return;
    for (final (i, boundary) in boundaries.indexed) {
      if (!boundary.isSimple) continue;
      boundaries[i] = boundary.copyWithSimplified(null);
      exit = true;
    }
    if (exit) return;
    boundaries.clear();
  }
}
