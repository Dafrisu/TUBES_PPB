import 'package:flutter/material.dart';
import 'daftar_ulasan.dart';
import '../component/mini_profile_with_rating.dart';
import '../component/appbar.dart';
import '../component/formfield.dart';

class ProfilUMKM extends StatelessWidget {
  const ProfilUMKM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarUMKMku(titleText: 'Profil UMKMku'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              MiniProfile(username: 'Asep Montir', rating: 5),
              CustomFormField(
                  isi: 'asepkun@ganteng.com',
                  label: 'Alamat Email',
                  readOnly: true),
              CustomFormField(
                  isi: '085xxxxxxxxxx', label: 'Nomor Telepon', readOnly: true),
              CustomFormField(
                  isi: 'Jalan kaki', label: 'Alamat', readOnly: true),
              CustomFormField(
                  isi: 'biasanya sih saya suka jualan bunga',
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
                                  builder: (context) => DaftarUlasan()),
                            );
                          })),
                ),
              ),
            ],
          ),
        ));
  }
}
