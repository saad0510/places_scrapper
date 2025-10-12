part of 'index.dart';

class CellsLayer extends ConsumerWidget {
  const CellsLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boundaries = ref.watch(boundaryNotifier);

    return PolygonLayer(
      key: const Key('cells'),
      polygons: [
        for (final boundary in boundaries)
          for (final cell in boundary.cells) //
            cell.polygon,
      ],
    );
  }
}
