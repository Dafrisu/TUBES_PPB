import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riwayat Pembelian',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RiwayatPembelian(),
    );
  }
}

class RiwayatPembelian extends StatefulWidget {
  const RiwayatPembelian({super.key});

  @override
  State<RiwayatPembelian> createState() => _RiwayatPembelianState();
}

class _RiwayatPembelianState extends State<RiwayatPembelian> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dataPesanan = [
      {
        "namaBarang": "Logitech G102",
        "jumlah": "1",
        "totalHarga": "234.000",
        "gambar":
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBJb4gBPpnMjFV1Jx61iUcmIiI9IdzeHNAZQ&s',
        "alamat": "Jl.Sukabirus, Kontrakan Suka suka No. 07"
      },
      {
        "namaBarang": "Razer DeathAdder Essential",
        "jumlah": "2",
        "totalHarga": "450.000",
        "gambar":
            'https://images.tokopedia.net/img/cache/700/OJWluG/2022/10/4/8f60ad91-7bbd-44da-ac0e-f3f48bf7d220.jpg',
        "alamat": "Jl. Setiabudi, Kompleks Permata Hijau No. 15"
      },
      {
        "namaBarang": "SteelSeries Arctis 1",
        "jumlah": "1",
        "totalHarga": "620.000",
        "gambar":
            'https://images.tokopedia.net/img/cache/500-square/product-1/2020/7/3/84444824/84444824_4fc67311-7c81-42b9-960a-2919f20aa653_700_700',
        "alamat": "Jl. Merdeka, Apartemen Merah Putih No. 10"
      },
      {
        "namaBarang": "ASUS TUF Gaming H3",
        "jumlah": "3",
        "totalHarga": "990.000",
        "gambar":
            'https://down-id.img.susercontent.com/file/sg-11134201-23020-5hne2qdw7wnv3c',
        "alamat": "Jl. Braga, Gedung Harmony Suites No. 3"
      },
    ];
    final List<String> events = [
      'Pesanan Dikonfirmasi',
      'Pesanan Diproses',
      'Pesanan Dikemas',
      'Pesanan Dikirim',
      'Pesanan Diterima',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 101, 136, 100),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dataPesanan.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color.fromARGB(255, 101, 136, 100))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(dataPesanan[index]['gambar']),
                      radius: 30,
                    ),
                    title: Text(dataPesanan[index]['namaBarang']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            'Total Harga : ${dataPesanan[index]['totalHarga']}'),
                        Text('Jumlah Barang : ${dataPesanan[index]['jumlah']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Color.fromARGB(255, 101, 136, 100),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              children: [
                                FixedTimeline.tileBuilder(
                                  builder:
                                      TimelineTileBuilder.connectedFromStyle(
                                    contentsAlign: ContentsAlign.reverse,
                                    oppositeContentsBuilder: (context, index) =>
                                        Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('22/12/2021'),
                                    ),
                                    contentsBuilder: (context, index) => Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Pesanan Dikemas'),
                                      ),
                                    ),
                                    connectorStyleBuilder: (context, index) =>
                                        ConnectorStyle.solidLine,
                                    indicatorStyleBuilder: (context, index) =>
                                        IndicatorStyle.dot,
                                    itemCount: 4,
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            child: Text(
                                              "Informasi Riwayat Pembelian",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 136, 100),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Column(children: [
                                      //   Center(
                                      //     child: Text(
                                      //       "Invoice : INV/20220713/DRS/91207310",
                                      //       style: TextStyle(
                                      //         fontSize: 12,
                                      //       ),
                                      //     ),
                                      //   )
                                      // ]),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        dataPesanan[index]
                                                            ['gambar']),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Detail Produk :",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 101, 136, 100),
                                                      ),
                                                    ),
                                                    Text(
                                                      dataPesanan[index]
                                                          ['namaBarang'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                        'Jumlah Barang : ${dataPesanan[index]['jumlah']}'),
                                                    Text(
                                                        'Total harga : ${dataPesanan[index]['jumlah']} x ${dataPesanan[index]['totalHarga']}'),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2),
                                            child: Text(
                                              "Detail Pengantaran",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 101, 136, 100),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Alamat Pengiriman :',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    dataPesanan[index]
                                                        ['alamat'],
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
