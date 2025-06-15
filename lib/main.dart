import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/api/api_loginKurir.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:tubes_ppb/homepage.dart';
import 'package:tubes_ppb/kurir.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/notif.dart';
import 'userdata/user_provider.dart';
import 'animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      // Halaman pertama yang dibuka adalah AuthWrapper
      // untuk mengecek sesi login
      home: const AuthWrapper(),
    );
  }
}

// Widget ini bertugas untuk inisialisasi dan navigasi
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await notifservices().initnotif();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userRole = prefs.getString('userRole');
    final int? pembeliId = prefs.getInt('sessionId');
    final int? kurirId = prefs.getInt('kurirSessionId');

    if (!mounted) return;

    if (userRole != null) {
      if (userRole == 'pembeli' && pembeliId != null) {
        sessionId = pembeliId;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Homepage()));
      } else if (userRole == 'kurir' && kurirId != null) {
        kurirSessionId = kurirId;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Kurir()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const landingPage()));
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const landingPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}