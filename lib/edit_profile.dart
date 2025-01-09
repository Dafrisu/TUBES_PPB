import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tubes_ppb/homepage.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  final Function onProfileUpdated;

  const EditProfile(
      {super.key, required this.userId, required this.onProfileUpdated});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController profilePictureController;

  bool isLoading = true;
  String profilePictureUrl = '';
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    profilePictureController = TextEditingController();

    fetchUserData(widget.userId);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    profilePictureController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://umkmapi.azurewebsites.net/pembeli/$id'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          fullNameController.text = userData['nama_lengkap'];
          emailController.text = userData['email'];
          phoneController.text = userData['nomor_telepon'];
          addressController.text = userData['alamat'];
          usernameController.text = userData['username'];
          passwordController.text = userData['password'];
          profilePictureUrl = userData['profileImg'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data pengguna');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('https://umkmapi.azurewebsites.net/pembeli/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui profil: ${response.body}');
    }
  }

  void _showChangeProfilePictureDialog() {
    profilePictureController.text = profilePictureUrl;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah URL Foto Profil'),
          content: TextField(
            controller: profilePictureController,
            decoration: const InputDecoration(
              labelText: 'URL Foto Profil',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  profilePictureUrl = profilePictureController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
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
          child: const Text(
            'Edit Profil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFC4D79D),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _showChangeProfilePictureDialog,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profilePictureUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _showChangeProfilePictureDialog,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(fullNameController, 'Nama Lengkap'),
                  const SizedBox(height: 16),
                  _buildTextField(emailController, 'Email'),
                  const SizedBox(height: 16),
                  _buildTextField(phoneController, 'Nomor Telepon'),
                  const SizedBox(height: 16),
                  _buildTextField(addressController, 'Alamat'),
                  const SizedBox(height: 16),
                  _buildTextField(usernameController, 'Nama Pengguna'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: !isPasswordVisible,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 375),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedData = {
                          'nama_lengkap': fullNameController.text,
                          'email': emailController.text,
                          'nomor_telepon': phoneController.text,
                          'alamat': addressController.text,
                          'username': usernameController.text,
                          'password': passwordController.text,
                          'profileImg': profilePictureUrl,
                        };
                        try {
                          await updateProfile(widget.userId, updatedData);
                          widget.onProfileUpdated();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profil berhasil diperbarui!')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Kesalahan: ${e.toString()}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Perbarui Profil'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}