import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/login.dart';
import 'Chat/chatKurirPembeli.dart';
import 'Chat/lib/api/Raphael_api_chat.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halo, $namaKurir.',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            const SizedBox(height: 20),
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
  final int kuantitasBarang;
  final String totalBelanja;
  final String alamatPembeli;

  OrderItemData({
    required this.idPesanan,
    required this.statusPesanan,
    required this.namaBarang,
    required this.kuantitasBarang,
    required this.totalBelanja,
    required this.alamatPembeli,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      idPesanan: json['id_batch'],
      statusPesanan: json['status_pesanan'],
      namaBarang: json['nama_barang'],
      kuantitasBarang: json['kuantitas'],
      totalBelanja: json['total_belanja'],
      alamatPembeli: json['alamat_pembeli'],
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
          content: const Text(
              "Apakah Anda yakin ingin menandai pesanan ini sebagai selesai?"),
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
                Navigator.of(context).pop();

                await updateStatusPesananSelesai(widget.order.idPesanan);

                setState(() {
                  isPressed = true;
                });
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
