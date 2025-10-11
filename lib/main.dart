import 'package:flutter/material.dart';

import '/screens/map_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.teal,
      theme: ThemeData.dark(),
      home: MapScreen(),
    );
  }
}
