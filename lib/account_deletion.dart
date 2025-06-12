import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For clearing local data
import 'dart:io';
import 'package:tubes_ppb/login.dart'; // Import your login page

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

  bool isLoading = true; // Set to true initially to show loading state for data fetch
  bool isPasswordVisible = false;

  late String defaultImg =
      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of_social_media_user_vector.jpg";
  String profileImageUrl = ''; // To display user's profile image

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // Fetch user data (including email and profile image) when the page loads
    fetchUserData(widget.userId);
  }

  // --- Fetch User Data Logic ---
  Future<void> fetchUserData(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://umkmapi-production.up.railway.app/pembeli/$userId'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          emailController.text = userData['email'] ?? '';
          profileImageUrl = userData['profileImg'] ?? '';
          isLoading = false; // Data loaded, hide loading indicator
        });
      } else {
        // Handle non-200 status codes
        setState(() {
          profileImageUrl = ''; // Fallback to default image
          isLoading = false; // Stop loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal memuat data pengguna: ${response.statusCode}')),
        );
      }
    } catch (error) {
      // Handle network errors or other exceptions
      setState(() {
        profileImageUrl = ''; // Fallback to default image on network error
        isLoading = false; // Stop loading even if there's an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $error')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- Delete Account Logic ---
  Future<void> _deleteAccount(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true); // Show loading indicator for deletion process

    try {
      final response = await http.delete(
        Uri.parse(
            'https://umkmapi-production.up.railway.app/pembeli/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      // Check mounted state BEFORE any navigation or state updates that rely on the widget being active
      if (!mounted) return;

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clear all data, including sessionId

        // Use the same navigation logic as logout:
        // Pop all routes and push the login page as the new first route.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  const login()), // Navigate to your login page
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau password salah.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        throw Exception(
            'Gagal menghapus akun. Kode status: ${response.statusCode}. Pesan: ${response.body}');
      }
    } catch (e) {
      print('Error deleting account: $e');
      if (!mounted) return; // Re-check mounted state for snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus akun. Silakan coba lagi. ($e)'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return; // Ensure setState isn't called on a disposed widget
      setState(() => isLoading = false); // Always hide loading indicator
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the image widget based on profileImageUrl
    Widget profileImageWidget;
    if (profileImageUrl.isEmpty) {
      // If URL is empty, always use the default network image
      profileImageWidget = Image.network(
        defaultImg,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else if (profileImageUrl.startsWith('/')) {
      // If it's a local file path
      final File localFile = File(profileImageUrl);
      profileImageWidget = FutureBuilder<bool>(
        future: localFile.exists(), // Check if the file exists
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || !snapshot.data!) {
              // File doesn't exist or there was an error, show default image
              return Image.network(
                defaultImg,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              );
            } else {
              // File exists, show it
              return Image.file(
                localFile,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              );
            }
          }
          // While checking for file existence, show a placeholder
          return const CircularProgressIndicator();
        },
      );
    } else {
      // Otherwise, assume it's a network URL
      profileImageWidget = CachedNetworkImage(
        imageUrl: profileImageUrl,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const CircularProgressIndicator(), // Show loading while fetching
        errorWidget: (context, url, error) => Image.network(
          defaultImg, // Fallback if network image fails to load
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

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
              // --- Profile Image Display ---
              ClipOval(
                child: profileImageWidget, // Use the determined image widget
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
              // --- Email Input Field ---
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
              // --- Password Input Field ---
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
              // --- Delete Account Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : () => _deleteAccount(context),
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