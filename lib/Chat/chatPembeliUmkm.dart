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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:async/async.dart'; // For StreamGroup and CombineLatestStream
import 'dart:async'; // For Stream functionality
import 'package:rxdart/rxdart.dart'; // For CombineLatestStream

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
  // Create stream controllers to manage message streams
  final StreamController<List<Map<String, dynamic>>> _pembeliStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final StreamController<List<Map<String, dynamic>>> _kurirStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  // Expose streams
  Stream<List<Map<String, dynamic>>> get pembeliStream =>
      _pembeliStreamController.stream;
  Stream<List<Map<String, dynamic>>> get kurirStream =>
      _kurirStreamController.stream;

  // Timer for periodic updates
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _startMessageStreaming();
  }

  void _startMessageStreaming() {
    // Initial load of messages
    _fetchAndStreamMessages();

    // Set up periodic polling with a timer instead of recursive Future.delayed
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _fetchAndStreamMessages();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _fetchAndStreamMessages() async {
    try {
      // Fetch latest messages
      final List<Map<String, dynamic>> pembeliMessages =
          await fetchchatpembeli();
      final List<Map<String, dynamic>> kurirMessages = await fetchchatkurir();

      // Add to stream controllers
      if (mounted) {
        _pembeliStreamController.add(pembeliMessages);
        _kurirStreamController.add(kurirMessages);
      }
    } catch (e) {
      print('Error fetching messages: $e');
      // Add empty lists on error to prevent stream errors
      if (mounted) {
        _pembeliStreamController.add([]);
        _kurirStreamController.add([]);
      }
    }
  }

  @override
  void dispose() {
    // Clean up resources
    _pollingTimer?.cancel();
    _pembeliStreamController.close();
    _kurirStreamController.close();
    super.dispose();
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
              // Use the streams for search
              showSearch(
                context: context,
                delegate: MessageSearchDelegate(
                  pembeliStream: pembeliStream,
                  kurirStream: kurirStream,
                  onSelected: (selectedMessage) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => selectedMessage['isKurir']
                            ? PembeliKurirChatPage(
                                sender: selectedMessage['nama_kurir'] ??
                                    'Unknown Kurir',
                                kurirSessionId:
                                    selectedMessage['id_kurir'] ?? 0)
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
      body: StreamBuilder<List<List<Map<String, dynamic>>>>(
        stream: CombineLatestStream.list([pembeliStream, kurirStream]),
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
                        .format(DateFormat("HH:mm").parse(item['sent_at']))
                    : 'Unknown time'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => item['isKurir']
                          ? PembeliKurirChatPage(
                              sender: item['nama_kurir'] ?? 'Unknown Kurir',
                              kurirSessionId: item['id_kurir'] ?? 0)
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
  final Stream<List<Map<String, dynamic>>> pembeliStream;
  final Stream<List<Map<String, dynamic>>> kurirStream;
  final Function(Map<String, dynamic>) onSelected;
  List<Map<String, dynamic>>? _pembeliCache;
  List<Map<String, dynamic>>? _kurirCache;

  MessageSearchDelegate({
    required this.pembeliStream,
    required this.kurirStream,
    required this.onSelected,
  }) {
    // Initialize cache from streams
    pembeliStream.listen((data) {
      _pembeliCache = data;
    });
    kurirStream.listen((data) {
      _kurirCache = data;
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
    return StreamBuilder<List<List<Map<String, dynamic>>>>(
      stream: CombineLatestStream.list([pembeliStream, kurirStream]),
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

        final lowerCaseQuery = query.toLowerCase();

        // Combine and filter messages
        final inboxMessages = [
          ...List<Map<String, dynamic>>.from(snapshot.data![0])
              .map((msg) => {...msg, 'isKurir': false}),
          ...List<Map<String, dynamic>>.from(snapshot.data![1])
              .map((msg) => {...msg, 'isKurir': true}),
        ];

        final filteredMessages = inboxMessages.where((msg) {
          final searchField =
              msg['isKurir'] ? msg['nama_kurir'] ?? '' : msg['username'] ?? '';
          final messageContent = msg['message'] ?? '';

          return searchField.toLowerCase().contains(lowerCaseQuery) ||
              messageContent.toLowerCase().contains(lowerCaseQuery);
        }).toList();

        // Sort messages by ID in descending order
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
                  ? DateFormat('HH:mm').format(
                      DateFormat("HH:mm:ss.SSSSSS").parse(item['sent_at']))
                  : 'Unknown time'),
              onTap: () {
                onSelected(item);
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
      'message_channel_id',
      'New Message Notifications',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      widget.sender,
      message,
      platformChannelSpecifics,
    );
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      final newMessages = await fetchMessagesByPembeliAndUMKM(widget.id_umkm);

      if (_previousMessages.isNotEmpty &&
          newMessages.length > _previousMessages.length) {
        final latestMessage = newMessages.last;

        // Check if the message is from UMKM (not sent by Pembeli)
        if (latestMessage['receiver_type'] != "UMKM") {
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final messages = snapshot.data ?? [];

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
                    final isReceiverUMKM = message['receiver_type'] == "UMKM";
                    final sentAt = message['sent_at'] != null
                        ? DateFormat('HH:mm').format(
                            DateFormat("HH:mm:ss.SSSSSS")
                                .parse(message['sent_at']))
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
                                AssetImage('assets/Profilepic.png'),
                          ),
                        if (!isReceiverUMKM) const SizedBox(width: 8),
                        chatBubblePembeliUmkm(
                          text: message['message'],
                          isReceiverUMKM: isReceiverUMKM,
                          sentAt: sentAt,
                        ),
                        if (isReceiverUMKM) const SizedBox(width: 8),
                        if (isReceiverUMKM)
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
                  await sendMessagePembeliKeUMKM(
                      value.trim(), widget.id_umkm, 'UMKM');
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
                await sendMessagePembeliKeUMKM(
                    _messageController.text.trim(), widget.id_umkm, 'UMKM');
                _messageController.clear();
                _scrollToBottom();
              }
            },
          ),
        ],
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
