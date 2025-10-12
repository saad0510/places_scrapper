import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/screens/widgets/base_card.dart';
import '/state/actions_notifier.dart';

class ActionsSheet extends StatelessWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      children: [
        for (final action in AppActions.values)
          if (action != AppActions.findBoundaries)
            TextButton.icon(
              onPressed: () {
                final actions = ProviderScope.containerOf(context).read(actionsNotifier.notifier);
                actions.doIt(action);
              },
              icon: Icon(action.icon, color: action.color),
              label: Text(action.label, style: TextStyle(color: action.color)),
            ),
      ],
    );
  }
}
