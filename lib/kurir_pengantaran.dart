import 'package:flutter/material.dart';
import 'package:tubes_ppb/kurir.dart';
import 'Chat/chatKurirPembeli.dart'; // Import chat class
import 'Chat/lib/api/Raphael_api_chat.dart'; // Import API for chat

void main() {
  runApp(const kurir_pengantaran(
    nama_pembeli: 'ELA TERLALU SPIT ayayay',
    alamat_pembeli: '123 Main St',
    total_belanja: '0',
    namaBarang: ['Gurame Bakar'],
    id_pesanan: ['1'],
    nomor_telepon: '1234567890',
    kuantitas: '',
    id_pembeli: 1,
    id_batch: 0,
  ));
}

// ---------- APP ----------
class kurir_pengantaran extends StatelessWidget {
  final List<String> id_pesanan;
  final String nama_pembeli;
  final String alamat_pembeli;
  final String total_belanja;
  final List<String> namaBarang;
  final String nomor_telepon;
  final String kuantitas;
  final int id_pembeli;
  final int id_batch;

  const kurir_pengantaran({
    super.key,
    required this.nama_pembeli,
    required this.alamat_pembeli,
    required this.total_belanja,
    required this.namaBarang,
    required this.id_pesanan,
    required this.nomor_telepon,
    required this.kuantitas,
    required this.id_pembeli,
    required this.id_batch,
  });

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
        id_pembeli: id_pembeli,
        id_batch: id_batch,
      ),
    );
  }
}

// ---------- PAGE ----------
class DeliveryTrackingPage extends StatefulWidget {
  final List<String> id_pesanan;
  final String nama_pembeli;
  final String alamat_pembeli;
  final String total_belanja;
  final List<String> namaBarang;
  final String nomor_telepon;
  final String kuantitas;
  final int id_pembeli;
  final int id_batch;

  const DeliveryTrackingPage({
    super.key,
    required this.id_pesanan,
    required this.nama_pembeli,
    required this.alamat_pembeli,
    required this.total_belanja,
    required this.namaBarang,
    required this.nomor_telepon,
    required this.kuantitas,
    required this.id_pembeli,
    required this.id_batch,
  });

  @override
  _DeliveryTrackingPageState createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  // Variable to store the pembeli ID
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _fetchPembeliIdFromOrderInfo();
  }

  // // Method to fetch pembeli ID from order information
  // Future<void> _fetchPembeliIdFromOrderInfo() async {
  //   try {
  //     // First attempt: Try to find the pembeli ID directly from chat history
  //     final chatMessages = await fetchchatkurir();

  //     // Look for a match by nama_lengkap
  //     final matchedMessage = chatMessages.firstWhere(
  //       (message) => message['nama_lengkap'] == widget.nama_pembeli,
  //       orElse: () => {},
  //     );

  //     if (matchedMessage.containsKey('id_pembeli') &&
  //         matchedMessage['id_pembeli'] != null) {
  //       setState(() {
  //         id_pembeli = matchedMessage['id_pembeli'];
  //         isLoading = false;
  //       });
  //       return;
  //     }

  //     // If we can't find it in chat history, fall back to a direct API call
  //     // Note: You'll need to implement this API endpoint or method
  //     // This is a placeholder for demonstration
  //     // In a real app, you would make an API call to get the pembeli ID based on nomor_telepon or nama_pembeli

  //     // For now, as a fallback, use the order ID (this is just a placeholder)
  //     setState(() {
  //       id_pembeli = widget.id_pesanan;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching pembeli ID: $e');
  //     setState(() {
  //       // Fallback to order ID as a last resort
  //       id_pembeli = widget.id_pesanan;
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan #${widget.id_pesanan}',
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
                                builder: (context) => const Kurir()),
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
                          itemCount: widget.namaBarang.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = widget.namaBarang[index];
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
                          Text('Rp ${widget.total_belanja}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Total Kuantitas ${widget.kuantitas}')
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
                          child: Text(widget.nama_pembeli),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 4),
                        Expanded(child: Text(widget.alamat_pembeli)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 4),
                        Text(widget.nomor_telepon),
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
                    onPressed: isLoading
                        ? null // Disable the button while loading
                        : () {
                            // Navigate to the chat page with the customer
                            if (widget.id_pembeli != 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KurirPembeliChatPage(
                                    sender: widget.nama_pembeli,
                                    id_pembeli: widget.id_pembeli,
                                  ),
                                ),
                              );
                            } else {
                              // Show an error message if pembeli ID is not available
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Tidak dapat memulai chat, ID pembeli tidak ditemukan'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    icon: isLoading
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black54,
                            ),
                          )
                        : const Icon(Icons.chat, color: Colors.black),
                    label: Text(
                      isLoading ? 'Memuat...' : 'Chat pelanggan',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                                'Update Status Pesanaan ini sebagai selesai?'),
                            actions: [
                              TextButton(
                                child: const Text('Tidak'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // tutup dialog
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                child: const Text('Ya',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Kurir()),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Status diperbarui: Pesanan selesai')));
                                  updateStatusPesananSelesai(widget.id_batch);
                                },
                              ),
                            ],
                          );
                        },
                      );
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
