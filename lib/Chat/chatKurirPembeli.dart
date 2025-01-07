// chatPembeliKurir
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'lib/api/Raphael_api_chat.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const InboxPageKurirPembeli(),
    );
  }
}

class InboxPageKurirPembeli extends StatefulWidget {
  const InboxPageKurirPembeli({super.key});

  @override
  _InboxPageKurirPembeliState createState() => _InboxPageKurirPembeliState();
}

class _InboxPageKurirPembeliState extends State<InboxPageKurirPembeli> {
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
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MessageSearchDelegate(
                  getchatkurir: getchatkurir,
                  onSelected: (selectedMessage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PembeliKurirChatPage(
                          sender: selectedMessage['nama_lengkap'],
                          id_pembeli: selectedMessage['id_pembeli'],
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getchatkurir,
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

          final inboxMessages = snapshot.data!;
          inboxMessages.sort((a, b) => b['id_chat'].compareTo(a['id_chat']));

          return ListView.builder(
            itemCount: inboxMessages.length,
            itemBuilder: (context, index) {
              final item = inboxMessages[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
                title: Text(item['nama_lengkap']),
                subtitle: Text(item['message']),
                trailing: Text(item['sent_at']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PembeliKurirChatPage(
                          sender: item['nama_lengkap'],
                          id_pembeli: item['id_pembeli']),
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
  final Future<List<Map<String, dynamic>>> getchatkurir;
  final ValueChanged<Map<String, dynamic>> onSelected;

  MessageSearchDelegate({
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getchatkurir,
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

        final results = snapshot.data!.where((message) {
          final usernameMatches = message['nama_lengkap']
              .toLowerCase()
              .contains(query.toLowerCase());
          final messageMatches =
              message['message'].toLowerCase().contains(query.toLowerCase());
          return usernameMatches || messageMatches;
        }).toList();

        results.sort((a, b) => b['id_chat'].compareTo(a['id_chat']));

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return ListTile(
              title: Text(result['nama_lengkap']),
              subtitle: Text(result['message']),
              onTap: () {
                onSelected(result);
                close(context, result);
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

class PembeliKurirChatPage extends StatefulWidget {
  final String sender;
  final int id_pembeli;

  const PembeliKurirChatPage(
      {super.key, required this.sender, required this.id_pembeli});

  @override
  _PembeliKurirChatPageState createState() => _PembeliKurirChatPageState();
}

class _PembeliKurirChatPageState extends State<PembeliKurirChatPage> {
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
        future: fetchchatpembeli(),
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
                    final isReceiverPembeli =
                        message['receiver_type'] == "Pembeli";

                    return Row(
                      mainAxisAlignment: isReceiverPembeli
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isReceiverPembeli)
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('lib/assets_images/Profilepic.png'),
                          ),
                        if (!isReceiverPembeli) const SizedBox(width: 8),
                        chatBubbleKurirPembeli(
                          text: message['message'],
                          isReceiverPembeli: isReceiverPembeli,
                        ),
                        if (isReceiverPembeli) const SizedBox(width: 8),
                        if (isReceiverPembeli)
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
                            await sendMessageKurirkePembeli(
                                13, value.trim(), widget.id_pembeli, 'Pembeli');
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
                          await sendMessageKurirkePembeli(
                              13,
                              _messageController.text.trim(),
                              widget.id_pembeli,
                              'Pembeli');
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

class chatBubbleKurirPembeli extends StatelessWidget {
  final String text;
  final bool isReceiverPembeli;

  const chatBubbleKurirPembeli(
      {super.key, required this.text, required this.isReceiverPembeli});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: !isReceiverPembeli ? Colors.grey[300] : Colors.green[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}
