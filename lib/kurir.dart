import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<NotificationItemData> notifications = [
    NotificationItemData(
      title: 'UMKM',
      message: 'Bang antar yang ini!',
      time: '16:20',
      isRead: false,
    ),
    NotificationItemData(
      title: 'UMKM',
      message: 'Cek lagi barangnya ya!',
      time: '16:30',
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
      sender: 'Joko Penjual',
      message: 'Barang sudah sampai?',
      time: '14:50',
      isRead: true,
    ),
    InboxItemData(
      sender: 'Rina Katering',
      message: 'Pesanan sudah disiapkan!',
      time: '15:15',
      isRead: false,
    ),
    InboxItemData(
      sender: 'Budi Sumber',
      message: 'Kapan bisa ambil barang?',
      time: '13:45',
      isRead: true,
    ),
    InboxItemData(
      sender: 'Dewi Jaya',
      message: 'Terima kasih atas pengiriman!',
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
        orders: orders
      ),
    );
  }

    List<OrderItemData> orders = [
    OrderItemData(
      itemName: 'Salad',
      quantity: 1,
      address: 'Jl. Boulevard no 32',
      gambar: 'lib/assets_images/Makanan1.jpg'
    ),
    OrderItemData(
      itemName: 'French Fries',
      quantity: 2,
      address: 'Jl. Mangga no 21',
      gambar: 'lib/assets_images/Makanan4.jpg'
    ),
    OrderItemData(
      itemName: 'Iced Lemon',
      quantity: 1,
      address: 'Jl. Merdeka no 10',
      gambar: 'lib/assets_images/Minuman4.jpg'
    ),
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
                icon: const Icon(Icons.notifications, color: Colors.white,),
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
                icon: const Icon(Icons.mail_outline, color: Colors.white,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InboxPage(),
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

  OrderItemData({
    required this.itemName,
    required this.quantity,
    required this.address,
    required this.gambar
  });
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
              backgroundColor: isPressed ? Colors.green : const Color(0xFF7B5400), 
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

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<InboxItemData> inboxItems = [
    InboxItemData(
      sender: 'Asep Montir',
      message: 'Siipp',
      time: '16:20',
      isRead: false,
    ),
    InboxItemData(
      sender: 'Joko Penjual',
      message: 'Barang sudah sampai?',
      time: '14:50',
      isRead: true,
    ),
    InboxItemData(
      sender: 'Rina Katering',
      message: 'Pesanan sudah disiapkan!',
      time: '15:15',
      isRead: false,
    ),
    InboxItemData(
      sender: 'Budi Sumber',
      message: 'Kapan bisa ambil barang?',
      time: '13:45',
      isRead: true,
    ),
    InboxItemData(
      sender: 'Dewi Jaya',
      message: 'Terima kasih atas pengiriman!',
      time: '12:30',
      isRead: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Kotak Masuk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF658864),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MessageSearchDelegate(
                  inboxMessages: inboxItems,
                  onSelected: (selectedMessage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(sender: selectedMessage.sender),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: inboxItems.length,
        itemBuilder: (context, index) {
          final item = inboxItems[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            ),
            title: Text(item.sender),
            subtitle: Text(item.message),
            trailing: Text(item.time),
            onTap: () {
              setState(() {
                item.isRead = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(sender: item.sender)),
              );
            },
          );
        },
      ),
    );
  }
}

class MessageSearchDelegate extends SearchDelegate<InboxItemData?> {
  final List<InboxItemData> inboxMessages;
  final ValueChanged<InboxItemData> onSelected;

  MessageSearchDelegate(
      {required this.inboxMessages, required this.onSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black,),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = inboxMessages
        .where((message) =>
            message.sender.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          title: Text(result.sender),
          subtitle: Text(result.message),
          onTap: () {
            onSelected(result);
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = inboxMessages
        .where((message) =>
            message.sender.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.sender),
          onTap: () {
            query = suggestion.sender;
            onSelected(suggestion);
          },
        );
      },
    );
  }
}

class InboxItemData {
  final String sender;
  final String message;
  final String time;
  bool isRead;

  InboxItemData({
    required this.sender,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class ChatPage extends StatefulWidget {
  final String sender;

  const ChatPage({super.key, required this.sender});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString(widget.sender);

    if (savedMessages != null) {
      List<dynamic> decodedMessages = json.decode(savedMessages);
      setState(() {
        messages = List<Map<String, dynamic>>.from(decodedMessages);
      });
    } else {
      setState(() {
        messages = [
          {'text': 'Pesanan saya mana?', 'isSentByUser': false},
          {'text': 'Siap Otw', 'isSentByUser': true},
          {'text': 'Okay', 'isSentByUser': false},
        ];
      });
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.sender, json.encode(messages));
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        messages.add({'text': messageText, 'isSentByUser': true});
      });
      _messageController.clear();
      _saveMessages(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sender,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF658864),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Row(
                  mainAxisAlignment: message['isSentByUser']
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!message['isSentByUser'])
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(''), 
                      ),
                    if (!message['isSentByUser']) const SizedBox(width: 8),
                    ChatBubble(
                      text: message['text'],
                      isSentByUser: message['isSentByUser'],
                    ),
                    if (message['isSentByUser']) const SizedBox(width: 8),
                    if (message['isSentByUser'])
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(''), 
                      ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByUser;

  const ChatBubble({super.key, required this.text, required this.isSentByUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSentByUser ? Colors.green[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
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
        backgroundColor: const Color(0xFF658864),
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
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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