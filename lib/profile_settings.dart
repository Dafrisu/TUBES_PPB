import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tubes_ppb/edit_profile.dart';
import 'package:tubes_ppb/login.dart';
import 'account_deletion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late Future<Map<String, dynamic>> userDataFuture;
  late String userId; 

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = (prefs.getInt('sessionId') ?? 0).toString(); // Convert int to String

    final response = await http.get(
      Uri.parse('https://umkmapi.azurewebsites.net/pembeli/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _showSignOutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('sessionId'); // Remove the session ID
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const login()), // Navigate to login screen
                );
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4D79D),
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center, // Center the title
          child: const Text(
            'Profil',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Make the text bold
              fontSize: 20, // Optional: Set the font size
            ),
          ),
        ),
        backgroundColor: const Color(0xFFC4D79D), // Set the same color as in EditProfile
        automaticallyImplyLeading: false, // Disable the back button
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: userData['profileImg'],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['nama_lengkap'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
 const SizedBox(height: 5),
                    Text(
                      userData['email'],
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 375),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(userId: userId, onProfileUpdated: () {
                                // Refresh the data when returning from EditProfile
                                setState(() {
                                  userDataFuture = fetchUserData(); // Refresh the data
                                });
                              }),
                            ),
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
                    Container(
                      constraints: const BoxConstraints(maxWidth: 375),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AccountDeletion(userId: userId)),
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
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 375),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showSignOutConfirmationDialog, // Show sign-out confirmation dialog
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
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}