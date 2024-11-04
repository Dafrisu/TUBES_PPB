import 'package:flutter/material.dart';
import 'Data.dart' as data;

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];
final List<Map<String, dynamic>> listdata = [
  {"asd": "asd"}
];

// class cart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'cart',
//       home: Cartpage(title: 'ini cart page'),
//     );
//   }
// }

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

class _cartpagestate extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: colorpalete[0]["green"],
      ),
      body: Column(
        children: [
          if (data.listcart.isEmpty)
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
                  itemCount: data.listcart.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: GestureDetector(
                          // Tambahkan padding ke dalam Card
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              data.listcart[index]["img"],
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
                                  '${data.listcart[index]["nama"]}',
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
                                Text('${data.listcart[index]["harga"]}'),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          if (data.listcart[index]["qty"] > 1) {
                                            setState(() {
                                              data.listcart[index]["qty"] -= 1;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.remove)),
                                    Text('QTY: ${data.listcart[index]["qty"]}'),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            data.listcart[index]["qty"] += 1;
                                          });
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
      ),
    );
  }
}
