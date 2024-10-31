import 'package:flutter/material.dart';

// ignore: camel_case_types
class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _editProfileState createState() => _editProfileState();
}

// ignore: camel_case_types
class _editProfileState extends State<editProfile> {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userData["profileImageUrl"]),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Handle profile image change logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Rest of the TextFormField widgets
                  TextFormField(
                    controller:
                        TextEditingController(text: userData["fullName"]),
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      userData["fullName"] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: TextEditingController(text: userData["email"]),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      userData["email"] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: TextEditingController(text: userData["phone"]),
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      userData["phone"] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:
                        TextEditingController(text: userData["address"]),
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      userData["address"] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:
                        TextEditingController(text: userData["username"]),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      userData["username"] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller:
                        TextEditingController(text: userData["password"]),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      userData["password"] = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Save the changes and update the userData
                      // You can add your save logic here
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
