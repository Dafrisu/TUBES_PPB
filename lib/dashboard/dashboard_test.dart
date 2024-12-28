import 'package:flutter/material.dart';
import 'dashboard_full_produk.dart';
import 'dashboard_full_makanan.dart';
import 'dashboard_full_minuman.dart';
import 'dashboard_full_misc.dart';
import 'package:tubes_ppb/component/product_card.dart';
import 'package:tubes_ppb/api/api_service.dart';

class DashboardDua extends StatelessWidget {
  const DashboardDua({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Fetch Example'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Column(children: [
              // Menampilkan List Preview Minuman yang dijual UMKM
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Minuman',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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

              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                ),
                itemCount: data.length, // Number of items in the data
                shrinkWrap:
                    true, // Allow GridView to take only the space it needs
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling
                itemBuilder: (context, index) {
                  final item = data[index]; // Get the item from the data
                  return ProductCard(
                    title: item['nama_barang'], // Access the correct property
                    imageUrl:
                        'lib/assets_images/Minuman1.png', // Use a relevant image URL
                  );
                },
              ),
            ]),
          );
        },
      ),
    );
  }
}
