import "package:flutter/material.dart";
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
                  onTap: () {},
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
