import 'package:flutter/material.dart';
import 'package:tubes_ppb/BarangPenjual.dart';
import 'package:tubes_ppb/api/api_getprodukbyID.dart';
import 'package:tubes_ppb/api/api_search.dart';
import 'package:tubes_ppb/component/product_card.dart';
import 'Data.dart' as data;

List<Map<String, dynamic>> searchResult = [];
bool isfound = false;

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  var searchController = TextEditingController();
  bool isLoading = false;

  void handleSearch() async {
    setState(() {
      isLoading = true;
    });

    final result = await searchbar(searchController.text);

    setState(() {
      searchResult = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: data.colorpalete[0]["green"],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                searchResult.clear();
              });
              Navigator.pop(context);
            },
          ),
          title: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(hintText: "Cari Barang....."),
            onSubmitted: (value) {
              handleSearch();
            },
          ),
        ),
        body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : searchResult.isEmpty
                    ? Center(child: Text("Belum ada hasil"))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // kolom
                          childAspectRatio: 0.75,
                        ),
                        itemCount: searchResult.length,
                        itemBuilder: (context, index) {
                          final produk = searchResult[index];
                          return InkWell(
                            onTap: () async {
                              final data = await getproduk(produk["id"]);
                              if (data.isNotEmpty) {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PageBarang(product: data)))
                                    .then((value) {
                                  if (value == true) {
                                    setState(() {});
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "gagal mendapatkan data")));
                                  }
                                });
                              }
                            },
                            child: ProductCardURL(
                                title: produk['nama_barang'],
                                imageUrl: produk["image_url"],
                                price: produk["harga"]),
                          );
                        },
                      )));
  }
}
