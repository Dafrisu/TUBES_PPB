import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/Dafa_register.dart';

//package
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

const List<String> carouselItems = [
  'lib/assets_images/landing_page1.jpg',
  'lib/assets_images/landing_page2.jpg',
  'lib/assets_images/landing_page3.jpg',
];

List<Particle> createParticles() {
  var rng = Random();
  List<Particle> particles = [];
  for (int i = 0; i < 100; i++) {
    particles.add(Particle(
      color: Colors.green.withOpacity(0.6),
      size: rng.nextDouble() * 10,
      velocity: Offset(rng.nextDouble() * 50 * randomSign(),
          rng.nextDouble() * 200 * randomSign()),
    ));
  }
  return particles;
}

double randomSign() {
  var rng = Random();
  return rng.nextBool() ? 1 : -1;
}

class landingPage extends StatefulWidget {
  const landingPage({super.key});

  @override
  landingPageState createState() => landingPageState();
}

class landingPageState extends State<landingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Particles(
            awayRadius: 150,
            particles: createParticles(),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            onTapAnimation: false,
            awayAnimationDuration: const Duration(milliseconds: 100),
            awayAnimationCurve: Curves.linear,
            enableHover: false,
            hoverRadius: 90,
            connectDots: true,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets_images/sample 1 copy.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  'di UMKMku',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 30),
                FlutterCarousel(
                  options: FlutterCarouselOptions(
                    height: 200.0,
                    showIndicator: true,
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    slideIndicator: CircularSlideIndicator(),
                  ),
                  items: carouselItems.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.green),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(300, 50),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const login(),
                      ),
                    );
                  },
                  child: Text('Login',
                      style: GoogleFonts.montserrat(
                          fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size(300, 50),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const register(),
                      ),
                    );
                  },
                  child: Text('Registrasi',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
