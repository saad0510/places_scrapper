import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '/screens/layers/index.dart';
import '/screens/widgets/actions_sheet.dart';
import '../state/actions_notifier.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const tileUrl = 'https://maps.geoapify.com/v1/tile/{map_id}/{z}/{x}/{y}.png?apiKey={api_key}';

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(24.860, 66.990),
          initialZoom: 11,
          onLongPress: (_, x) {
            final actions = ProviderScope.containerOf(context).read(actionsNotifier.notifier);
            actions.doIt(AppActions.findBoundaries, arg: x);
          },
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
      floatingActionButton: ActionsSheet(),
    );
  }
}
