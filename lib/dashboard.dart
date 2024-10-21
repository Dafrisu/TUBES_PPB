// main.dart
import 'package:flutter/material.dart';// Import the DashboardPage
import 'dashboard_full_product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, Asep'),
        automaticallyImplyLeading: false, // Disable the back button
        actions: <Widget>[
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle profile button press
            },
          ),
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              // Handle inbox button press
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Product Preview Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Catalog', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Navigate to full catalog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FullCatalogPage()),
                    );
                  },
                  child: Text('See All', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          // Product Previews
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Number of columns
              children: <Widget>[
                ProductCard(title: 'Drink 1', imageUrl: 'assets/drink1.jpg'),
                ProductCard(title: 'Food 1', imageUrl: 'assets/food1.jpg'),
                // Add more previews as needed
              ],
            ),
          ),
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