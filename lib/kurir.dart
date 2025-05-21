import 'package:flutter/material.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/kurir_pengantaran.dart';
import 'package:tubes_ppb/profile_kurir.dart';
import 'Chat/chatKurirPembeli.dart';
import 'Chat/lib/api/Raphael_api_chat.dart';

class Kurir extends StatefulWidget {
  const Kurir({super.key});

  @override
  _KurirState createState() => _KurirState();
}

class _KurirState extends State<Kurir> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeliveryPage(),
    );
  }
}

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  String namaKurir = 'Kurir';
  int idUmkm = 0;
  String statusKurir = '';
  String namaUmkm = '';
  String nomor_telepon = '';
  @override
  void initState() {
    super.initState();
    _fetchKurirData();
  }

  // Memperbarui fungsi fetch untuk mendapatkan id_umkm dan nama_kurir
  Future<void> _fetchKurirData() async {
    Map<String, dynamic> kurirData = await fetchKurirData();
    setState(() {
      namaKurir = kurirData['nama_kurir'];
      idUmkm = kurirData['id_umkm'];
      statusKurir = kurirData['status'] ?? 'Tidak diketahui';
      namaUmkm = kurirData['UMKM']['nama_usaha'] ?? 'Tidak diketahui';
      nomor_telepon = kurirData['nomor_telepon'] ?? 'Tidak diketahui';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $namaKurir.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              'Status: $statusKurir',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 101, 136, 100),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.mail_outline,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InboxPageKurirPembeli(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah Anda yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        child: const Text("Batal"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Ya"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KurirProfilePage(
                    nama: namaKurir,
                    noTelp: nomor_telepon,
                    namaMitra: namaUmkm,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan yang harus diantar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (statusKurir == 'Belum terdaftar')
              Center(
                child: Text('Silahkan tunggu konfirmasi dari UMKM'),
              ),
            if (statusKurir == 'Dipecat')
              Center(
                child: Text('Silahkan ajukan lamaran ke UMKM'),
              ),
            if (statusKurir == 'Terdaftar')
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  // Panggil getPesananDiterima dengan id_umkm yang diperoleh
                  future: getPesananDiterima(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No orders available.'));
                    }

                    final orders = snapshot.data!.map((order) {
                      return OrderItemData.fromJson(order);
                    }).toList();

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return OrderCard(order: order);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OrderItemData {
  final int idPesanan;
  final String statusPesanan;
  final String namaBarang;
  final String kuantitasBarang;
  final String totalBelanja;
  final String alamatPembeli;
  final String nomor_telepon;
  final String nama_lengkap;
  final List<String> listBarang;

  OrderItemData({
    required this.idPesanan,
    required this.statusPesanan,
    required this.namaBarang,
    required this.kuantitasBarang,
    required this.totalBelanja,
    required this.alamatPembeli,
    required this.nomor_telepon,
    required this.nama_lengkap,
    required this.listBarang,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      idPesanan: json['id_batch'],
      statusPesanan: json['status_pesanan'],
      namaBarang: json['nama_barang'],
      kuantitasBarang: json['kuantitas'],
      totalBelanja: json['total_belanja'],
      alamatPembeli: json['alamat_pembeli'],
      nomor_telepon: json['nomor_telepon'],
      nama_lengkap: json['nama_lengkap'],
      listBarang: json['nama_barang'].split(','),
    );
  }
}

class OrderCard extends StatefulWidget {
  final OrderItemData order;
  const OrderCard({super.key, required this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isPressed = false;

  void _onButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin mengambil pesanan ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ya"),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => kurir_pengantaran(
                      nama_pembeli: widget.order.nama_lengkap,
                      alamat_pembeli: widget.order.alamatPembeli,
                      total_belanja: widget.order.totalBelanja,
                      namaBarang: widget.order.listBarang,
                      id_pesanan: widget.order.idPesanan,
                      nomor_telepon: widget.order.nomor_telepon,
                      kuantitas: widget.order.kuantitasBarang,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.namaBarang,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Jumlah: ${widget.order.kuantitasBarang}'),
                Text(widget.order.alamatPembeli),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isPressed ? Colors.green : const Color(0xFF7B5400),
            ),
            child: Text(
              isPressed ? 'Selesai' : 'Diterima',
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }
}
