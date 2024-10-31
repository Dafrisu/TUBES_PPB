import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/register.dart';

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
            const Icon(
              Icons.business,
              color: Colors.green,
              size: 50, 
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
            const Text(
              'di UMKMku',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20), 
            Image.asset('assets/landing_image.jpg',
              height: 150, 
              width: 150, 
              fit: BoxFit.cover,
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
            const SizedBox(height: 70, width: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(300, 50),
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
