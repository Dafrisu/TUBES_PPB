import 'package:flutter/material.dart';
import 'package:tubes_ppb/landing.dart';
import 'login.dart'; // Import login_page.dart

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //landing page ato login page?
      home: const login(), // Halaman awal adalah LoginPage
    );
  }
}
