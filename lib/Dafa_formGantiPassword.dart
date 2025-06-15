// lib/Dafa_formGantiPassword.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:tubes_ppb/login.dart';

// 1. Ubah menjadi StatefulWidget
class Formgantipassword extends StatefulWidget {
  final String email;
  const Formgantipassword({super.key, required this.email});

  @override
  State<Formgantipassword> createState() => _FormgantipasswordState();
}

class _FormgantipasswordState extends State<Formgantipassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  
  // Tambahkan state untuk loading
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Buat fungsi terpisah untuk menangani logika
  void _handleChangePassword() async {
    if (formKey.currentState?.validate() != true) return;
    
    setState(() => isLoading = true);
    
    bool isSuccess = await changePassword(widget.email, passwordController.text);
    
    // Pastikan widget masih ada sebelum melanjutkan
    if (!mounted) return;

    setState(() => isLoading = false);

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil diubah. Silakan login kembali.")),
      );
      // 2. Gunakan pushAndRemoveUntil untuk navigasi yang bersih
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const login()), 
          (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengubah password.")),
      );
    }
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 101, 136, 100),
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: Text(
          'Masukkan Password Baru',
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Password Baru',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        border: const OutlineInputBorder(),
                        errorMaxLines: 3,
                        suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                      ),
                      
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Password Baru';
                        } else if (!passwordRegex.hasMatch(value)) {
                          return 'Password minimal 8 karakter, harus mengandung huruf besar, kecil, angka, dan simbol';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi Password Baru';
                        } else if (value != passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Tampilkan loading atau tombol
                    isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Color.fromARGB(255, 101, 136, 100),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: _handleChangePassword,
                          child: const Text('Ubah Password',
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}