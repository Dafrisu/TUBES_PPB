import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'component/appbar.dart';
import 'api/Dafa_api_getriwayaPembelian.dart';

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
    Future<List<Map<String, dynamic>>> dataPesanan = fetchriwayatpembelian();
    Future<List<Map<String, dynamic>>> dataPesananAktif =
        fetchpesananaktifpembeli();

    final List<String> events = [
      'Pesanan Masuk dan sedang diproses',
      'Pesanan Diterima dan sedang diproses',
      'Pesanan Sedang Diantar',
      'Pesanan Selesai',
    ];

    int counter = 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Riwayat Pembelian'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  dataPesanan = fetchriwayatpembelian();
                });
              },
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(
              text: 'Riwayat',
            ),
            Tab(
              text: 'Pesanan Aktif',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: dataPesanan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    String imageUrl = data[index]['image_url'] ?? '';
                    print(imageUrl);
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Color.fromARGB(255, 101, 136, 100))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data[index]['image_url']),
                              radius: 30,
                            ),
                            title: Text(data[index]['nama_barang']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    'Total Harga : ${data[index]['total_harga']}'),
                                Text(
                                    'Jumlah Barang : ${data[index]['kuantitas_barang']}'),
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
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SimpleDialog(
                                        children: [
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              child: Text(
                                                "Informasi Riwayat Pengantaran",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 101, 136, 100),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FixedTimeline.tileBuilder(
                                            builder: TimelineTileBuilder
                                                .connectedFromStyle(
                                              contentsAlign:
                                                  ContentsAlign.reverse,
                                              contentsBuilder:
                                                  (context, index) => Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(events[index]),
                                                ),
                                              ),
                                              connectorStyleBuilder:
                                                  (context, index) =>
                                                      ConnectorStyle.solidLine,
                                              indicatorStyleBuilder:
                                                  (context, index) =>
                                                      IndicatorStyle.dot,
                                              itemCount: 4,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Informasi Riwayat Pembelian",
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              101,
                                                              136,
                                                              100),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  data[index][
                                                                      'image_url']),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10,
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Detail Produk :",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          101,
                                                                          136,
                                                                          100),
                                                                ),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                    'nama_barang'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                  'Jumlah Barang : ${data[index]['kuantitas_barang']}'),
                                                              Text(
                                                                  'Total harga : ${data[index]['total_harga']}'),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 2),
                                                      child: Text(
                                                        "Detail Pengantaran",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              101,
                                                              136,
                                                              100),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Alamat Pengiriman :',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[index][
                                                                  'alamat_pembeli'],
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
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
                                      ),
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
                );
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: dataPesananAktif,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada Pesanan aktif'),
                  );
                }
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    String imageUrl = data[index]['image_url'] ?? '';
                    print(imageUrl);
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Color.fromARGB(255, 101, 136, 100))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data[index]['image_url']),
                              radius: 30,
                            ),
                            title: Text(data[index]['nama_barang']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    'Total Harga : ${data[index]['total_belanja']}'),
                                Text(
                                    'Jumlah Barang : ${data[index]['kuantitas_barang']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Color.fromARGB(255, 101, 136, 100),
                              ),
                              onPressed: () {
                                if (data[index]['status_pesanan'] ==
                                    'Pesanan Masuk') {
                                  counter = 1;
                                } else if (data[index]['status_pesanan'] ==
                                    "Pesanan Diterima") {
                                  counter = 3;
                                } else if (data[index]['status_pesanan'] ==
                                    'Pesanan Selesai') {
                                  counter = 4;
                                }
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: SimpleDialog(
                                        children: [
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              child: Text(
                                                "Informasi Riwayat Pengantaran",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 101, 136, 100),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FixedTimeline.tileBuilder(
                                            builder: TimelineTileBuilder
                                                .connectedFromStyle(
                                              itemCount: counter,
                                              contentsAlign:
                                                  ContentsAlign.reverse,
                                              contentsBuilder:
                                                  (context, index) => Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(events[index]),
                                                ),
                                              ),
                                              connectorStyleBuilder:
                                                  (context, index) =>
                                                      ConnectorStyle.solidLine,
                                              indicatorStyleBuilder:
                                                  (context, index) =>
                                                      IndicatorStyle.dot,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Informasi Riwayat Pembelian",
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              101,
                                                              136,
                                                              100),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  data[index][
                                                                      'image_url']),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10,
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Detail Produk :",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          101,
                                                                          136,
                                                                          100),
                                                                ),
                                                              ),
                                                              Text(
                                                                data[index][
                                                                    'nama_barang'],
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                  'Jumlah Barang : ${data[index]['kuantitas_barang']}'),
                                                              Text(
                                                                  'Total harga : ${data[index]['total_belanja']}'),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 2),
                                                      child: Text(
                                                        "Detail Pengantaran",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              101,
                                                              136,
                                                              100),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Alamat Pengiriman :',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[index][
                                                                  'alamat_pembeli'],
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
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
                                      ),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
