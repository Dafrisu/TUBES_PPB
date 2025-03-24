import "package:flutter/material.dart";
import "package:tubes_ppb/BarangPenjual.dart";
import "package:tubes_ppb/api/api_getprodukbyID.dart";
import 'Data.dart' as data;
import "package:tubes_ppb/api/api_bookmark.dart";
import "package:tubes_ppb/api/api_loginPembeli.dart";
import "package:tubes_ppb/component/product_card.dart";

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: data.colorpalete[0]["green"],
        title: Text(
          'Wishlist',
          style: TextStyle(color: Colors.white, fontFamily: 'roboto'),
        ),
      ),
      body: FutureBuilder(
        future: getbookmark(sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          final data = snapshot.data!;

          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // kolom
                childAspectRatio: 0.75,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final bookmark = data[index];
                final product = bookmark["Produk"];
                print(bookmark);
                return InkWell(
                  onTap: () async {
                    final data = await getproduk(bookmark["id_produk"]);
                    if (data.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PageBarang(product: data))).then((value) {
                        if (value == true) {
                          setState(() {});
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("gagal mendapatkan data")));
                    }
                  },
                  child: ProductCardURL(
                      title: product['nama_barang'],
                      imageUrl: product["image_url"],
                      price: product["harga"]),
                );
              });
        },
      ),
    );
  }
}
