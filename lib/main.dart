import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/api/api_keranjang.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/notif.dart';
import 'userdata/user_provider.dart';
import 'animation.dart';
import 'api/api_service.dart';
import 'package:tubes_ppb/dashboard/dashboard_test.dart';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefService{
    Future writeCache({
      required String key,
      required String value}) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();

     bool isSaved = await pref.setString("sessionId", value);
     debugPrint(isSaved.toString());
    }

    Future<String?> readCache({required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? value = pref.getString(key);
    debugPrint(value.toString());
    return value;
    
  }

    Future removeCache({required String key}) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();

      bool isRemoved = await pref.clear();
      debugPrint(isRemoved.toString());
    }

    //  Future readCache({
    //   required String key,
    //   required String value}) async {
    //   final SharedPreferences pref = await SharedPreferences.getInstance();

    //  String? value = await pref.getString(key);
    //  debugPrint(value.toString());
    //  if(value != null){
    //    debugPrint(value.toString());
    //  }
    // }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notifservices().initnotif();
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
