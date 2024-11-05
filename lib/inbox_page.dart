import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  InboxPage({super.key});

  final List<Map<String, dynamic>> messages = [
    {
      'name': 'Asep Montir',
      'status': 'Siiipp',
      'time': '16:20',
      'image': 'https://example.com/avatar.jpg',
    },
    {
      'name': 'Rio Menteng - Driver',
      'status': 'oke',
      'time': '16:20',
      'image': 'https://example.com/avatar.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FBC94),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kotak Masuk',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Container(
            color: Colors.grey[200],
            margin: const EdgeInsets.only(bottom: 1),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(message['image']),
                backgroundColor: Colors.grey[300],
              ),
              title: Text(
                message['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(message['status']),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message['time'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle message tap
              },
            ),
          );
        },
      ),
    );
  }
}