import 'package:flutter/material.dart';

import '/screens/widgets/base_card.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: EdgeInsets.symmetric(vertical: 10),
      children: [
        TextButton.icon(
          onPressed: null,
          icon: Icon(Icons.info_outline, color: Colors.white),
          label: Text('Long press to add boundaries', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
