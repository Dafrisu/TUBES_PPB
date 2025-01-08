import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_getprofileumkm.dart';
import 'daftar_ulasan.dart';
import '../component/mini_profile_with_rating.dart';
import '../component/appbar.dart';
import '../component/formfield.dart';

class ProfilUMKM extends StatelessWidget {
  final int idUMKM;
  const ProfilUMKM({super.key, required this.idUMKM});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUMKMku(titleText: 'Profil UMKMku'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getumkm(idUMKM),
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
                MiniProfile(username: data['username'], rating: 5),
                CustomFormField(
                    isi: data['email'],
                    label: 'Alamat Email',
                    readOnly: true),
                CustomFormField(
                    isi: data['nomor_telepon'],
                    label: 'Nomor Telepon',
                    readOnly: true),
                CustomFormField(
                    isi: data['alamat'], 
                    label: 'Alamat', 
                    readOnly: true),
                CustomFormField(
                    isi: '',
                    label: 'Deskripsi UMKM',
                    readOnly: true),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    initialValue: '4 dari 5',
                    readOnly: true,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Ulasan',
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DaftarUlasan(idUMKM: idUMKM,)),
                              );
                            })),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
