import 'package:flutter/material.dart';
import 'package:tubes_ppb/BarangPenjual.dart';
import 'package:tubes_ppb/api/api_service.dart';
import 'package:tubes_ppb/component/product_card.dart';
import 'package:tubes_ppb/notification_page.dart';

class FullMiscPage extends StatelessWidget {
  const FullMiscPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Misc',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          const SizedBox(width: 10),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDataByType('Misc'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // kolom
              childAspectRatio: 0.75,
            ),
            itemCount: data.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageBarang(product: item)));
                },
                child: ProductCardURL(
                  title: item['nama_barang'],
                  imageUrl: item['image_url'],
                  price: item['harga'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
