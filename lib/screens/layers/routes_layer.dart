part of 'index.dart';

class RoutesLayer extends ConsumerWidget {
  const RoutesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);

    return PolylineLayer(
      key: const Key('routes'),
      polylines: [
        for (final route in routes) //
          route.toPolyline(),
      ],
    );
  }
}
