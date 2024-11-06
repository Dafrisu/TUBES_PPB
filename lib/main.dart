import 'package:flutter/material.dart';
import 'package:tubes_ppb/animation.dart';
import 'package:tubes_ppb/dashboard/dashboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
    );
  }
}
