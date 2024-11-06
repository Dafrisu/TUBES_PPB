import 'package:flutter/material.dart';
import 'package:tubes_ppb/login.dart';
import 'Chat/chatKurirPembeli.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<NotificationItemData> notifications = [
    NotificationItemData(
      title: 'UMKM',
      message: 'Pesanan Anda sedang dalam proses.',
      time: '08:30',
      isRead: false,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Driver sedang menuju lokasi Anda.',
      time: '09:15',
      isRead: true,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Pesanan berhasil diterima oleh kurir.',
      time: '10:45',
      isRead: false,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Kurir sedang di perjalanan ke lokasi Anda.',
      time: '11:20',
      isRead: true,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Pesanan Anda telah diantarkan.',
      time: '12:00',
      isRead: false,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Sistem telah menerima pembayaran.',
      time: '13:30',
      isRead: true,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Jadwal pengiriman baru telah ditambahkan.',
      time: '14:00',
      isRead: false,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Pesanan Anda sedang dikemas oleh penjual.',
      time: '15:20',
      isRead: true,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Penjual meminta Anda meninjau pesanan.',
      time: '16:45',
      isRead: false,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Sistem: Pembaruan status pengiriman telah diterima.',
      time: '17:30',
      isRead: true,
    ),
  ];

  List<InboxItemData> inboxMessages = [
    InboxItemData(
      sender: 'Asep Montir',
      message: 'Siipp',
      time: '16:20',
      isRead: false,
    ),
    InboxItemData(
      sender: 'Cahyadi',
      message: 'Barang sudah sampai?',
      time: '14:50',
      isRead: true,
    ),
    InboxItemData(
      sender: 'Dewi Jaya',
      message: 'Oke, terima kasih informasinya.',
      time: '12:30',
      isRead: false,
    ),
  ];

  bool get hasUnreadNotifications {
    return notifications.any((notification) => !notification.isRead);
  }

  bool get hasUnreadInboxMessages {
    return inboxMessages.any((message) => !message.isRead);
  }

  void markAllNotificationsAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeliveryPage(
          notifications: notifications,
          inboxMessages: inboxMessages,
          hasUnreadNotifications: hasUnreadNotifications,
          hasUnreadInboxMessages: hasUnreadInboxMessages,
          markAllNotificationsAsRead: markAllNotificationsAsRead,
          orders: orders),
    );
  }

  List<OrderItemData> orders = [
    OrderItemData(
        itemName: 'Salad',
        quantity: 1,
        address: 'Jl. Boulevard no 32',
        gambar: 'lib/assets_images/Makanan1.jpg'),
    OrderItemData(
        itemName: 'French Fries',
        quantity: 2,
        address: 'Jl. Mangga no 21',
        gambar: 'lib/assets_images/Makanan4.jpg'),
    OrderItemData(
        itemName: 'Iced Lemon',
        quantity: 1,
        address: 'Jl. Merdeka no 10',
        gambar: 'lib/assets_images/Minuman4.jpg'),
  ];
}

class DeliveryPage extends StatelessWidget {
  final List<NotificationItemData> notifications;
  final List<InboxItemData> inboxMessages;
  final bool hasUnreadNotifications;
  final bool hasUnreadInboxMessages;
  final VoidCallback markAllNotificationsAsRead;
  final List<OrderItemData> orders;

  const DeliveryPage({
    super.key,
    required this.notifications,
    required this.inboxMessages,
    required this.hasUnreadNotifications,
    required this.hasUnreadInboxMessages,
    required this.markAllNotificationsAsRead,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Halo, Kurir.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 136, 100),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(
                        notifications: notifications,
                        markAllAsRead: markAllNotificationsAsRead,
                      ),
                    ),
                  );
                },
              ),
              if (hasUnreadNotifications)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InboxPageKurirPembeli(),
                    ),
                  );
                },
              ),
              if (hasUnreadInboxMessages)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah Anda yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        child: const Text("Batal"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Ya"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan yang harus diantar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(order: order);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemData {
  final String itemName;
  final int quantity;
  final String address;
  final String gambar;

  OrderItemData(
      {required this.itemName,
      required this.quantity,
      required this.address,
      required this.gambar});
}

class OrderCard extends StatefulWidget {
  final OrderItemData order;
  const OrderCard({super.key, required this.order});

  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isPressed = false;

  void _onButtonPressed() {
    setState(() {
      isPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.order.gambar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.itemName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Jumlah: ${widget.order.quantity}'),
                Text(widget.order.address),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isPressed ? Colors.green : const Color(0xFF7B5400),
            ),
            child: Text(
              isPressed ? 'Diantar' : 'Dikemas',
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  final List<NotificationItemData> notifications;
  final VoidCallback markAllAsRead;

  const NotificationPage(
      {super.key, required this.notifications, required this.markAllAsRead});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void markAsRead(int index) {
    setState(() {
      widget.notifications[index].isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 136, 100),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.markAllAsRead();
              });
            },
            child: const Text(
              'Read All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          final notification = widget.notifications[index];
          return GestureDetector(
            onTap: () {
              markAsRead(index);
            },
            child: NotificationItem(
              title: notification.title,
              message: notification.message,
              time: notification.time,
              isRead: notification.isRead,
            ),
          );
        },
      ),
    );
  }
}

class NotificationItemData {
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationItemData({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;

  const NotificationItem({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(time),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
