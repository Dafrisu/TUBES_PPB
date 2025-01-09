import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_service.dart';
import 'dashboard_full_produk.dart';
import 'dashboard_full_makanan.dart';
import 'dashboard_full_minuman.dart';
import 'dashboard_full_misc.dart';
import 'package:tubes_ppb/notification_page.dart';
import 'package:tubes_ppb/component/product_card.dart';

// Import package carousel dari pub.dev
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navbar
      appBar: AppBar(
        title: const Text('Hello, Asep',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading:
            false, // Disable tombol back ketika di navigate ke page ini
        actions: <Widget>[
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              // Handle search logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Limit the data to 4 items (or however many you want to show)
                final data = snapshot.data!;
                final limitedData =
                    data.take(6).toList(); // Display only the first 4 items

                return // Membuat carousel produk
                    FlutterCarousel(
                  // Settingan untuk carouselnya (ukuran, otomatis ganti, produk awal, dkk)
                  options: FlutterCarouselOptions(
                    height: 250.0,
                    showIndicator: true,
                    initialPage:
                        0, // Set untuk show item paling pertama ketika page dibuka
                    autoPlay: true, // Set carousel otomatis berganti-ganti
                    autoPlayInterval: const Duration(
                        seconds:
                            3), // Set interval berapa detik sebelum otomatis berganti item selanjutnya
                    slideIndicator: CircularSlideIndicator(),
                  ),
                  // Isi carousel
                  items: limitedData.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Image.network(
                              item['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Image not available'),
                                );
                              },
                            ));
                      },
                    );
                  }).toList(),
                );
              },
            ),

            // Menampilkan List Preview Produk yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Produk',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Produk yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullProdukPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Produk yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Produk yang dijual UMKM
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Limit the data to 4 items (or however many you want to show)
                final data = snapshot.data!;
                final limitedData =
                    data.take(4).toList(); // Display only the first 4 items

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // kolom
                    childAspectRatio: 0.75,
                  ),
                  itemCount: limitedData.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ProductCardURL(
                        title: item['nama_barang'],
                        imageUrl: item['image_url']);
                  },
                );
              },
            ),

            // Menampilkan List Preview Makanan yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Makanan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Makanan yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullMakananPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Makanan yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Makanan yang dijual UMKM
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDataByType('Makanan'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Limit the data to 4 items (or however many you want to show)
                final data = snapshot.data!;
                final limitedData =
                    data.take(4).toList(); // Display only the first 4 items

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // kolom
                    childAspectRatio: 0.75,
                  ),
                  itemCount: limitedData.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ProductCardURL(
                        title: item['nama_barang'],
                        imageUrl: item['image_url']);
                  },
                );
              },
            ),

            // Menampilkan List Preview Minuman yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Minuman',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Minuman yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullMinumanPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Minuman yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Minuman yang dijual UMKM
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDataByType('Minuman'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Limit the data to 4 items (or however many you want to show)
                final data = snapshot.data!;
                final limitedData =
                    data.take(4).toList(); // Display only the first 4 items

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // kolom
                    childAspectRatio: 0.75,
                  ),
                  itemCount: limitedData.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ProductCardURL(
                        title: item['nama_barang'],
                        imageUrl: item['image_url']);
                  },
                );
              },
            ),

            // Menampilkan List Preview Misc yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Misc',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Misc yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullMiscPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Misc yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Misc yang dijual UMKM
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDataByType('Misc'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Limit the data to 4 items (or however many you want to show)
                final data = snapshot.data!;
                final limitedData =
                    data.take(4).toList(); // Display only the first 4 items

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // kolom
                    childAspectRatio: 0.75,
                  ),
                  itemCount: limitedData.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ProductCardURL(
                        title: item['nama_barang'],
                        imageUrl: item['image_url']);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
