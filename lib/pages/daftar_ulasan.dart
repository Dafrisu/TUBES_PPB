import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_ulasans.dart';
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
                ...data.map((review) {
                  return ReviewCard(
                    username: review['username'],
                    rating: review['rating'],
                    tanggalUlasan: review['tanggalUlasan'],
                    ulasan: review['ulasan'],
                    namaProduk: review['namaProduk'],
                    imgSource: review['imgSource'],
                    fotoProfil: review['fotoProfil'] ?? 'assets/Profilepic.png',
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
