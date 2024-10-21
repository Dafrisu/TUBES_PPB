import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class landingPage extends StatelessWidget {
  const landingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Masuk',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w500, 
           color: Colors.white
            ),
          ),
        ),
      body: const Center(
        child: Image(image:  NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg') )
      ),
    );
  }
}
