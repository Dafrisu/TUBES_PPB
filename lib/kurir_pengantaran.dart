import 'package:flutter/material.dart';
import 'package:tubes_ppb/kurir.dart';

void main() {
  runApp(const kurir_pengantaran(
    nama_pembeli: 'ELA TERLALU SPIT ayayay',
    alamat_pembeli: '123 Main St',
    total_belanja: '0',
    namaBarang: ['Gurame Bakar'],
    id_pesanan: 1,
    nomor_telepon: '1234567890',
    kuantitas: '',
  ));
}

class OrderItem {
  final String name;
  final int qty;
  final int price;

  OrderItem(this.name, this.qty, this.price);
}

// ---------- APP ----------
class kurir_pengantaran extends StatelessWidget {
  final int id_pesanan;
  final String nama_pembeli;
  final String alamat_pembeli;
  final String total_belanja;
  final List<String> namaBarang;
  final String nomor_telepon;
  final String kuantitas;

  const kurir_pengantaran(
      {super.key,
      required this.nama_pembeli,
      required this.alamat_pembeli,
      required this.total_belanja,
      required this.namaBarang,
      required this.id_pesanan,
      required this.nomor_telepon,
      required this.kuantitas});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengantaran',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: DeliveryTrackingPage(
        id_pesanan: id_pesanan,
        nama_pembeli: nama_pembeli,
        alamat_pembeli: alamat_pembeli,
        total_belanja: total_belanja,
        namaBarang: namaBarang,
        nomor_telepon: nomor_telepon,
        kuantitas: kuantitas,
      ),
    );
  }
}

// ---------- PAGE ----------
class DeliveryTrackingPage extends StatelessWidget {
  final int id_pesanan;
  final String nama_pembeli;
  final String alamat_pembeli;
  final String total_belanja;
  final List<String> namaBarang;
  final String nomor_telepon;
  final String kuantitas;

  const DeliveryTrackingPage({
    super.key,
    required this.id_pesanan,
    required this.nama_pembeli,
    required this.alamat_pembeli,
    required this.total_belanja,
    required this.namaBarang,
    required this.nomor_telepon,
    required this.kuantitas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan #$id_pesanan',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text(
                        'Apakah Anda yakin ingin membatalkan pengantaran?'),
                    actions: [
                      TextButton(
                        child: const Text('Tidak'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // tutup dialog
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Ya',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // tutup dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyApp()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== Status bar =====
          Container(
            width: double.infinity,
            color: Colors.green[50],
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.motorcycle, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Sedang Diantar',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // ===== INFO BARANG =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Detail Barang',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: namaBarang.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = namaBarang[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Rp $total_belanja',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Total Kuantitas $kuantitas')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===== Customer card =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer Detail",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person, size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(nama_pembeli),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 4),
                        Expanded(child: Text(alamat_pembeli)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 4),
                        Text(nomor_telepon),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== Action buttons =====
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 4),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => debugPrint('Ke page chat'),
                    icon: const Icon(Icons.call, color: Colors.black),
                    label: const Text(
                      'Chat pelanggan',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: update status
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Status diperbarui: Pesanan selesai')));
                    },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Pesanan Selesai',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
