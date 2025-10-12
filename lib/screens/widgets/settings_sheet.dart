import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/screens/widgets/base_card.dart';
import '/state/settings_notifier.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifier);

    return SizedBox(
      width: 300,
      child: BaseCard(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Radius (meters)', border: InputBorder.none),
            initialValue: settings.radiusInMeters.toString(),
            onChanged: (x) {
              final value = double.tryParse(x);
              if (value == null) return;
              ref.read(settingsNotifier.notifier).setRadius(value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Geoapify.com Key', border: InputBorder.none),
            initialValue: settings.apiKey,
            onChanged: (x) {
              ref.read(settingsNotifier.notifier).setApiKey(x);
            },
          ),
        ],
      ),
    );
  }
}
