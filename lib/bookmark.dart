import "package:flutter/material.dart";

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Wishlist',
          style: TextStyle(color: Colors.white, fontFamily: 'roboto'),
        ),
      ),
      body: Center(
        child: Text('Test'),
      ),
    );
  }
}
