import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '/entities/boundary.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Boundary> boundaries = [];

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
        ],
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width: 20),
          if (boundaries.isNotEmpty)
            IconButton(
              onPressed: () => setState(() => boundaries = []),
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          Spacer(),
          if (boundaries.isNotEmpty)
            FloatingActionButton.extended(
              onPressed: createHexagonalCells,
              label: Text('Create Cells'),
            ),
          SizedBox(width: 20),
          if (boundaries.isNotEmpty)
            FloatingActionButton.extended(onPressed: simplify, label: Text('Simplify')),
        ],
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
      boundaries[i] = await boundary.simplify();
      setState(() {});
    }
  }

  void createHexagonalCells() async {
    for (final (i, boundary) in boundaries.indexed) {
      boundaries[i] = await boundary.fillWithCells();
      setState(() {});
    }
  }
}
