import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/login.dart';
import 'userdata/user_provider.dart';
import 'animation.dart';
import 'api/api_service.dart';
import 'package:tubes_ppb/dashboard/dashboard_test.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          UserProvider(), // Assuming UserProvider extends ChangeNotifier
      child: const MainApp(),
    ),
  );
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
