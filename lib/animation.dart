import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/main.dart';
import 'package:tubes_ppb/homepage.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPrefService sharedPrefService = SharedPrefService();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    int sessionId = await sharedPrefService.readCache(key: "sessionId");
    if (sessionId != 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const landingPage()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            ClipPath(
              clipper: ClipperFirst(),
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            ClipPath(
              clipper: ClipperTwo(),
              child: Container(
                color: const Color.fromARGB(255, 211, 211, 211),
                height: MediaQuery.of(context).size.height,
              ),
            ),
            ClipPath(
              clipper: ClipperThird(),
              child: Container(
                color: Colors.grey,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets_images/Sample 1 copy.png',
                      width: 200, height: 200, fit: BoxFit.cover),
                  Text("UMKMku",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 48)),
                ],
              ),
            ),
          ],
        ));
  }
}

class ClipperFirst extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 896;

    double topOffset = 0;
    double horizontalOffset = 50; // Clipper Horizontal Offset

    double verticalOffset = -200; // Clipper Vertical Offset

    path.moveTo(
        0 + horizontalOffset,
        topOffset +
            verticalOffset); // Move the starting point down by verticalOffset
    path.lineTo((147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (126.7714 * xScaling) + horizontalOffset,
        (289.06170000000003 * yScaling) + verticalOffset,
        (132.9834 * xScaling) + horizontalOffset,
        (249.97969999999998 * yScaling) + verticalOffset,
        (160.9204 * xScaling) + horizontalOffset,
        (229.7057 * yScaling) + verticalOffset);
    path.cubicTo(
        (160.9204 * xScaling) + horizontalOffset,
        (229.7057 * yScaling) + verticalOffset,
        (339.7844 * xScaling) + horizontalOffset,
        (99.90370000000001 * yScaling) + verticalOffset,
        (339.7844 * xScaling) + horizontalOffset,
        (99.90370000000001 * yScaling) + verticalOffset);
    path.cubicTo(
        (367.72040000000004 * xScaling) + horizontalOffset,
        (79.62989999999999 * yScaling) + verticalOffset,
        (406.8034 * xScaling) + horizontalOffset,
        (85.84190000000001 * yScaling) + verticalOffset,
        (427.07640000000004 * xScaling) + horizontalOffset,
        (113.77850000000001 * yScaling) + verticalOffset);
    path.cubicTo(
        (447.35040000000004 * xScaling) + horizontalOffset,
        (141.7147 * yScaling) + verticalOffset,
        (441.13840000000005 * xScaling) + horizontalOffset,
        (180.7977 * yScaling) + verticalOffset,
        (413.2024 * xScaling) + horizontalOffset,
        (201.0707 * yScaling) + verticalOffset);
    path.cubicTo(
        (413.2024 * xScaling) + horizontalOffset,
        (201.0707 * yScaling) + verticalOffset,
        (234.3384 * xScaling) + horizontalOffset,
        (330.87370000000004 * yScaling) + verticalOffset,
        (234.3384 * xScaling) + horizontalOffset,
        (330.87370000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (206.4014 * xScaling) + horizontalOffset,
        (351.14770000000004 * yScaling) + verticalOffset,
        (167.3194 * xScaling) + horizontalOffset,
        (344.9357 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class ClipperTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 896;

    double topOffset = 0;
    double horizontalOffset = 116; // Clipper Horizontal Axis
    double verticalOffset = -107; // Clipper Vertical Axis

    path.moveTo(
        0 + horizontalOffset,
        topOffset +
            verticalOffset); // Move the starting point down by verticalOffset
    path.lineTo((147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (126.7714 * xScaling) + horizontalOffset,
        (289.06170000000003 * yScaling) + verticalOffset,
        (132.9834 * xScaling) + horizontalOffset,
        (249.97969999999998 * yScaling) + verticalOffset,
        (160.9204 * xScaling) + horizontalOffset,
        (229.7057 * yScaling) + verticalOffset);
    path.cubicTo(
        (160.9204 * xScaling) + horizontalOffset,
        (229.7057 * yScaling) + verticalOffset,
        (339.7844 * xScaling) + horizontalOffset,
        (99.90370000000001 * yScaling) + verticalOffset,
        (339.7844 * xScaling) + horizontalOffset,
        (99.90370000000001 * yScaling) + verticalOffset);
    path.cubicTo(
        (367.72040000000004 * xScaling) + horizontalOffset,
        (79.62989999999999 * yScaling) + verticalOffset,
        (406.8034 * xScaling) + horizontalOffset,
        (85.84190000000001 * yScaling) + verticalOffset,
        (427.07640000000004 * xScaling) + horizontalOffset,
        (113.77850000000001 * yScaling) + verticalOffset);
    path.cubicTo(
        (447.35040000000004 * xScaling) + horizontalOffset,
        (141.7147 * yScaling) + verticalOffset,
        (441.13840000000005 * xScaling) + horizontalOffset,
        (180.7977 * yScaling) + verticalOffset,
        (413.2024 * xScaling) + horizontalOffset,
        (201.0707 * yScaling) + verticalOffset);
    path.cubicTo(
        (413.2024 * xScaling) + horizontalOffset,
        (201.0707 * yScaling) + verticalOffset,
        (234.3384 * xScaling) + horizontalOffset,
        (330.87370000000004 * yScaling) + verticalOffset,
        (234.3384 * xScaling) + horizontalOffset,
        (330.87370000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (206.4014 * xScaling) + horizontalOffset,
        (351.14770000000004 * yScaling) + verticalOffset,
        (167.3194 * xScaling) + horizontalOffset,
        (344.9357 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class ClipperThird extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 896;

    double topOffset = 0;
    double horizontalOffset = 180; // Clipper Horizontal Axis
    double verticalOffset = -8; // Clipper Vertical Axis

    path.moveTo(
        0 + horizontalOffset,
        topOffset +
            verticalOffset); // Move the starting point down by verticalOffset
    path.lineTo((147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (126.7714 * xScaling) + horizontalOffset,
        (289.06170000000003 * yScaling) + verticalOffset,
        (132.9834 * xScaling) + horizontalOffset,
        (249.97969999999998 * yScaling) + verticalOffset,
        (160.9204 * xScaling) + horizontalOffset,
        (229.7057 * yScaling) + verticalOffset);
    path.cubicTo(
        (160.9204 * xScaling) + horizontalOffset,
        (229.7057 * yScaling) + verticalOffset,
        (339.7844 * xScaling) + horizontalOffset,
        (99.90370000000001 * yScaling) + verticalOffset,
        (339.7844 * xScaling) + horizontalOffset,
        (99.90370000000001 * yScaling) + verticalOffset);
    path.cubicTo(
        (367.72040000000004 * xScaling) + horizontalOffset,
        (79.62989999999999 * yScaling) + verticalOffset,
        (406.8034 * xScaling) + horizontalOffset,
        (85.84190000000001 * yScaling) + verticalOffset,
        (427.07640000000004 * xScaling) + horizontalOffset,
        (113.77850000000001 * yScaling) + verticalOffset);
    path.cubicTo(
        (447.35040000000004 * xScaling) + horizontalOffset,
        (141.7147 * yScaling) + verticalOffset,
        (441.13840000000005 * xScaling) + horizontalOffset,
        (180.7977 * yScaling) + verticalOffset,
        (413.2024 * xScaling) + horizontalOffset,
        (201.0707 * yScaling) + verticalOffset);
    path.cubicTo(
        (413.2024 * xScaling) + horizontalOffset,
        (201.0707 * yScaling) + verticalOffset,
        (234.3384 * xScaling) + horizontalOffset,
        (330.87370000000004 * yScaling) + verticalOffset,
        (234.3384 * xScaling) + horizontalOffset,
        (330.87370000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (206.4014 * xScaling) + horizontalOffset,
        (351.14770000000004 * yScaling) + verticalOffset,
        (167.3194 * xScaling) + horizontalOffset,
        (344.9357 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);
    path.cubicTo(
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset,
        (147.0454 * xScaling) + horizontalOffset,
        (316.99870000000004 * yScaling) + verticalOffset);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
