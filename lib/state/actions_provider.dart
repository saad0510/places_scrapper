import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/state/boundary_notifier.dart';
import '/state/settings_notifier.dart';

enum Actions {
  findBoundaries('Find Boundaries'),
  simplifyBoundaries('Simplify Boundaries'),
  createCells('Create Cells'),
  scrapPlaces('Scrap Places'),
  createRoutes('Create Routes');

  final String label;
  const Actions(this.label);
}

class ActionsNotifier extends Notifier<List<Actions>> {
  @override
  List<Actions> build() => [];

  void doIt(Actions action, {arg}) {
    final notifier = ref.read(boundaryNotifier.notifier);

    switch (action) {
      case Actions.findBoundaries:
        notifier.findBoundaries(arg);
        break;
      case Actions.simplifyBoundaries:
        notifier.simplifyAll();
        break;
      case Actions.createCells:
        notifier.fillWithCells();
        break;
      case Actions.scrapPlaces:
        notifier.scrapPlaces();
        break;
      case Actions.createRoutes:
        ref.read(settingsNotifier.notifier).enableRoutesCreation();
        break;
    }
    state = state..add(action);
  }

  void undo() {
    final notifier = ref.read(boundaryNotifier.notifier);
    final lastAction = state.lastOrNull;
    if (lastAction == null) return;

    switch (lastAction) {
      case Actions.findBoundaries:
        notifier.clearAll();
        break;
      case Actions.simplifyBoundaries:
        notifier.unsimplifyAll();
        break;
      case Actions.createCells:
        notifier.removeAllCells();
        break;
      case Actions.scrapPlaces:
        notifier.removeAllPlaces();
        break;
      case Actions.createRoutes:
        ref.read(settingsNotifier.notifier).disableRoutesCreation();
        break;
    }
    state = state..removeLast();
  }
}

final actionsNotifier = NotifierProvider<ActionsNotifier, List<Actions>>(ActionsNotifier.new);
