import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/api/index.dart' show createRoutes;
import '/entities/my_route.dart';
import '/state/boundary_notifier.dart' show boundaryNotifier;
import '/state/settings_notifier.dart';

final routesProvider = Provider<List<MyRoute>>((ref) {
  final settings = ref.watch(settingsNotifier);
  if (!settings.createRoutes) return const [];

  final boundaries = ref.watch(boundaryNotifier);
  final points = [
    for (final b in boundaries)
      for (final cell in b.cells)
        for (final p in cell.places) p.point,
  ];

  final routes = createRoutes(points, settings.radiusInMeters);
  return routes;
});
