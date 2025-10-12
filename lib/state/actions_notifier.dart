import 'package:flutter/material.dart' show Colors, Icons;
import 'package:flutter/widgets.dart' show IconData, Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/state/boundary_notifier.dart';
import '/state/settings_notifier.dart';

enum AppActions {
  findBoundaries('Find Boundaries', Colors.white, Icons.search),
  simplifyBoundaries('Simplify Boundaries', Colors.teal, Icons.line_axis),
  createCells('Create Cells', Colors.blue, Icons.hexagon),
  scrapPlaces('Scrap Places', Colors.cyanAccent, Icons.search),
  createRoutes('Create Routes', Colors.orange, Icons.pedal_bike_sharp),
  undo('Undo', Colors.red, Icons.undo);

  final String label;
  final Color color;
  final IconData icon;

  const AppActions(this.label, this.color, this.icon);
}

class ActionsNotifier extends Notifier<List<AppActions>> {
  @override
  List<AppActions> build() => [];

  void doIt(AppActions action, {arg}) {
    final notifier = ref.read(boundaryNotifier.notifier);

    switch (action) {
      case AppActions.findBoundaries:
        notifier.findBoundaries(arg);
        break;
      case AppActions.simplifyBoundaries:
        notifier.simplifyAll();
        break;
      case AppActions.createCells:
        notifier.fillWithCells();
        break;
      case AppActions.scrapPlaces:
        notifier.scrapPlaces();
        break;
      case AppActions.createRoutes:
        ref.read(settingsNotifier.notifier).enableRoutesCreation();
        break;
      case AppActions.undo:
        undo();
        return;
    }
    if (state.lastOrNull != action) {
      state = state..add(action);
    }
  }

  void undo() {
    final notifier = ref.read(boundaryNotifier.notifier);
    final lastAction = state.lastOrNull;
    if (lastAction == null) return;

    switch (lastAction) {
      case AppActions.findBoundaries:
        notifier.clearAll();
        break;
      case AppActions.simplifyBoundaries:
        notifier.unsimplifyAll();
        break;
      case AppActions.createCells:
        notifier.removeAllCells();
        break;
      case AppActions.scrapPlaces:
        notifier.removeAllPlaces();
        break;
      case AppActions.createRoutes:
        ref.read(settingsNotifier.notifier).disableRoutesCreation();
        break;
      case AppActions.undo:
        break;
    }
    state = state..removeLast();
  }
}

final actionsNotifier = NotifierProvider<ActionsNotifier, List<AppActions>>(ActionsNotifier.new);
