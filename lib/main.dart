import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/api/api_keranjang.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/notif.dart';
import 'userdata/user_provider.dart';
import 'animation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notifservices().initnotif();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
