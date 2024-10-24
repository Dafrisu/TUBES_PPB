import 'package:flutter/material.dart';
import 'login.dart'; // Import login_page.dart

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: login(), // Halaman awal adalah LoginPage
    );
  }
}
