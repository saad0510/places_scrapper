import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '/screens/layers/index.dart';
import '/screens/widgets/my_button.dart';
import '/state/actions_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final actions = ProviderScope.containerOf(context).read(actionsNotifier.notifier);
    const tileUrl = 'https://maps.geoapify.com/v1/tile/{map_id}/{z}/{x}/{y}.png?apiKey={api_key}';

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(24.860, 66.990),
          initialZoom: 11,
          onLongPress: (_, x) => actions.doIt(Actions.findBoundaries, arg: x),
        ),
        children: [
          TileLayer(
            subdomains: const ['a', 'b', 'c', 'd'],
            urlTemplate: tileUrl
                .replaceFirst('{api_key}', 'b8568cb9afc64fad861a69edbddb2658')
                .replaceFirst('{map_id}', 'dark-matter-dark-grey'),
          ),
          const CellsLayer(),
          const BoundaryLayer(),
          const PlacesLayer(),
          const RoutesLayer(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Card(
        color: Colors.black45,
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            MyButton(
              onPressed: () => actions.doIt(Actions.simplifyBoundaries),
              label: 'Simplify Polygons',
              color: Colors.teal,
              icon: Icons.line_axis,
            ),
            MyButton(
              onPressed: () => actions.doIt(Actions.createCells),
              label: 'Create Cells',
              color: Colors.blue,
              icon: Icons.hexagon,
            ),
            MyButton(
              onPressed: () => actions.doIt(Actions.scrapPlaces),
              label: 'Scrap Places',
              color: Colors.orange,
              icon: Icons.search,
            ),
            MyButton(
              onPressed: () => actions.doIt(Actions.createRoutes),
              label: 'Create Routes',
              color: Colors.orange,
              icon: Icons.pedal_bike_sharp,
            ),
            MyButton(
              onPressed: () => actions.undo(),
              label: 'Undo',
              color: Colors.red,
              icon: Icons.undo,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
