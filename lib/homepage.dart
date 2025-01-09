import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_keranjang.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'Chat/chatPembeliUmkm.dart'; // import page chat el
import 'Dafa_riwayat_pembelian.dart'; // import page riwayat dafa
import 'dashboard/dashboard.dart'; // import dashboard page darryl
import 'profile_settings.dart'; // import profile page mahes
import 'cart.dart'; // import cart page haikal
import 'main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => Screens();
}

class Screens extends State<Homepage> {
  int pages = 0;
  String? sessionId;

  SharedPrefService sharedPrefService = SharedPrefService();

  // Membuat controller untuk PageView
  PageController pageController = PageController();

   @override
  void initState() {
    super.initState();
    _loadSessionId();
  }

  Future<void> _loadSessionId() async {
    sessionId = await sharedPrefService.readCache(key: "sessionId");
    setState(() {});
  }


  // Fungsi untuk memuat ulang data keranjang
  void refreshKeranjang() {
    setState(() {
      // Menambahkan perubahan halaman di PageView
      pageController.jumpToPage(1); // Pindah ke halaman 'Keranjang'
    });
  }

  @override
  Widget build(BuildContext context) {
    print("sessionID di homepage: $sessionId");
    
    getlastbatch(int.tryParse(sessionId  ?? '0') ?? 0);
    return Scaffold(
      body: PageView(
        controller: pageController, // Menambahkan PageController
        onPageChanged: (index) {
          setState(() {
            pages = index;
          });
        },
        children: [
          Dashboard(),
          cart(), // Keranjang
          RiwayatPembelian(),
          CombinedInboxPage(),
          ProfileSettings(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            pages = index;
            // Pindah ke halaman Keranjang dan refresh
            pageController.jumpToPage(index);
            if (index == 1) {
              refreshKeranjang(); // Refresh Keranjang saat tab dipilih
            }
          });
        },
        currentIndex: pages,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor: Color.fromARGB(255, 101, 136, 100)),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Keranjang',
            backgroundColor: Color.fromARGB(255, 101, 136, 100),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Riwayat',
            backgroundColor: Color.fromARGB(255, 101, 136, 100),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Pesan',
            backgroundColor: Color.fromARGB(255, 101, 136, 100),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
            backgroundColor: Color.fromARGB(255, 101, 136, 100),
          ),
        ],
      ),
    );
  }
}
