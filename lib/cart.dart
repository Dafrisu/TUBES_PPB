import 'package:flutter/material.dart';

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];
final List<Map<String, dynamic>> listdata = [
  {"asd": "asd"}
];

// class cart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'cart',
//       home: Cartpage(title: 'ini cart page'),
//     );
//   }
// }

class cart extends StatelessWidget {
  const cart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Cartpage(title: 'ini cart page');
  }
}

class Cartpage extends StatefulWidget {
  const Cartpage({super.key, required this.title});
  final String title;
  @override
  State<Cartpage> createState() => _cartpagestate();
}

class _cartpagestate extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.title),
        backgroundColor: colorpalete[0]["green"],
      ),
    );
  }
}
