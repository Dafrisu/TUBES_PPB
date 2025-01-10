import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tubes_ppb/api/api_getprodukUMKM.dart';
import 'package:tubes_ppb/pages/profil_umkm.dart';
import 'component/mini_profile_with_rating.dart';
import 'package:tubes_ppb/BarangPenjual.dart';
import 'Data.dart' as data;
import 'cart.dart';

class PagePenjual extends StatefulWidget {
  final int id_umkm;
  final String username;
  const PagePenjual(
      {super.key,
      required this.title,
      required this.id_umkm,
      required this.username});
  final String title;
  @override
  State<PagePenjual> createState() => _PagePenjualState();
}

class _PagePenjualState extends State<PagePenjual> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: data.colorpalete[0]["green"],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => cart()));
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilUMKM(
                    idUMKM: widget.id_umkm,
                  ),
                ),
              );
            },
            child: MiniProfile(username: widget.username, rating: 5),
          ),
          FutureBuilder(
              future: getprodukUMKM(widget.id_umkm),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }
                var produk = snapshot.data!;
                Future<void> setbarang() async {
                  setState(() {
                    produk = snapshot.data!;
                  });
                }

                return Expanded(
                  child: LiquidPullToRefresh(
                    onRefresh: setbarang,
                    showChildOpacityTransition: false,
                    color: Colors.white24,
                    backgroundColor: data.colorpalete[0]["green"],
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 kotak dalam satu baris
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            3 / 4, // Rasio lebar/tinggi dari tiap item
                      ),
                      itemCount: produk.length,
                      itemBuilder: (context, index) {
                        final item = produk[index];
                        return InkWell(
                            onTap: () {
                              // Mengarahkan ke halaman detail produk
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PageBarang(product: item),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gambar produk
                                  Expanded(
                                    child: item['image_url'] != ''
                                        ? Image.network(
                                            item['image_url'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 100,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Icon(Icons.image_not_supported),
                                          )
                                        : const Icon(Icons.image,
                                            size:
                                                100), // Placeholder jika img kosong
                                  ),
                                  SizedBox(height: 8),
                                  // Nama produk
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      item['nama_barang'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  // Harga produk
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'RP.${item['harga']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                );
              })
        ],
      )),
    );
  }
}
