import 'package:flutter/material.dart';
import 'Chat/chatPembeliUmkm.dart'; // import page chat el
import ''; // import page riwayat dafa
import 'dashboard/dashboard.dart'; // import dashboard page darryl
import 'profile_settings.dart'; // import profile page mahes
import 'cart.dart'; // import cart page haikal

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => Homepage();
}

class Homepage extends State<Screens> {
  int pages = 0;
  List<Widget> pagelist = const [
    Dashboard(),
    Dashboard(), //Ganti aja jadi page lu el
    Dashboard(), // Ganti jadi page riwayat dafa
    cart(),
    ProfileSettings(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: pagelist,
        index: pages,
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
