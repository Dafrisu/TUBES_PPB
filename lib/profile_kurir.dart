import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_ppb/kurir.dart';
import 'Chat/lib/api/Raphael_api_chat.dart';
import 'package:tubes_ppb/api/api_loginKurir.dart';

void main() {
  runApp(const MaterialApp(
    home: KurirProfilePage(
      nama: 'Budi',
      noTelp: '081234567890',
      namaMitra: 'Ayam Babrut',
      status: 'Ditolak',
      idKurir: 9,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class KurirProfilePage extends StatefulWidget {
  final String nama;
  final String noTelp;
  final String namaMitra;
  final String status;
  final int idKurir;

  const KurirProfilePage({
    super.key,
    required this.nama,
    required this.noTelp,
    required this.namaMitra,
    required this.status,
    required this.idKurir,
  });

  @override
  State<KurirProfilePage> createState() => _KurirProfilePageState();
}

class _KurirProfilePageState extends State<KurirProfilePage> {
  final String fotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541';

  Future<List<String>> daftarUmkm = getUmkm();

  String? selectedUmkm;

  Future<void> konfirmasiPilihUmkm(String umkm) async {
    final url = Uri.parse(
        'https://contohapi.com/konfirmasi_umkm?nama_umkm=${Uri.encodeComponent(umkm)}');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Konfirmasi UMKM berhasil!"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal konfirmasi. Kode: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Terjadi kesalahan: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  String nama = '';
  String noTelp = '';
  String namaMitra = '';
  String status = '';
  int idKurir = 0;
  @override
  void initState() {
    super.initState();
    _fetchKurirData();
  }

  Future<void> _fetchKurirData() async {
    Map<String, dynamic> kurirData = await fetchKurirData();
    setState(() {
      nama = kurirData['nama_kurir'];
      status = kurirData['status'] ?? 'Tidak diketahui';
      noTelp = kurirData['nomor_telepon'] ?? 'Tidak diketahui';
      namaMitra = kurirData['nama_usaha'] ?? 'Tidak diketahui';
      idKurir = kurirSessionId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Kurir'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Kurir(),
              ),
            );
          },
        ),
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
              widget.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.noTelp,
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

            // ==== KONDISI: Jika status bukan 'Dipecat' ====
            if (widget.status != 'Dipecat' && widget.status != 'Ditolak')
              ListTile(
                leading: const Icon(Icons.store, color: Colors.green),
                title: Text(
                  widget.namaMitra,
                  style: const TextStyle(fontSize: 16),
                ),
                tileColor: Colors.green[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            else if (widget.status == 'Dipecat' || widget.status == 'Ditolak')
              ListTile(
                leading: const Icon(Icons.error, color: Colors.red),
                title: Text(
                  'Status: ${widget.status}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                tileColor: Colors.red[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            if (widget.status == 'Dipecat' || widget.status == 'Ditolak')
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FutureBuilder<List<String>>(
                        future:
                            getUmkm(), // Fungsi async yang mengembalikan List<String>
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Tidak ada UMKM tersedia');
                          }

                          final umkmList = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            value: selectedUmkm,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Pilih UMKM Baru',
                              border: OutlineInputBorder(),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: umkmList.map((String nama) {
                              return DropdownMenuItem<String>(
                                value: nama,
                                child: Text(
                                  nama,
                                  overflow: TextOverflow
                                      .ellipsis, // biar teks panjang tidak meledak
                                ),
                              );
                            }).toList(),
                            // 👇 INI YANG PENTING
                            selectedItemBuilder: (BuildContext context) {
                              return umkmList.map((String nama) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    nama,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                );
                              }).toList();
                            },
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedUmkm = newValue!;
                              });
                            },
                          );
                        },
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: selectedUmkm == null
                        ? null
                        : () {
                            updateidumkmdanstatuskurir(
                                selectedUmkm!, widget.idKurir);
                            _fetchKurirData(); // Refresh data setelah update
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KurirProfilePage(
                                  nama: widget.nama,
                                  noTelp: widget.noTelp,
                                  namaMitra: widget.namaMitra,
                                  status: widget.status,
                                  idKurir: widget.idKurir,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.check),
                    label: const Text("Konfirmasi Pilihan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
