import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'berhasil_hapus_akun.dart';
import 'dart:io';

class AccountDeletion extends StatefulWidget {
  final String userId;

  const AccountDeletion({super.key, required this.userId});

  @override
  State<AccountDeletion> createState() => _AccountDeletionState();
}

class _AccountDeletionState extends State<AccountDeletion> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoading = false;
  bool isPasswordVisible = false;

  late String defaultImg =
      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";
  String fetchedEmail = '';
  String fetchedPassword = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fetchUserData(widget.userId);
  }

  Future<void> fetchUserData(String userId) async {
    final response = await http.get(
      Uri.parse('https://umkmapi-production.up.railway.app/pembeli/$userId'),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        fetchedEmail = userData['email'];
        fetchedPassword = userData['password'];
        profileImageUrl = userData['profileImg'] ?? ''; // Handle null case
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (emailController.text != fetchedEmail ||
          passwordController.text != fetchedPassword) {
        throw Exception('Invalid credentials');
      }

      final response = await http.delete(
        Uri.parse(
            'https://umkmapi-production.up.railway.app/pembeli/${widget.userId}'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeleteAccount()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString() == 'Exception: Invalid credentials'
              ? 'Email atau password salah'
              : 'Gagal menghapus akun. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C4C4C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              ClipOval(
                child: (profileImageUrl.isEmpty)
                    ? Image.network(
                        defaultImg, // Default image URL
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : profileImageUrl.startsWith('/')
                        ? FutureBuilder<bool>(
                            future: File(profileImageUrl).exists(),
                            builder: (context, fileSnapshot) {
                              if (fileSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (fileSnapshot.hasError ||
                                  !fileSnapshot.data!) {
                                // File does not exist, show default image
                                return Image.network(
                                  defaultImg, // Default image URL
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                // File exists, show the image
                                return Image.file(
                                  File(profileImageUrl),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          )
                        : CachedNetworkImage(
                            imageUrl: profileImageUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.network(
                              defaultImg, // Default image URL
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Hapus Akun',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Peringatan: Menghapus akun Anda akan menghapus semua data yang terkait dengan akun Anda secara permanen. Harap pastikan bahwa Anda benar-benar ingin melakukan ini.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _deleteAccount(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Hapus Akun'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
