part of 'index.dart';

class PlacesLayer extends ConsumerWidget {
  const PlacesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boundaries = ref.watch(boundaryNotifier);

    return CircleLayer(
      key: const Key('places'),
      circles: [
        for (final boundary in boundaries)
          for (final cell in boundary.cells) //
            ...cell.places,
      ],
    );
  }
}
