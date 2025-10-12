import 'package:flutter/material.dart';

import '/screens/widgets/base_card.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        TextButton.icon(
          onPressed: null,
          icon: const Icon(Icons.info_outline, color: Colors.white),
          label: const Text('Long press to add boundaries', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
