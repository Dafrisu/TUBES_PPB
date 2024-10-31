import 'package:flutter/material.dart';
import 'edit_Profile.dart';
import 'account_deletion.dart';

// ignore: must_be_immutable, camel_case_types
class profileSettings extends StatelessWidget {
  profileSettings({super.key});

  Map<String, dynamic> userData = {
    "id": "109238",
    "fullName": "Asep Lengkap",
    "email": "AsepL@email.co.id",
    "phone": "129384751782",
    "address": "Jalan Boulevard",
    "username": "AsepL",
    "password": "AsepL1onzz",
    "displayName": "Asep Montir",
    "profileImageUrl":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWW0xcyFQPL6DIne-s-4nHzmBuIMCN12FioA&s",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4D79D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userData["profileImageUrl"]),
            ),
            const SizedBox(height: 10),
            Text(
              userData["displayName"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              userData["email"],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 375,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to EditProfile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => editProfile()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.person),
                label: const Text('Pengaturan akun'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 375,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle logout functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Sign Out'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 375,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle account deletion
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountDeletion()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Hapus Akun'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}