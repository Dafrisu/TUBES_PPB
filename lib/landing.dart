import 'package:flutter/material.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/register.dart';

//package 
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

const List<String> carouselItems = [
  'lib/assets_images/landing_page1.jpg',
  'lib/assets_images/landing_page2.jpg',
  'lib/assets_images/landing_page3.jpg',
];

class landingPage extends StatefulWidget {
  const landingPage({super.key});

  @override
  landingPageState createState() => landingPageState();
}

class landingPageState extends State<landingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Image.asset(
              'lib/assets_images/sample 1 copy.png',
              width: 200, 
              height: 200, 
              fit: BoxFit.cover
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
            // Image.asset("lib/assets_images/landing_image.jpg",
            //   height: 150, 
            //   width: 150, 
            //   fit: BoxFit.cover,
            // ),
            FlutterCarousel(
            // Settingan untuk carouselnya (ukuran, otomatis ganti, produk awal, dkk)
            options: FlutterCarouselOptions(
              height: 200.0,
              showIndicator: true,
              initialPage:0, // Set untuk show item paling pertama ketika page dibuka
              autoPlay: true, // Set carousel otomatis berganti-ganti
              autoPlayInterval: const Duration(seconds:3), // Set interval berapa detik sebelum otomatis berganti item selanjutnya
              slideIndicator: CircularSlideIndicator(),
            ),
            // Isi carousel
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
                }
              ) .toList(),
            ),
            // const Image(
            //   // image: FileImage(
            //   //     ),
            //   image: AssetImage(
            //       'landing_image.jpg'),
            //   height: 150, 
            //   width: 150, 
            //   fit: BoxFit.cover,
            // ),
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
              child: Text('Register',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Colors.green,
                  )),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
