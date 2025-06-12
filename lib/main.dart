import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/api/api_loginKurir.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:tubes_ppb/homepage.dart';
import 'package:tubes_ppb/kurir.dart';
import 'package:tubes_ppb/notif.dart';
import 'userdata/user_provider.dart';
import 'animation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notifservices().initnotif();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userRole = prefs.getString('userRole');
  final int? pembeliId = prefs.getInt('sessionId');
  final int? kurirId = prefs.getInt('kurirSessionId');

  Widget initialScreen;

  // Logika untuk menentukan halaman mana yang akan ditampilkan pertama kali
  if (userRole != null) {
    if (userRole == 'pembeli' && pembeliId != null) {
      sessionId = pembeliId; // Set ulang variabel global jika perlu
      initialScreen = const Homepage();
    } else if (userRole == 'kurir' && kurirId != null) {
      kurirSessionId = kurirId; // Set ulang variabel global jika perlu
      initialScreen = const Kurir();
    } else {
      // Jika ada data yang tidak lengkap (misal: ada role tapi tidak ada ID)
      // anggap sesi tidak valid dan arahkan ke alur login.
      initialScreen = const SplashScreen();
    }
  } else {
    // Jika tidak ada data sesi sama sekali, arahkan ke alur login.
    initialScreen = const SplashScreen();
  }

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
