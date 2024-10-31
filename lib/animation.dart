import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tubes_ppb/landing.dart';

class animation extends StatelessWidget {
  const animation({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36.0),
            child: Image.asset(
              'images/androidIcon.png',
              width: 72.0,
              height: 72.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text("Super Splash Screen Demo",
              style: TextStyle(color: Colors.black54, fontSize: 24)),
        ),
      ],
    );
    return titleSection;
  }
}


class SplashScreen  extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const landingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text("UMKMku", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50)),
      ),
    );
  }
}


