import 'package:expandable_text/expandable_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/Data.dart' as dataprovider;
import 'package:tubes_ppb/api/api_bookmark.dart';
import 'package:tubes_ppb/api/api_getprodukbyID.dart';
import 'package:tubes_ppb/api/api_getprofileumkm.dart';
import 'package:tubes_ppb/LamanPenjual.dart';
import 'package:tubes_ppb/api/api_keranjang.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:tubes_ppb/api/api_service.dart';
import 'package:tubes_ppb/component/review_card.dart';
import 'cart.dart';
import 'package:tubes_ppb/Chat/chatPembeliUmkm.dart';
import 'api/api_ulasans.dart';

class PageBarang extends StatefulWidget {
  final Map<String, dynamic> product;
  const PageBarang({super.key, required this.product});
  @override
  State<PageBarang> createState() => _PageBarangState();
}

class _PageBarangState extends State<PageBarang> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ulasanController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  // This widget is the root of your application./

  Future<void> refreshbarang() async {
    setState(() {});
  }

  void _showAddUlasanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Ulasan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _ulasanController,
                  decoration: const InputDecoration(labelText: 'Ulasan'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _ratingController,
                  decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_usernameController.text.isEmpty ||
                    _ulasanController.text.isEmpty ||
                    _ratingController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }
                final rating = double.tryParse(_ratingController.text);
                if (rating == null || rating < 0 || rating > 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rating harus antara 0 dan 5')),
                  );
                  return;
                }

                final result = await postUlasan(
                  id_pembeli: sessionId,
                  id_produk: widget.product['id'],
                  username: _usernameController.text,
                  ulasan: _ulasanController.text,
                  rating: rating,
                );

                if (result['message'] == null) {
                  // Success
                  setState(() {}); // Refresh the reviews list
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ulasan berhasil ditambahkan')),
                  );
                } else {
                  // Error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'])),
                  );
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("last batch: $lastbatch");
    return Scaffold(
      backgroundColor: Colors.white,

      // for appbar purpose
      appBar: AppBar(
          backgroundColor: dataprovider.colorpalete[0]["green"],

          // back button
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              )),

          // cart button
          actions: <Widget>[
            FutureBuilder<Map<String, dynamic>>(
                future: checkbookmark(widget.product['id'], sessionId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.favorite_border,
                          size: 30,
                        ));
                  } else if (snapshot.hasError) {
                    return IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.close,
                          size: 30,
                        ));
                  }

                  bool isbookmarked = snapshot.data!["bookmarked"];
                  return IconButton(
                    onPressed: () async {
                      if (isbookmarked) {
                        await deletebookmark(sessionId, widget.product['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bookmark dihapus!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        await addtobookmark(sessionId, widget.product['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Berhasil ditambahkan ke bookmark!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                      refreshbarang();
                    },
                    icon: Icon(
                        isbookmarked ? Icons.favorite : Icons.favorite_border),
                    color: isbookmarked ? Colors.red : Colors.black,
                    iconSize: 30,
                  );
                }),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => cart()));
              },
            ),
          ]),

      // Body (List view sortalike)
      body: FutureBuilder(
          future: getproduk(widget.product['id']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            var data = snapshot.data!;
            final ID_umkm = data['id_umkm'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Image Container
                  Container(
                    height: 400,
                    width: 550,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: data["image_url"] != '' || data["image_url"] != null
                        ? Image.network(data["image_url"])
                        : Icon(Icons.image, size: 100),
                  ),

                  // Name and Price
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.grey, offset: Offset(0, 1.5))
                      ],
                      color: Colors.white,
                    ),
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          data["nama_barang"],
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 30)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'RP.${data["harga"]}',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 20)),
                        )
                      ],
                    ),
                  ),

                  // Description and Variants
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi Barang',
                          textAlign: TextAlign.start,
                        ),
                        ExpandableText(
                          data["deskripsi_barang"],
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 14)),
                          textAlign: TextAlign.justify,
                          expandText: 'lebih banyak',
                          linkColor: dataprovider.colorpalete[0]["green"],
                          linkStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          collapseOnTextTap: true,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Stok",
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${data["stok"]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),

                  // Seller Information
                  FutureBuilder(
                      future: getumkm(ID_umkm),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No data available'));
                        }
                        final umkm = snapshot.data!;
                        return Card(
                          color: Colors.white,
                          child: Center(
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
                              title: Text(
                                  '${umkm['username']}'), // this NYI Text('${widget.product["seller"]}'),
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWW0xcyFQPL6DIne-s-4nHzmBuIMCN12FioA&s"),
                                radius: 30,
                              ),
                              trailing: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PembeliUmkmChatPage(
                                        sender: umkm['username'],
                                        id_umkm: ID_umkm,
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                    minimumSize: Size(30, 40)),
                                child: const Text(
                                  "Hubungi Penjual",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PagePenjual(
                                            title: '',
                                            id_umkm: ID_umkm,
                                            username: umkm['username'])));
                              },
                            ),
                          ),
                        );
                      }),
                  // card untuk ulasan (might change the listtile cuz why not?)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ulasan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _showAddUlasanDialog,
                      child: const Text('Tambah Ulasan'),
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchUlasansByProdukId(widget.product['id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No data available'));
                        }
                        var data = snapshot.data!;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ...data.map((review) {
                                return ReviewCard(
                                  username: review['username'],
                                  rating: review['rating'],
                                  tanggalUlasan: review['tanggalUlasan'],
                                  ulasan: review['ulasan'],
                                  namaProduk: review['namaProduk'],
                                  imgSource: review['imgSource'],
                                  fotoProfil: review['fotoProfil'] ??
                                      'assets/Profilepic.png',
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            );
          }),

      //Navbar bottom (navbar di bawah untuk keranjang / beli sekarang)
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 1))),
        child: BottomAppBar(
          color: Colors.white,
          child: FutureBuilder(
              future: getproduk(widget.product['id']),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Menampilkan pesan error
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No data available'); // Tidak ada data
                }
                final databarang = snapshot.data!;
                // button untuk +keranjang
                return ElevatedButton(
                  onPressed: () async {
                    final response = await addtoKeranjang(
                        sessionId, databarang['id'], lastbatch);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${response['message']}')));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorpalete[0]["green"],
                      minimumSize: Size(170, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: Text(
                    "+keranjang",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
