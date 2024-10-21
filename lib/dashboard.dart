// main.dart
import 'package:flutter/material.dart';// Import the DashboardPage
import 'dashboard_full_produk.dart';
import 'dashboard_full_makanan.dart';
import 'dashboard_full_minuman.dart';
import 'dashboard_full_misc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Asep', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false, // Disable tombol back ketika di navigate ke page ini
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
          // Menampilkan List Preview Produk yang dijual UMKM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Ketika di pencet, maka akan pindah page
                    // Ke Page yang menunjukan semua Produk yang dijual UMKM
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FullProdukPage()),
                    );
                  },
                  // Tombol yang dipencet ketika ingin melihat
                  // Semua Produk yang dijual UMKM
                  child: Text('Lihat Semua', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          // Gambaran semua Produk yang dijual UMKM
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              children: <Widget>[
                ProductCard(title: 'Produk 1', imageUrl: 'assets/drink1.jpg'),
                ProductCard(title: 'Produk 2', imageUrl: 'assets/food1.jpg'),
                // Add more previews as needed
              ],
            ),
          ),

          // Menampilkan List Preview Makanan yang dijual UMKM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Makanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Ketika di pencet, maka akan pindah page
                    // Ke Page yang menunjukan semua Makanan yang dijual UMKM
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FullMakananPage()),
                    );
                  },
                  // Tombol yang dipencet ketika ingin melihat
                  // Semua Makanan yang dijual UMKM
                  child: Text('Lihat Semua', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          // Gambaran semua Makanan yang dijual UMKM
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              children: <Widget>[
                ProductCard(title: 'Makanan 1', imageUrl: 'assets/Makanan1.jpg'),
                ProductCard(title: 'Makanan 2', imageUrl: 'assets/Makanan2.jpg'),
                // Add more previews as needed
              ],
            ),
          ),

          // Menampilkan List Preview Minuman yang dijual UMKM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Minuman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Ketika di pencet, maka akan pindah page
                    // Ke Page yang menunjukan semua Minuman yang dijual UMKM
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FullMinumanPage()),
                    );
                  },
                  // Tombol yang dipencet ketika ingin melihat
                  // Semua Minuman yang dijual UMKM
                  child: Text('Lihat Semua', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          // Gambaran semua Minuman yang dijual UMKM
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              children: <Widget>[
                ProductCard(title: 'Minuman 1', imageUrl: 'assets/Minuman1.jpg'),
                ProductCard(title: 'Minuman 2', imageUrl: 'assets/Minuman2.jpg'),
                // Add more previews as needed
              ],
            ),
          ),

          // Menampilkan List Preview Misc yang dijual UMKM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Misc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Ketika di pencet, maka akan pindah page
                    // Ke Page yang menunjukan semua Misc yang dijual UMKM
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FullMiscPage()),
                    );
                  },
                  // Tombol yang dipencet ketika ingin melihat
                  // Semua Misc yang dijual UMKM
                  child: Text('Lihat Semua', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          // Gambaran semua Misc yang dijual UMKM
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              children: <Widget>[
                ProductCard(title: 'Misc 1', imageUrl: 'assets/Misc1.jpg'),
                ProductCard(title: 'Misc 2', imageUrl: 'assets/Misc2.jpg'),
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

  const ProductCard({required this.title, required this.imageUrl});

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