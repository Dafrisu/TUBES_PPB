import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:tubes_ppb/component/appbar.dart';
import 'package:tubes_ppb/api/api_keranjang.dart';
import 'package:tubes_ppb/notif.dart';
import 'package:tubes_ppb/orderpage.dart';
import 'Data.dart' as data;

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];
final List<Map<String, dynamic>> listdata = [
  {"asd": "asd"}
];

void sortcart() {
  // Salin `listcart` ke `sortedcart`
  data.sortedcart = List<Map<String, dynamic>>.from(data.listcart);

  // Urutkan `sortedcart` berdasarkan `id_penjual`
  data.sortedcart.sort((a, b) => a["id_penjual"].compareTo(b["id_penjual"]));
}

class cart extends StatelessWidget {
  const cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Cartpage(title: "KERANJANG");
  }
}

class Cartpage extends StatefulWidget {
  const Cartpage({super.key, required this.title});
  final String title;
  @override
  State<Cartpage> createState() => _cartpagestate();
}

class _cartpagestate extends State<Cartpage> with WidgetsBindingObserver {
  late Future<List<Map<String, dynamic>>> keranjangstandby;

// Method untuk memanggil ulang data
  void reloadKeranjang() {
    setState(() {
      keranjangstandby = keranjangpembeli(sessionId);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    keranjangstandby = keranjangpembeli(sessionId);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App goes to background
      keranjangstandby.then((data) {
        if (data.isNotEmpty) {
          notifservices()
              .shownotif(title: 'holy shit jalan', body: 'madep lurd');
        }
      });
    } else if (state == AppLifecycleState.resumed) {
      // App comes to foreground
      print('App is in the foreground.');
    }
  }

  @override
  Widget build(BuildContext context) {
    reloadKeranjang();
    return Scaffold(
      appBar: AppBarUMKMku(titleText: 'Keranjang'),
      body: FutureBuilder(
        future: keranjangstandby,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Keranjang Kosong'));
          }

          var data = snapshot.data!;
          return Column(
            children: [
              if (data.isEmpty)
                Expanded(
                    child: Center(
                  child: Text(
                    "Keranjang Kosong",
                    textAlign: TextAlign.center,
                  ),
                ))
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = data[index];
                        return Card(
                          child: GestureDetector(
                              // Tambahkan padding ke dalam Card
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  item["Produk"]["image_url"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item["Produk"]["nama_barang"]}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Varian: ini mungkin Varian produk',
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text('RP.${item["Produk"]["harga"]}'),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              try {
                                                var plus = await keranjangmin(
                                                    item['id_keranjang']);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            plus['message'])));
                                                setState(() {
                                                  keranjangstandby =
                                                      keranjangpembeli(
                                                          sessionId);
                                                });
                                              } catch (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'error : $error')));
                                              }
                                            },
                                            child: Icon(Icons.remove)),
                                        Text('QTY: ${item["kuantitas"]}'),
                                        TextButton(
                                            onPressed: () async {
                                              try {
                                                var plus = await keranjangplus(
                                                    item['id_keranjang']);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            plus['message'])));
                                                setState(() {
                                                  keranjangstandby =
                                                      keranjangpembeli(
                                                          sessionId);
                                                });
                                              } catch (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'error : $error')));
                                              }
                                            },
                                            child: Icon(Icons.add)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                        );
                      }),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderPage(isikeranjang: keranjangstandby),
              ),
            );
          },
          child: Text('Beli Sekarang')),
    );
  }
}
