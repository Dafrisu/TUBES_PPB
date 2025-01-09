import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'berhasil_hapus_akun.dart';

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
  bool isPasswordVisible = false; // State for password visibility

  // Variables to hold fetched user data
  String fetchedEmail = '';
  String fetchedPassword = '';
  String profileImageUrl = ''; // To hold the profile image URL

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(); // Initialize here
    passwordController = TextEditingController(); // Initialize here
    fetchUserData(widget.userId);
  }

  Future<void> fetchUserData(String userId) async {
    final response = await http.get(
      Uri.parse('https://umkmapi.azurewebsites.net/pembeli/$userId'),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        fetchedEmail = userData['email']; // Store fetched email
        fetchedPassword = userData['password']; // Store fetched password
        profileImageUrl = userData['profileImg'] ?? ''; // Set profile image URL
        // Do not set emailController.text here to keep it empty for user input
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
      // Verify credentials match
      if (emailController.text != fetchedEmail || passwordController.text != fetchedPassword) {
        throw Exception('Invalid credentials');
      }

      // Simulate API call for account deletion
      final response = await http.delete(
        Uri.parse('https://umkmapi.azurewebsites.net/pembeli/${widget.userId}'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account');
      }

      // Navigate to success page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeleteAkun()),
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
                child: CachedNetworkImage(
                  imageUrl: profileImageUrl.isNotEmpty ? profileImageUrl : 'https://example.com/default_image.png', // Fallback image
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator (),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
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
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible, // Toggle password visibility
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
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible; // Toggle the visibility
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
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}