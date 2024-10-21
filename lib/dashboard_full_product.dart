import 'package:flutter/material.dart';

class FullCatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Catalog'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Number of columns
        children: <Widget>[
          ProductCard(title: 'Drink 1', imageUrl: 'assets/drink1.jpg'),
          ProductCard(title: 'Drink 2', imageUrl: 'assets/drink2.jpg'),
          ProductCard(title: 'Food 1', imageUrl: 'assets/food1.jpg'),
          ProductCard(title: 'Food 2', imageUrl: 'assets/food2.jpg'),
          // Add more products as needed
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(imageUrl, fit: BoxFit.cover, height: 100), // Adjust height as needed
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}