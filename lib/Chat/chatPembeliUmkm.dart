// chatPembeliUmkm
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/homepage.dart';
import 'dart:convert';
import '../dashboard/dashboard.dart';
import 'lib/api/Raphael_api_chat.dart';
import 'package:http/http.dart' as http;
import 'chatPembeliKurir.dart';
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const CombinedInboxPage(),
    );
  }
}

class CombinedInboxPage extends StatefulWidget {
  const CombinedInboxPage({super.key});

  @override
  _CombinedInboxPageState createState() => _CombinedInboxPageState();
}

class _CombinedInboxPageState extends State<CombinedInboxPage> {
  Future<List<Map<String, dynamic>>> getchatpembeli = fetchchatpembeli();
  Future<List<Map<String, dynamic>>> getchatkurir = fetchchatkurir();

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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MessageSearchDelegate(
                  getchatpembeli: getchatpembeli,
                  getchatkurir: getchatkurir,
                  onSelected: (selectedMessage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => selectedMessage['isKurir']
                            ? PembeliKurirChatPage(
                                sender: selectedMessage['nama_kurir'] ??
                                    'Unknown Kurir',
                                id_kurir: selectedMessage['id_kurir'] ?? 0)
                            : PembeliUmkmChatPage(
                                sender: selectedMessage['username'] ??
                                    'Unknown User',
                                id_umkm: selectedMessage['id_umkm'] ?? 0,
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: Future.wait([getchatpembeli, getchatkurir]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pesan.'));
          }

          final inboxMessages = [
            ...List<Map<String, dynamic>>.from(snapshot.data![0])
                .map((msg) => {...msg, 'isKurir': false}),
            ...List<Map<String, dynamic>>.from(snapshot.data![1])
                .map((msg) => {...msg, 'isKurir': true}),
          ];

          final filteredMessages = inboxMessages.where((msg) {
            if (msg['isKurir']) {
              return msg['nama_kurir'] != null &&
                  msg['nama_kurir'] != 'Unknown Kurir';
            } else {
              return msg['username'] != null &&
                  msg['username'] != 'Unknown User';
            }
          }).toList();

          filteredMessages.sort((a, b) => b['id_chat'].compareTo(a['id_chat']));

          return ListView.builder(
            itemCount: filteredMessages.length,
            itemBuilder: (context, index) {
              final item = filteredMessages[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
                title: Text(item['isKurir']
                    ? item['nama_kurir'] ?? 'Unknown Kurir'
                    : item['username'] ?? 'Unknown User'),
                subtitle: Text(item['message'] ?? ''),
                trailing: Text(item['sent_at'] != null
                    ? DateFormat('HH:mm')
                        .format(DateTime.parse(item['sent_at']))
                    : 'Unknown time'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => item['isKurir']
                          ? PembeliKurirChatPage(
                              sender: item['nama_kurir'] ?? 'Unknown Kurir',
                              id_kurir: item['id_kurir'] ?? 0)
                          : PembeliUmkmChatPage(
                              sender: item['username'] ?? 'Unknown User',
                              id_umkm: item['id_umkm'] ?? 0),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class MessageSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  final Future<List<Map<String, dynamic>>> getchatpembeli;
  final Future<List<Map<String, dynamic>>> getchatkurir;
  final ValueChanged<Map<String, dynamic>> onSelected;

  MessageSearchDelegate({
    required this.getchatpembeli,
    required this.getchatkurir,
    required this.onSelected,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: Future.wait([getchatpembeli, getchatkurir]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Terjadi kesalahan: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada pesan.'));
        }

        final lowerCaseQuery = (query ?? '').toLowerCase();

        // Gabungkan data pembeli dan kurir
        final inboxMessages = [
          ...List<Map<String, dynamic>>.from(snapshot.data![0])
              .map((msg) => {...msg, 'isKurir': false}),
          ...List<Map<String, dynamic>>.from(snapshot.data![1])
              .map((msg) => {...msg, 'isKurir': true}),
        ];

        // Filter pesan dengan nama valid
        final filteredMessages = inboxMessages.where((msg) {
          if (msg['isKurir']) {
            return msg['nama_kurir'] != null &&
                msg['nama_kurir'] != 'Unknown Kurir';
          } else {
            return msg['username'] != null && msg['username'] != 'Unknown User';
          }
        }).toList();

        // Filter pesan berdasarkan query pencarian
        final searchResults = filteredMessages.where((message) {
          final searchField = message['isKurir']
              ? message['nama_kurir'] ?? ''
              : message['username'] ?? '';
          final messageContent = message['message'] ?? '';

          return searchField.toLowerCase().contains(lowerCaseQuery) ||
              messageContent.toLowerCase().contains(lowerCaseQuery);
        }).toList();

        // Urutkan hasil pencarian
        searchResults.sort((a, b) => b['id_chat'].compareTo(a['id_chat']));

        // Tampilkan hasil pencarian
        return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final item = searchResults[index];
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
              ),
              title: Text(item['isKurir']
                  ? item['nama_kurir'] ?? 'Unknown Kurir'
                  : item['username'] ?? 'Unknown User'),
              subtitle: Text(item['message'] ?? ''),
              trailing: Text(item['sent_at'] != null
                  ? DateFormat('HH:mm').format(DateTime.parse(item['sent_at']))
                  : 'Unknown time'),
              onTap: () {
                onSelected(item);
                close(context, item);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class PembeliUmkmChatPage extends StatefulWidget {
  final String sender;
  final int id_umkm;

  const PembeliUmkmChatPage(
      {super.key, required this.sender, required this.id_umkm});

  @override
  _PembeliUmkmChatPageState createState() => _PembeliUmkmChatPageState();
}

class _PembeliUmkmChatPageState extends State<PembeliUmkmChatPage> {
  final TextEditingController _messageController = TextEditingController();

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMessagesByPembeliAndUMKM(widget.id_umkm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No messages available.'));
          }

          final messages = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isReceiverUMKM = message['receiver_type'] == "UMKM";
                    final sentAt = message['sent_at'] != null
                        ? DateFormat('HH:mm')
                            .format(DateTime.parse(message['sent_at']))
                        : 'Unknown time';

                    return Row(
                      mainAxisAlignment: isReceiverUMKM
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isReceiverUMKM)
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('lib/assets_images/Profilepic.png'),
                          ),
                        if (!isReceiverUMKM) const SizedBox(width: 8),
                        chatBubblePembeliUmkm(
                          text: message['message'],
                          isReceiverUMKM: isReceiverUMKM,
                          sentAt: message['sent_at'] != null
                              ? DateFormat('HH:mm')
                                  .format(DateTime.parse(message['sent_at']))
                              : 'Unknown time',
                        ),
                        if (isReceiverUMKM) const SizedBox(width: 8),
                        if (isReceiverUMKM)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) async {
                          if (value.trim().isNotEmpty) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            int id_pembeli = prefs.getInt('sessionId') ?? 0;
                            await sendMessagePembeliKeUMKM(
                                value.trim(), widget.id_umkm, 'UMKM');
                            setState(() {});
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_messageController.text.trim().isNotEmpty) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          int id_pembeli = prefs.getInt('sessionId') ?? 0;
                          await sendMessagePembeliKeUMKM(
                              _messageController.text.trim(),
                              widget.id_umkm,
                              'UMKM');
                          setState(() {});
                          _messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class chatBubblePembeliUmkm extends StatelessWidget {
  final String text;
  final bool isReceiverUMKM;
  final String sentAt;

  const chatBubblePembeliUmkm(
      {super.key,
      required this.text,
      required this.isReceiverUMKM,
      required this.sentAt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isReceiverUMKM ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: !isReceiverUMKM ? Colors.grey[300] : Colors.green[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(text),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            sentAt,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
