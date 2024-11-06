import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarUMKMku extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const AppBarUMKMku({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
      automaticallyImplyLeading: true,
      centerTitle: true,
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
