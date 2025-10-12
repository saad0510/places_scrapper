import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    this.count = 0,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final IconData icon;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String label = this.label;
    if (count > 0) label += '($count)';

    return TextButton.icon(
      onPressed: onPressed,
      label: Text(label, style: TextStyle(color: color)),
      icon: Icon(icon, color: color),
    );
  }
}
