import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: KurirProfilePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class KurirProfilePage extends StatelessWidget {
  const KurirProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data profil kurir
    final String nama = 'Ahmad Fikri';
    final String noTelp = '+62 812 3456 7890';
    final String namaMitra = 'UMKM Kopi Nusantara';
    final String fotoUrl =
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Kurir'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(fotoUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              noTelp,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 40, thickness: 1),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mitra UMKM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.green),
              title: Text(
                namaMitra,
                style: const TextStyle(fontSize: 16),
              ),
              tileColor: Colors.green[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
