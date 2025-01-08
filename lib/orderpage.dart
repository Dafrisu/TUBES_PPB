import 'package:flutter/material.dart';
import 'package:tubes_ppb/edit_profile.dart';
import 'Data.dart' as data;

void main() {
  runApp(Order());
}

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int totalbelanja = 0;
  int totalsemuanya = 0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    int total = 0;
    for (var item in data.listcart) {
      int price = int.parse(item['harga'].toString().replaceAll('.', ''));
      int quantity = item['Quantity'];
      total += price * quantity;
    }
    setState(() {
      totalbelanja = total;
      totalsemuanya = total + 15000 + 2000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text('Pesanan Anda', style: TextStyle(color: Colors.white)),
        backgroundColor: data.colorpalete[0]['green'],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // alamat
          Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat Pengantaran',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Alamat',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Color.fromARGB(255, 101, 136, 100)),
                        ),
                        child: Text(
                          'Ganti Alamat',
                          style: TextStyle(
                              color: Color.fromARGB(255, 101, 136, 100),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // produk yang akan di order
          SizedBox(
            height: 5,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: data.listcart.length,
            itemBuilder: (context, index) {
              if (data.listcart.isEmpty) {
                return Center(child: Text('Data kosong'));
              }

              final item = data.listcart[index];
              print(totalbelanja);
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
                        item["img"],
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
                            '${item["nama"]}\n',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          SizedBox(height: 5),
                          Container(
                            margin: EdgeInsets.only(right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('RP.${item["harga"]}'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (item["Quantity"] > 1) {
                                            item["Quantity"]--;
                                          }
                                        });
                                      },
                                    ),
                                    Text('QTY : ${item["Quantity"]}'),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          item["Quantity"]++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
              );
            },
          )),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Pembayaran',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Harga Produk',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Rp. $totalbelanja',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ongkos',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Rp. 15000',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Biaya Aplikasi',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Rp. 2000',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('TOTAL'), Text('Rp. $totalsemuanya')],
            ),
          )
        ],
      ),
      bottomNavigationBar: OutlinedButton(
        onPressed: () {
          // Navigator.push(context, EditProfile(userId: userId, onProfileUpdated: onProfileUpdated))
        },
        style: OutlinedButton.styleFrom(
            backgroundColor: data.colorpalete[0]['green'],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Text(
          'Beli Sekarang',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
