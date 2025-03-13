import 'package:flutter/material.dart';
import 'mini_profile_with_rating.dart';

class ReviewCard extends StatelessWidget {
  String getTitle(String imgsource) {
    // Split by '/' to get the filename with extension
    final String filenameWithExtension = imgsource.split('/').last;

    // Split by '.' to remove the extension
    final String title = filenameWithExtension.split('.').first;

    return title;
  }

  final String username;
  final String namaProduk;
  final int rating;
  final String tanggalUlasan;
  final String ulasan;
  final String imgSource;
  final String fotoProfil;

  const ReviewCard(
      {super.key,
      required this.username,
      required this.rating,
      required this.namaProduk,
      required this.tanggalUlasan,
      required this.ulasan,
      required this.imgSource, 
      required this.fotoProfil
      });

  @override
  Widget build(BuildContext context) {
    // final String namaProduk = getTitle(imgSource);
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Color.fromRGBO(76, 175, 80, 1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MiniProfile(username: username, rating: rating),

            const SizedBox(height: 8.0),

            // Date and comment
            Text(
              tanggalUlasan,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4.0),
            Text(
              ulasan,
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 16.0),

            // Product preview
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    imgSource,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    namaProduk,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
