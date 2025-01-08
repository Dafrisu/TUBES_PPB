import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_service.dart';
import '../component/review_card.dart';
import '../component/appbar.dart';

class DaftarUlasan extends StatelessWidget {
  final int idUMKM;
  const DaftarUlasan({super.key, required this.idUMKM});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUMKMku(titleText: 'Daftar Ulasan'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUlasansUMKM(idUMKM),
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
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Overall Rating: 4.1',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                ...data.map((review) {
                  return ReviewCard(
                    username: review['username'],
                    rating: review['rating'],
                    tanggalUlasan: review['tanggalUlasan'],
                    ulasan: review['ulasan'],
                    namaProduk: review['namaProduk'],
                    imgSource: 'lib/assets_images/Makanan3.jpg',
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
