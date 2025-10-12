import 'package:flutter/material.dart';

import '/screens/widgets/base_card.dart';

class CreditsSheet extends StatelessWidget {
  const CreditsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      children: [
        TextButton.icon(
          onPressed: null,
          icon: const Icon(Icons.email_outlined, color: Colors.white),
          label: const Text('saadbinkhalid.dev.com', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
