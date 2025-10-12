import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/state/actions_notifier.dart';
import '/state/boundary_notifier.dart';

class ActionsSheet extends ConsumerWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boundaries = ref.watch(boundaryNotifier);

    return Card(
      color: Colors.black45,
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (boundaries.isEmpty)
            TextButton.icon(
              onPressed: null,
              icon: Icon(Icons.info_outline, color: Colors.white),
              label: Text('Long press to add boundaries', style: TextStyle(color: Colors.white)),
            )
          else
            for (final action in AppActions.values)
              if (action != AppActions.findBoundaries)
                TextButton.icon(
                  onPressed: () => ref.read(actionsNotifier.notifier).doIt(action),
                  icon: Icon(action.icon, color: action.color),
                  label: Text(action.label, style: TextStyle(color: action.color)),
                ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
