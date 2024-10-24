import 'package:expandable_text/expandable_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'cart.dart';

void main() {
  runApp(const MyApp());
}

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];
final List<Map<String, dynamic>> listdata = [
  {
    "nama":
        "Fantech ATOM PRO SERIES Wireless Keyboard Mechanical Gaming Hotswap",
    "harga": "RP.300.000",
    "seller": "Asep Montir Gamink",
    "deskripsi": "3 Form Factor to Choose Stellar Edition\n merupakan seri keyboard gaming mechanical ATOM PRO "
        "yang terdiri dari tiga produk dengan layout yang berbeda-beda. ATOM PRO63 MK912 dengan layout 60% "
        "ATOM PRO83 MK913 dengan layout 75% ATOM PRO96 MK914 dengan layout 95%. (Coming Soon)\n\n"
        "Tri-Mode Connection ATOM PRO\n telah dilengkapi dengan fitur 3 mode konektivitas. Mulai dari koneksi wired menggunakan kabel, wireless 2.4GHz yang stabil, hingga Bluetooth yang bisa disambungkan ke 3 device sekaligus.\n\n"
        "Hot Swappable Switch & Per-Key RGB Lighting\n Telah dibekali dengan switch yang hot swappable dan kompatibel dengan mechanical switch 5 pin yang memudahkan kamu untuk memasang dan mengganti switch. Selain itu juga terdapat fitur per-key RGB lighting yang siap meningkatkan tampilan keyboard jadi semakin memukau."
  }
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: colorpalete[0]["green"],
          leading: const Icon(Icons.arrow_back_ios_new),
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => cart()));
              },
            )
          ],
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: listdata.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 400,
                    width: 550,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.black,
                        ))),
                    child: Image.network(
                        'https://images.tokopedia.net/img/cache/900/VqbcmM/2024/3/28/79bd45c3-03ef-4e06-85cf-d8c2987010f6.jpg'),
                  ),
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
                          listdata[index]["nama"],
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 30)),
                        ),
                        Text(
                          listdata[index]["harga"],
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.grey,
                        ))),
                    child: Column(
                      children: [
                        const Text('Deskripsi Barang'),
                        ExpandableText(
                          listdata[index]["deskripsi"],
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(fontSize: 14)),
                          textAlign: TextAlign.justify,
                          expandText: 'lebih banyak',
                          linkColor: Colors.black,
                          linkStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          collapseOnTextTap: true,
                        ),
                        const Text(
                          "Varian Produk",
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "sementara anggap varian",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('${listdata[0]["seller"]}'),
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
                      subtitle: const Text(
                          'asdfasdasfasfasfasfasdfasdasfasfasfasfasdfasdasfasfasfasf'),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Ulasan Pembeli",
                      style: TextStyle(fontSize: 15),
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
                        width: 90, // Sesuaikan ukuran dengan keinginan
                        height: 90, // Sesuaikan ukuran dengan keinginan
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 45,
                          child: Text(
                            "avatarrr",
                            style: TextStyle(
                                fontSize: 18), // Ukuran teks di dalam avatar
                          ), // Sesuaikan radius
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
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
                  onPressed: () {},
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
