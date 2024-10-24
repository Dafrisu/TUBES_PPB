import 'package:flutter/material.dart';

void main() {
  runApp(const Penjual());
}

class Penjual extends StatelessWidget {
  const Penjual({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PagePenjual',
      home: PagePenjual(title: 'ini mainpage'),
    );
  }
}

class PagePenjual extends StatefulWidget {
  const PagePenjual({super.key, required this.title});
  final String title;
  @override
  State<PagePenjual> createState() => _PagePenjualState();
}

class _PagePenjualState extends State<PagePenjual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title),
      ),
    );
  }
}
