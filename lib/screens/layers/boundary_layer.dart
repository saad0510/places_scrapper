part of 'index.dart';

class BoundaryLayer extends ConsumerWidget {
  const BoundaryLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boundaries = ref.watch(boundaryNotifier);

    return PolygonLayer(
      key: Key('boundaries'),
      polygons: [
        for (final b in boundaries) //
          b.isSimple ? b.simplified! : b.polygon,
      ],
    );
  }
}
