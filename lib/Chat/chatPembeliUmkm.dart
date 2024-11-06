import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InboxPagePembeliUmkm(),
    );
  }
}

class InboxPagePembeliUmkm extends StatefulWidget {
  const InboxPagePembeliUmkm({super.key});

  @override
  _InboxPagePembeliUmkmState createState() => _InboxPagePembeliUmkmState();
}

class _InboxPagePembeliUmkmState extends State<InboxPagePembeliUmkm> {
  List<InboxItemData> inboxItems = [
    InboxItemData(
      sender: 'UMKM Toko Sukses',
      message: 'Terima kasih telah melakukan pembayaran. Pesanan Anda sedang diproses.',
      time: '12:00',
      isRead: false,
    ),
    InboxItemData(
      sender: 'UMKM Makanan Sehat',
      message: 'Hai! Kami sedang menyiapkan barang Anda. Estimasi pengiriman adalah 2 hari.',
      time: '11:30',
      isRead: true,
    ),
    InboxItemData(
      sender: 'UMKM Kerajinan Tangan',
      message: 'Kami ingin memberitahukan bahwa barang yang Anda pesan telah dikirim. Cek resi ya!',
      time: '10:00',
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
        backgroundColor: const Color.fromARGB(255, 101, 136, 100),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
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
                            PembeliUmkmChatPage(sender: selectedMessage.sender),
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
                    builder: (context) =>
                        PembeliUmkmChatPage(sender: item.sender)),
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
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
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

class PembeliUmkmChatPage extends StatefulWidget {
  final String sender;

  const PembeliUmkmChatPage({super.key, required this.sender});

  @override
  _PembeliUmkmChatPageState createState() => _PembeliUmkmChatPageState();
}

class _PembeliUmkmChatPageState extends State<PembeliUmkmChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  final Map<String, List<Map<String, dynamic>>> initialMessages = {
    'UMKM Toko Sukses': [
      {'text': 'Selamat pagi! Apakah Anda sudah menerima pesanan Anda?', 'isSentByUser': false},
    ],
    'UMKM Makanan Sehat': [
      {'text': 'Selamat siang kak, apakah barang bisa di kirim hari ini?', 'isSentByUser': true},
      {'text': 'Hai! Kami sedang menyiapkan barang Anda. Estimasi pengiriman adalah 2 hari.', 'isSentByUser': false}
    ],
    'UMKM Kerajinan Tangan': [
      {'text': 'Kami ingin memberitahukan bahwa barang yang Anda pesan telah dikirim. Cek resi ya!', 'isSentByUser': false}
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString(widget.sender);

    if (savedMessages != null) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(savedMessages));
      });
    } else {
      setState(() {
        messages = initialMessages[widget.sender] ?? [];
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
                        backgroundImage:
                            AssetImage('lib/assets_images/Profilepic.png'),
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
                        backgroundImage:
                            AssetImage('lib/assets_images/Profilepic.png'),
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
