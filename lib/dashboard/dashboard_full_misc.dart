import 'package:flutter/material.dart';

class FullMiscPage extends StatelessWidget {
  const FullMiscPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Misc', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              // Handle inbox button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2, // Number of columns
        children: const <Widget>[
          ProductCard(title: 'Misc 1', imageUrl: 'lib/assets_images/Misc1.png'),
          ProductCard(title: 'Misc 2', imageUrl: 'lib/assets_images/Misc2.png'),
          ProductCard(title: 'Misc 3', imageUrl: 'lib/assets_images/Misc3.png'),
          ProductCard(title: 'Misc 4', imageUrl: 'lib/assets_images/Misc4.jpg'),
          // Add more products as needed
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ProductCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(imageUrl,
              fit: BoxFit.cover, height: 100, width: 100), // nanti sesuaikan height sama width
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}