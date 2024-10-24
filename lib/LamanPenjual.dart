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
    "deskripsi":
        "3 Form Factor to Choose Stellar Edition merupakan seri keyboard gaming mechanical ATOM PRO yang terdiri dari tiga produk dengan layout yang berbeda-beda. ATOM PRO63 MK912 dengan layout 60% ATOM PRO83 MK913 dengan layout 75% ATOM PRO96 MK914 dengan layout 95%. (Coming Soon)"
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
      home: const MyHomePage(title: 'INI LAMAN PENJUAL'),
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
        appBar: AppBar(
          backgroundColor: colorpalete[0]["green"],
          leading: const Icon(Icons.arrow_back_ios_new),
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const cart()));
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
                          style: const TextStyle(
                              fontSize: 30, fontFamily: "comic-sans"),
                        ),
                        Text(
                          listdata[index]["harga"],
                          style: const TextStyle(
                              fontSize: 20, fontFamily: "comicsans"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          listdata[index]["deskripsi"],
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }
}
