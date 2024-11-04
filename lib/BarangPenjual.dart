import 'package:expandable_text/expandable_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/Data.dart' as dataprovider;
import 'package:tubes_ppb/LamanPenjual.dart';
import 'cart.dart';

class PageBarang extends StatefulWidget {
  final Map<String, dynamic> product;
  const PageBarang({Key? key, required this.product}) : super(key: key);

  @override
  State<PageBarang> createState() => _PageBarangState();
}

class _PageBarangState extends State<PageBarang> {
  // This widget is the root of your application./
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: dataprovider.colorpalete[0]["green"],
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => cart()));
                },
              )
            ]),
        body: SingleChildScrollView(
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
                child: widget.product["img"] != ''
                    ? Image.network(widget.product["img"])
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
                    Text(
                      widget.product["nama"],
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 30)),
                    ),
                    Text(
                      widget.product["harga"],
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
                  children: [
                    const Text('Deskripsi Barang'),
                    ExpandableText(
                      widget.product["deskripsi"],
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 14)),
                      textAlign: TextAlign.justify,
                      expandText: 'lebih banyak',
                      linkColor: Colors.black,
                      linkStyle: const TextStyle(fontWeight: FontWeight.bold),
                      collapseOnTextTap: true,
                    ),
                    const Text(
                      "Varian Produk",
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "sementara anggap varian",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
              // Seller Information
              Card(
                color: Colors.white,
                child: Center(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    title: Text('${widget.product["seller"]}'),
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWW0xcyFQPL6DIne-s-4nHzmBuIMCN12FioA&s"),
                      radius: 30,
                    ),
                    trailing: OutlinedButton(
                      onPressed: () {},
                      style:
                          OutlinedButton.styleFrom(minimumSize: Size(30, 40)),
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
                                  )));
                    },
                  ),
                ),
              ),
              const Card(
                child: ListTile(
                  minTileHeight: 100,
                  title: Text(
                    'test Ulasan',
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: const Text(
                    'INI ULASAN PEMBELIINI ULASAN PEMBELIINI ULASAN PEMBELIINI ULASAN PEMBELIINI ULASAN PEMBELIINI ULASAN PEMBELI',
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: SizedBox(
                    width: 90,
                    height: 90,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 45,
                      child: Text(
                        "avatarrr",
                        style: TextStyle(
                            fontSize: 18), // Ukuran teks di dalam avatar
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 1))),
          child: BottomAppBar(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //const Padding(padding: EdgeInsets.only(left: 30)),
                OutlinedButton(
                  iconAlignment: IconAlignment.start,
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorpalete[0]["green"]),
                      minimumSize: Size(170, 120),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () {},
                  child: Text(
                    'Beli Sekarang',
                    style: TextStyle(color: colorpalete[0]["green"]),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    bool itemFound = false;

                    dataprovider.listcart.forEach((item) {
                      if (item["nama"] == widget.product["nama"]) {
                        item["qty"] += 1;
                        itemFound = true;
                      }
                    });

                    if (!itemFound) {
                      var newItem = Map<String, dynamic>.from(widget.product);
                      newItem["qty"] = 1;
                      dataprovider.listcart.add(newItem);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorpalete[0]["green"],
                      minimumSize: Size(170, 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: const Text(
                    "+Keranjang",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
