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
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: [
            const Icon(
              Icons.business,
              color: Colors.green,
              size: 50, // Adjust the icon size as needed
            ),
            const SizedBox(height: 10), // Space between icon and text
            Text(
              'Selamat Datang',
              style: GoogleFonts.montserrat(
                fontSize: 24, // Adjust font size as needed
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const Text(
              'di UMKMku',
              style: TextStyle(
                fontSize: 24, // Adjust font size as needed
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20), // Space between text and image
            const Image(
              image: NetworkImage(
                  'https://media.discordapp.net/attachments/1033607346213105794/1298866706478923786/image.png?ex=671b1f62&is=6719cde2&hm=62e059e2049d46f8dc4817cda75f861bd87a1c888576441f89cf04e2070ead9f&=&format=webp&quality=lossless&width=486&height=662'),
              height: 150, // Set a smaller fixed height for the image
              width: 150, // Set a smaller fixed width for the image
            ),
            const SizedBox(height: 70),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(400, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const login(),
                  ),
                );
              },
              child: Text('Login', style: GoogleFonts.montserrat(
                fontSize: 20, color: Colors.white
              )),
            ),
            const SizedBox(height: 10), // Space between buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                minimumSize: const Size(400, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const register(),
                  ),
                );
              },
              child: Text('Register', style: GoogleFonts.montserrat(
                fontSize: 20, color: Colors.green,
              )),
            ),
            const SizedBox(height: 20), // Space at the bottom
          ],
        ),
      ),
    );
  }
}