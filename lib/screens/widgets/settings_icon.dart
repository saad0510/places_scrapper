import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/screens/widgets/base_card.dart';
import '/state/settings_notifier.dart';

class SettingsIcon extends ConsumerWidget {
  const SettingsIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSettings = ref.watch(settingsNotifier.select((s) => s.showSettings));

    return BaseCard(
      children: [
        IconButton(
          onPressed: () => ref.read(settingsNotifier.notifier).toggleShowSettings(),
          icon: showSettings ? const Icon(Icons.close) : const Icon(Icons.edit),
          color: Colors.white,
        ),
      ],
    );
  }
}
