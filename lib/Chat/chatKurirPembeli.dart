// chatPembeliKurir
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'lib/api/Raphael_api_chat.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tubes_ppb/api/api_loginKurir.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  // Use a StreamController to manage message updates
  late Stream<List<Map<String, dynamic>>> _kurirMessages;

  @override
  void initState() {
    super.initState();
    // Initialize the message stream
    _kurirMessages = _getKurirMessagesStream();
  }

  Stream<List<Map<String, dynamic>>> _getKurirMessagesStream() async* {
    while (true) {
      try {
        // Fetch latest messages from the API
        final messages = await fetchchatkurir();
        yield messages;
      } catch (e) {
        print('Error fetching courier messages: $e');
        yield [];
      }
      // Wait before next update
      await Future.delayed(const Duration(seconds: 2));
    }
  }

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
                  messagesStream: _kurirMessages,
                  onSelected: (selectedMessage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KurirPembeliChatPage(
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _kurirMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
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
                trailing: Text(item['sent_at'] != null
                    ? DateFormat('HH:mm').format(
                        DateFormat("HH:mm:ss.SSSSSS").parse(item['sent_at']))
                    : 'Unknown time'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KurirPembeliChatPage(
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
  final Stream<List<Map<String, dynamic>>> messagesStream;
  final ValueChanged<Map<String, dynamic>> onSelected;
  List<Map<String, dynamic>> _cachedMessages = [];

  MessageSearchDelegate({
    required this.messagesStream,
    required this.onSelected,
  }) {
    // Initialize cache from stream
    messagesStream.listen((messages) {
      _cachedMessages = messages;
    });
  }

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
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Terjadi kesalahan: ${snapshot.error}'),
          );
        }

        // Use cached messages if stream hasn't emitted yet
        final messages = snapshot.data ?? _cachedMessages;

        if (messages.isEmpty) {
          return const Center(child: Text('Tidak ada pesan.'));
        }

        final results = messages.where((message) {
          final nameMatches = message['nama_lengkap']
              .toLowerCase()
              .contains(query.toLowerCase());
          final messageMatches =
              message['message'].toLowerCase().contains(query.toLowerCase());
          return nameMatches || messageMatches;
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

class KurirPembeliChatPage extends StatefulWidget {
  final String sender;
  final int id_pembeli;

  const KurirPembeliChatPage(
      {super.key, required this.sender, required this.id_pembeli});

  @override
  _KurirPembeliChatPageState createState() => _KurirPembeliChatPageState();
}

class _KurirPembeliChatPageState extends State<KurirPembeliChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _previousMessages = [];

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'kurir_pembeli_message_channel_id',
      'New Pembeli Message Notifications',
      channelDescription: 'Notifications for new chat messages from buyers',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      2, // Different ID from other notifications
      widget.sender,
      message,
      platformChannelSpecifics,
    );
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      final newMessages =
          await fetchMessagesByKurirAndPembeli(widget.id_pembeli);

      if (_previousMessages.isNotEmpty &&
          newMessages.length > _previousMessages.length) {
        final latestMessage = newMessages.last;

        // Check if the message is from Pembeli (not sent by Kurir)
        if (latestMessage['receiver_type'] != "Pembeli") {
          _showNotification(latestMessage['message']);
        }
      }

      _previousMessages = List.from(newMessages);
      yield newMessages;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No messages available.'));
          }

          final messages = snapshot.data!;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isReceiverPembeli =
                        message['receiver_type'] == "Pembeli";
                    final sentAt = message['sent_at'] != null
                        ? DateFormat('HH:mm').format(
                            DateFormat("HH:mm:ss.SSSSSS")
                                .parse(message['sent_at']))
                        : 'Unknown time';

                    return Row(
                      mainAxisAlignment: isReceiverPembeli
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isReceiverPembeli)
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('assets/Profilepic.png'),
                          ),
                        if (!isReceiverPembeli) const SizedBox(width: 8),
                        chatBubbleKurirPembeli(
                          text: message['message'],
                          isReceiverPembeli: isReceiverPembeli,
                          sentAt: sentAt,
                        ),
                        if (isReceiverPembeli) const SizedBox(width: 8),
                        if (isReceiverPembeli)
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('assets/Profilepic.png'),
                          ),
                      ],
                    );
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
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
                      value.trim(), 'Pembeli', widget.id_pembeli);
                  _messageController.clear();
                  _scrollToBottom();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_messageController.text.trim().isNotEmpty) {
                await sendMessageKurirkePembeli(_messageController.text.trim(),
                    'Pembeli', widget.id_pembeli);
                _messageController.clear();
                _scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class chatBubbleKurirPembeli extends StatelessWidget {
  final String text;
  final String sentAt;
  final bool isReceiverPembeli;

  const chatBubbleKurirPembeli(
      {super.key,
      required this.text,
      required this.isReceiverPembeli,
      required this.sentAt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isReceiverPembeli ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
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
