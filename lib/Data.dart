import 'package:flutter/material.dart';

final List<Map<String, dynamic>> colorpalete = [
  {"green": const Color.fromARGB(255, 101, 136, 100)}
];

List<Map<String, dynamic>> barangpagepenjual = [];

List<Map<String, dynamic>> listcart = [];

List<Map<String, dynamic>> sortedcart = [];

List<Map<String, dynamic>> listdata = [
  {
    "id_penjual": "pjl01",
    "nama":
        "Fantech ATOM PRO SERIES Wireless Keyboard Mechanical Gaming Hotswap ",
    "harga": "490.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2024/3/28/79bd45c3-03ef-4e06-85cf-d8c2987010f6.jpg',
    "seller": "Asep Montir Gamink",
    "deskripsi": "3 Form Factor to Choose Stellar Edition\n merupakan seri keyboard gaming mechanical ATOM PRO "
        "yang terdiri dari tiga produk dengan layout yang berbeda-beda. ATOM PRO63 MK912 dengan layout 60% "
        "ATOM PRO83 MK913 dengan layout 75% ATOM PRO96 MK914 dengan layout 95%. (Coming Soon)\n\n"
        "Tri-Mode Connection ATOM PRO\n telah dilengkapi dengan fitur 3 mode konektivitas. Mulai dari koneksi wired menggunakan kabel, wireless 2.4GHz yang stabil, hingga Bluetooth yang bisa disambungkan ke 3 device sekaligus.\n\n"
        "Hot Swappable Switch & Per-Key RGB Lighting\n Telah dibekali dengan switch yang hot swappable dan kompatibel dengan mechanical switch 5 pin yang memudahkan kamu untuk memasang dan mengganti switch. Selain itu juga terdapat fitur per-key RGB lighting yang siap meningkatkan tampilan keyboard jadi semakin memukau."
  },
  {
    "id_penjual": "pjl01",
    "nama": "Logitech G502 HERO High Performance Gaming Mouse",
    "harga": "500.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2024/4/27/3ad8ad82-927c-46c4-ad21-1b90c8f50240.jpg',
    "seller": "Asep Montir Gamink",
    "deskripsi":
        "Logitech G502 HERO adalah gaming mouse berperforma tinggi dengan sensor HERO 25K yang canggih untuk keakuratan piksel sempurna."
            "\n\nMouse ini juga dilengkapi dengan sistem pemberat yang dapat disesuaikan, 11 tombol yang dapat diprogram, dan RGB lighting yang dapat dikustomisasi."
  },
  {
    "id_penjual": "pjl01",
    "nama": "Razer BlackShark V2 X Gaming Headset",
    "harga": "700.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2022/4/21/ac398ea7-9886-4e1e-8920-f456a8ce8376.jpg',
    "seller": "Asep Montir Gamink",
    "deskripsi":
        "Razer BlackShark V2 X merupakan headset gaming yang dirancang dengan fokus pada kualitas audio, kenyamanan, dan kinerja.\n\n"
            "Dengan teknologi suara THX Spatial Audio, memberikan pengalaman surround sound yang imersif. Headset ini juga sangat ringan, hanya 240g, dengan busa memory foam untuk kenyamanan jangka panjang."
  },
  {
    "id_penjual": "pjl01",
    "nama": "ASUS TUF Gaming F15 Gaming Laptop",
    "harga": "15.000.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2024/8/28/7d5c4636-2bb9-42b6-812c-40b0fb044409.jpg',
    "seller": "Asep Montir Gamink",
    "deskripsi":
        "ASUS TUF Gaming F15 adalah laptop gaming yang tahan banting dengan kinerja luar biasa berkat prosesor Intel Core i7 generasi ke-10 dan grafis NVIDIA GeForce GTX.\n\n"
            "Dilengkapi dengan layar 144Hz, memastikan pengalaman gaming yang mulus dan responsif. Laptop ini juga memiliki sertifikasi MIL-STD-810H, sehingga sangat tangguh untuk digunakan dalam kondisi ekstrim."
  },
  {
    "id_penjual": "pjl02",
    "nama": "Corsair K95 RGB Platinum XT Mechanical Gaming Keyboard",
    "harga": "2.300.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/product-1/2020/4/30/27754517/27754517_b640604c-15a6-4455-8c30-7420c771c542_625_625',
    "seller": "TechStore ID",
    "deskripsi":
        "Corsair K95 RGB Platinum XT adalah keyboard gaming mekanikal dengan pencahayaan RGB dan macro keys.\n\n"
            "Memiliki ketahanan tinggi dan kustomisasi per-key RGB lighting untuk penampilan yang lebih menarik."
  },
  {
    "id_penjual": "pjl02",
    "nama": "SteelSeries Rival 600 Dual Sensor Gaming Mouse",
    "harga": "1.200.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2022/6/2/4bc8f83b-aff6-429b-9456-0e9c3a3f32d8.jpg',
    "seller": "TechStore ID",
    "deskripsi":
        "SteelSeries Rival 600 adalah gaming mouse dengan sensor ganda untuk akurasi tinggi dan kontrol yang presisi.\n\n"
            "Dilengkapi dengan pencahayaan RGB dan sistem pemberat yang dapat disesuaikan sesuai preferensi."
  },
  {
    "id_penjual": "pjl02",
    "nama": "HyperX Cloud II Wireless Gaming Headset",
    "harga": "1.600.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2023/5/18/de88c9fa-6409-4486-b535-deb696d5aecc.jpg',
    "seller": "TechStore ID",
    "deskripsi":
        "HyperX Cloud II Wireless merupakan headset gaming dengan suara surround 7.1 dan kenyamanan premium.\n\n"
            "Desainnya ringan dan memiliki mikrofon yang dapat dilepas serta noise-cancelling untuk komunikasi jelas."
  },
  {
    "id_penjual": "pjl02",
    "nama": "MSI GF63 Thin 10SC Gaming Laptop",
    "harga": "14.000.000",
    "img":
        'https://images.tokopedia.net/img/cache/900/VqbcmM/2022/11/23/8c37645b-2a1a-45c2-a8ca-0cd42b26270c.jpg',
    "seller": "TechStore ID",
    "deskripsi":
        "MSI GF63 Thin 10SC adalah laptop gaming yang ringan dan bertenaga dengan prosesor Intel Core i5 generasi ke-10.\n\n"
            "Dilengkapi grafis NVIDIA GTX 1650 Max-Q dan layar 144Hz untuk performa gaming optimal."
  }
];
