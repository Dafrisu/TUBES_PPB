import 'package:flutter/material.dart';
import 'package:tubes_ppb/BarangPenjual.dart';
import 'package:tubes_ppb/Data.dart' as data;
import 'dashboard_full_produk.dart';
import 'dashboard_full_makanan.dart';
import 'dashboard_full_minuman.dart';
import 'dashboard_full_misc.dart';
import 'package:tubes_ppb/notification_page.dart';

// Import package carousel dari pub.dev
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Navbar
      appBar: AppBar(
        title: const Text('Hello, Asep',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading:
            false, // Disable tombol back ketika di navigate ke page ini
        actions: <Widget>[
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              // Handle search logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Membuat carousel produk
            FlutterCarousel(
              // Settingan untuk carouselnya (ukuran, otomatis ganti, produk awal, dkk)
              options: FlutterCarouselOptions(
                height: 250.0,
                showIndicator: true,
                initialPage:
                    0, // Set untuk show item paling pertama ketika page dibuka
                autoPlay: true, // Set carousel otomatis berganti-ganti
                autoPlayInterval: const Duration(
                    seconds:
                        3), // Set interval berapa detik sebelum otomatis berganti item selanjutnya
                slideIndicator: CircularSlideIndicator(),
              ),
              // Isi carousel
              items: [
                'lib/assets_images/Minuman1.png',
                'lib/assets_images/Minuman2.jpg',
                'lib/assets_images/Makanan1.jpg',
                'lib/assets_images/Misc1.png',
                'lib/assets_images/Produk1.png',
              ].map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Image.asset(img, fit: BoxFit.cover));
                  },
                );
              }).toList(),
            ),
            // Menampilkan List Preview Produk yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Produk',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Produk yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullProdukPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Produk yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Produk yang dijual UMKM
            GridView.count(
              crossAxisCount: 2, // Number of columns to display
              shrinkWrap:
                  true, // Allow GridView to take only the space it needs
              physics: NeverScrollableScrollPhysics(), // Disable scrolling
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PageBarang(product: data.listdata[0]),
                      ),
                    );
                  },
                  child: ProductCard(
                    title: 'Produk 1',
                    imageUrl: 'lib/assets_images/Makanan1.jpg',
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>PageBarang(product: data.listdata[4])),
                    );
                  },
                  child: ProductCard(
                      title: 'Produk 2',
                      imageUrl: 'lib/assets_images/Minuman1.png'),
                ),
                // Add more previews as needed
              ],
            ),
            // Menampilkan List Preview Makanan yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Makanan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Makanan yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullMakananPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Makanan yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Makanan yang dijual UMKM
            GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              shrinkWrap:
                  true, // Allow GridView to take only the space it needs
              physics: NeverScrollableScrollPhysics(),
              children: const <Widget>[
                ProductCard(
                    title: 'Makanan 1',
                    imageUrl: 'lib/assets_images//Makanan1.jpg'),
                ProductCard(
                    title: 'Makanan 2',
                    imageUrl: 'lib/assets_images/Makanan2.jpg'),
                // Add more previews as needed
              ],
            ),

            // Menampilkan List Preview Minuman yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Minuman',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Minuman yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullMinumanPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Minuman yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Minuman yang dijual UMKM
            GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              shrinkWrap:
                  true, // Allow GridView to take only the space it needs
              physics: NeverScrollableScrollPhysics(),
              children: const <Widget>[
                ProductCard(
                    title: 'Minuman 1',
                    imageUrl: 'lib/assets_images/Minuman1.png'),
                ProductCard(
                    title: 'Minuman 2',
                    imageUrl: 'lib/assets_images/Minuman2.jpg'),
                // Add more previews as needed
              ],
            ),

            // Menampilkan List Preview Misc yang dijual UMKM
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Misc',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ketika di pencet, maka akan pindah page
                      // Ke Page yang menunjukan semua Misc yang dijual UMKM
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullMiscPage()),
                      );
                    },
                    // Tombol yang dipencet ketika ingin melihat
                    // Semua Misc yang dijual UMKM
                    child: const Text('Lihat Semua',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Gambaran semua Misc yang dijual UMKM
            GridView.count(
              crossAxisCount: 2, // Jumlah kolom yang ditampilkan
              shrinkWrap:
                  true, // Allow GridView to take only the space it needs
              physics: NeverScrollableScrollPhysics(), // Disable Scroll
              children: const <Widget>[
                ProductCard(
                    title: 'Misc 1', imageUrl: 'lib/assets_images/Misc1.png'),
                ProductCard(
                    title: 'Misc 2', imageUrl: 'lib/assets_images/Misc2.png'),
                // Add more previews as needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ProductCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(imageUrl,
              fit: BoxFit.cover,
              height: 100,
              width: 100), // nanti sesuaikan height sama width
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
