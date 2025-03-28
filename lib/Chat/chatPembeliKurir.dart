// chatPembeliKurir
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'lib/api/Raphael_api_chat.dart';
import 'package:http/http.dart' as http;
import 'chatPembeliUmkm.dart';
import 'package:intl/intl.dart';

class PembeliKurirChatPage extends StatefulWidget {
  final String sender;
  final int kurirSessionId;

  const PembeliKurirChatPage(
      {super.key, required this.sender, required this.kurirSessionId});

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
        future: fetchMessagesByPembeliAndKurir(),
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
                          sentAt: message['sent_at'] != null
                              ? DateFormat('HH:mm').format(
                                  DateFormat("HH:mm:ss.SSSSSS")
                                      .parse(message['sent_at']))
                              : 'Unknown time',
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
                            int id_pembeli = prefs.getInt('id_pembeli') ?? 0;
                            int kurirSessionId = prefs.getInt('id_kurir') ?? 0;
                            await sendMessagePembeliKeKurir(
                                value.trim(), widget.kurirSessionId, 'Kurir');
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
                          int id_pembeli = prefs.getInt('id_pembeli') ?? 0;
                          int id_kurir = prefs.getInt('id_kurir') ?? 0;
                          await sendMessagePembeliKeKurir(
                              _messageController.text.trim(),
                              widget.kurirSessionId,
                              'Kurir');
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
