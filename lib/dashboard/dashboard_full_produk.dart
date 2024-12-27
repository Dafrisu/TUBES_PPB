import 'package:flutter/material.dart';
import 'package:tubes_ppb/component/product_card.dart';

class FullProdukPage extends StatelessWidget {
  const FullProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
          ProductCard(title: 'Produk 1', imageUrl: 'lib/assets_images/Produk1.png'),
          ProductCard(title: 'Produk 2', imageUrl: 'lib/assets_images/Produk2.png'),
          ProductCard(title: 'Produk 3', imageUrl: 'lib/assets_images/Produk3.png'),
          ProductCard(title: 'Produk 4', imageUrl: 'lib/assets_images/Produk4.png'),
          // Add more products as needed
        ],
      ),
    );
  }
}