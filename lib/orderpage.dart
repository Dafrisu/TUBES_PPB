import 'package:flutter/material.dart';
import 'Data.dart' as data;

void main() {
  runApp(Order());
}

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text('Pesanan Anda'),
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
                    'Nama Alamat',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Alamat',
                    style: TextStyle(fontSize: 16),
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
            itemCount: 5,
            itemBuilder: (context, index) {
              if (data.listdata.isEmpty) {
                return Center(child: Text('Data kosong'));
              }
              final item = data.listdata[index];
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
                          Text(
                            'Varian: ini mungkin Varian produk',
                            style: TextStyle(fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Container(
                            margin: EdgeInsets.only(right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('RP.${item["harga"]}'),
                                Text('QTY : ')
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
                                  'harga',
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
              children: [Text('TOTAL'), Text('harga')],
            ),
          )
        ],
      ),
      bottomNavigationBar: OutlinedButton(
        onPressed: () {},
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
