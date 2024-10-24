import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/register.dart';

class landingPage extends StatefulWidget {
  const landingPage({Key? key}) : super(key: key);
  @override 
  landingPageState createState() => landingPageState();
}

class landingPageState extends State<landingPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Selamat Datang\nUMKMku',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold, 
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Image(
              image: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                iconColor: Colors.green, // Button color
                minimumSize: const Size(400, 50), // Width and height
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
                fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
           ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                minimumSize: const Size(400, 50), // Width and height
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const register  (),
                  ),
                );
              },
              child: Text('Register', style: GoogleFonts.montserrat(
                fontSize: 20,
                ),
              ),
           )
          ],
        ),
      ),
    );
  }
}
