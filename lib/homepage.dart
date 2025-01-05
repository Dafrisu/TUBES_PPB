import 'package:flutter/material.dart';
import 'Chat/chatPembeliUmkm.dart'; // import page chat el
import 'riwayat_pembelian.dart'; // import page riwayat dafa
import 'dashboard/dashboard.dart'; // import dashboard page darryl
import 'profile_settings.dart'; // import profile page mahes
import 'cart.dart'; // import cart page haikal

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => Screens();
}

class Screens extends State<Homepage> {
  int pages = 0;
  List<Widget> pagelist = const [
    Dashboard(),
    cart(),
    RiwayatPembelian(), // Ganti jadi page riwayat dafa
    InboxPagePembeliUmkm(), 
    ProfileSettings(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pages,
        children: pagelist,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            pages = index;
          });
        },
        currentIndex: pages,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor: Color.fromRGBO(76, 175, 80, 1)),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Keranjang',
            backgroundColor: Color.fromRGBO(76, 175, 80, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Riwayat',
            backgroundColor: Color.fromRGBO(76, 175, 80, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Pesan',
            backgroundColor: Color.fromRGBO(76, 175, 80, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
            backgroundColor: Color.fromRGBO(76, 175, 80, 1),
          ),
        ],
      ),
    );
  }
}
