// chatPembeliKurirsss
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'lib/api/Raphael_api_chat.dart';
import 'package:http/http.dart' as http;
import 'chatPembeliUmkm.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PembeliKurirChatPage extends StatefulWidget {
  final String sender;
  final int id_kurir;

  const PembeliKurirChatPage(
      {super.key, required this.sender, required this.id_kurir});

  @override
  _PembeliKurirChatPageState createState() => _PembeliKurirChatPageState();
}

class _PembeliKurirChatPageState extends State<PembeliKurirChatPage> {
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
      'kurir_message_channel_id',
      'New Kurir Message Notifications',
      channelDescription: 'Notifications for new chat messages from couriers',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      1, // Different ID from UMKM notifications
      widget.sender,
      message,
      platformChannelSpecifics,
    );
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      final newMessages = await fetchMessagesByPembeliAndKurir(widget.id_kurir);

      if (_previousMessages.isNotEmpty &&
          newMessages.length > _previousMessages.length) {
        final latestMessage = newMessages.last;

        // Check if the message is from Kurir (not sent by Pembeli)
        if (latestMessage['receiver_type'] != "Kurir") {
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
                    final isReceiverKurir = message['receiver_type'] == "Kurir";
                    final sentAt = message['sent_at'] != null
                        ? DateFormat('HH:mm').format(
                            DateFormat("HH:mm:ss.SSSSSS")
                                .parse(message['sent_at']))
                        : 'Unknown time';
                    return Row(
                      mainAxisAlignment: isReceiverKurir
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isReceiverKurir)
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                AssetImage('assets/Profilepic.png'),
                          ),
                        if (!isReceiverKurir) const SizedBox(width: 8),
                        chatBubblePembeliKurir(
                          text: message['message'],
                          isReceiverKurir: isReceiverKurir,
                          sentAt: sentAt,
                        ),
                        if (isReceiverKurir) const SizedBox(width: 8),
                        if (isReceiverKurir)
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
                  await sendMessagePembeliKeKurir(
                      value.trim(), widget.id_kurir, 'Kurir');
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
                await sendMessagePembeliKeKurir(
                    _messageController.text.trim(), widget.id_kurir, 'Kurir');
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

class chatBubblePembeliKurir extends StatelessWidget {
  final String text;
  final String sentAt;
  final bool isReceiverKurir;

  const chatBubblePembeliKurir(
      {super.key,
      required this.text,
      required this.isReceiverKurir,
      required this.sentAt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isReceiverKurir ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: !isReceiverKurir ? Colors.grey[300] : Colors.green[200],
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
