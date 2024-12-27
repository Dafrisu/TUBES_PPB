import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarUMKMku extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const AppBarUMKMku({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 101, 136, 100),
      automaticallyImplyLeading: true,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white, // Change this to your desired color
      ),
      title: Text(
        titleText,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // This is required to define the `preferredSize` for AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
