import 'dart:convert';
import 'oderpage_fingerprintTest.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:tubes_ppb/edit_profile.dart';
import 'package:tubes_ppb/homepage.dart';
import 'package:tubes_ppb/profile_settings.dart';
import 'Data.dart' as data;
import 'api/Dafa_api_getriwayaPembelian.dart';
import 'api/api_keranjang.dart';
import 'dashboard/dashboard.dart'; // import dashboard page darryl
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> isikeranjang;
  const OrderPage({super.key, required this.isikeranjang});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int totalbelanja = 0;
  int totalsemuanya = 0;
  late final LocalAuthentication auth;
  bool _supportState = false;
  late Future<Map<String, dynamic>> alamat;

  @override
  void initState() {
    super.initState();
    calculateTotal();
    printdata();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _supportState = isSupported;
      });
    });
    alamat = fetchUserData();
  }

  void calculateTotal() async {
    int total = 0;
    List<Map<String, dynamic>> keranjang = await widget.isikeranjang;
    for (var item in keranjang) {
      int price =
          int.parse(item["Produk"]["harga"].toString().replaceAll('.', ''));
      int quantity = item['kuantitas'];
      total += price * quantity;
    }
    setState(() {
      totalbelanja = total;
      totalsemuanya = total + 15000 + 2000;
    });
  }

  void printdata() async {
    List<Map<String, dynamic>> keranjang = await widget.isikeranjang;
    for (var item in keranjang) {
      print(item);
    }
  }

  void sendallpesanan() async {
    List<Map<String, dynamic>> keranjang = await widget.isikeranjang;
    for (var item in keranjang) {
      //nanti diganti session
      sendpesanan(item['id_keranjang'], totalsemuanya.toDouble());
    }
  }

  void getallbiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print('List Of available Metrics: $availableBiometrics');

    if (!mounted) {
      return;
    }
  }

  Future<void> authenticate() async {
    try {
      bool canCheckBiometrics = FingerprintTestHelper.testMode
          ? FingerprintTestHelper.mockBiometricAvailable
          : await auth.canCheckBiometrics;

      bool isDeviceSupported = FingerprintTestHelper.testMode
          ? FingerprintTestHelper.mockBiometricAvailable
          : await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        sendallpesanan();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesanan Berhasil Masuk (tanpa fingerprint)'),
            duration: Duration(seconds: 3),
          ),
        );
        lastbatch = lastbatch + 1;
        addbatch(sessionId, lastbatch);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
        return;
      } else {
        bool authenticated = FingerprintTestHelper.testMode
            ? FingerprintTestHelper.mockAuthenticated
            : await auth.authenticate(
                localizedReason: 'Scan Fingerprintmu untuk Pesan ya',
                options: const AuthenticationOptions(
                  useErrorDialogs: true,
                  stickyAuth: false,
                ),
              );

        if (authenticated) {
          sendallpesanan();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pesanan Berhasil Masuk'),
              duration: Duration(seconds: 3),
            ),
          );
          lastbatch = lastbatch + 1;
          addbatch(sessionId, lastbatch);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('UMKM kecewa 😭'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://umkmapi-production.up.railway.app/pembeli/$sessionId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data pengguna');
    }
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
                  FutureBuilder<Map<String, dynamic>>(
                    future: alamat,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data available');
                      }
                      return Text(
                        snapshot.data!['alamat'],
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileSettings(),
                            ),
                          );
                        },
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: widget.isikeranjang,
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
                        if (data.isEmpty) {
                          return Center(child: Text('Data kosong'));
                        }

                        final item = data[index];
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
                                  item["Produk"]["image_url"],
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
                                      '${item["Produk"]["nama_barang"]}\n',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(height: 5),
                                    Container(
                                      margin: EdgeInsets.only(right: 50),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('RP.${item["Produk"]["harga"]}'),
                                          Row(
                                            children: [
                                              Text(
                                                  'QTY : ${item["kuantitas"]}'),
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
                    );
                  })),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('TOTAL'), Text('Rp. $totalsemuanya')],
                ),
                FingerprintTestWidget(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: OutlinedButton(
        onPressed: () {
          authenticate();
          getlastbatch(sessionId);
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
