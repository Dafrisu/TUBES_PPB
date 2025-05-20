import 'package:flutter/material.dart';
import 'package:tubes_ppb/kurir.dart';

void main() {
  runApp(const kurir_pengantaran());
}

class OrderItem {
  final String name;
  final int qty;
  final int price;

  OrderItem(this.name, this.qty, this.price);
}

// ---------- APP ----------
class kurir_pengantaran extends StatelessWidget {
  const kurir_pengantaran({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengantaran',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: DeliveryTrackingPage(
        orderId: 'INV‑23045',
        customerName: 'Daffa Pratama',
        customerAddress: 'Jl. Merdeka No. 10, Bandung',
        customerPhone: '0812‑3456‑7890',
        items: [
          OrderItem('Ayam Geprek Krispi', 2, 23000),
          OrderItem('Es Kopi Susu', 1, 15000),
          OrderItem('Tahu Crispy', 3, 10000),
        ],
      ),
    );
  }
}

// ---------- PAGE ----------
class DeliveryTrackingPage extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final List<OrderItem> items;

  const DeliveryTrackingPage({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.items,
  });

  int get total =>
      items.fold(0, (sum, e) => sum + e.price * e.qty); // hitung total

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan #$orderId',
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
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis)),
                                Text('x${item.qty}'),
                                Text('Rp ${item.price * item.qty}'),
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
                          Text('Rp $total',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
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
                          child: Text(customerName),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 4),
                        Expanded(child: Text(customerAddress)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 4),
                        Text(customerPhone),
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
