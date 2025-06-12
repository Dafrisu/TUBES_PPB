import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/verifikasi_otp_ganti_pass.dart'; 

class Masukkanemail extends StatefulWidget {
  const Masukkanemail({super.key});

  @override
  State<Masukkanemail> createState() => _MasukkanemailState();
}

class _MasukkanemailState extends State<Masukkanemail> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void _handleSendOTP() async {
    if (formKey.currentState?.validate() != true) return;
    setState(() => isLoading = true);
    bool emailExists = await checkPembeliByEmail(emailController.text);

    if (mounted && emailExists) {
      try {
        var response = await sendPasswordResetOTP(emailController.text);
        String otpHash = (response.data?.hash as String?) ?? '';
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifikasiOtpGantiPass(
                email: emailController.text,
                otpHash: otpHash,
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "OTP terkirim! Mohon periksa folder spam email Anda."),
              duration: Duration(seconds: 5), 
            ),
          );
        }
      } catch (e) {
        // Tampilkan pesan error jika gagal mengirim OTP
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengirim OTP.')),
          );
        }
      }
    } else if (mounted) {
      // pesan error jika email tidak ditemukan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak ditemukan')),
      );
    }

    // Sembunyikan loading setelah selesai
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const login(),
              ),
            );
          },
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Lupa Password',
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
                      'Masukkan Email Anda',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email Anda';
                        }
                        // Validasi format email sederhana
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Masukkan format email yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Tampilkan loading atau tombol
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            onPressed: _handleSendOTP,
                            child: const Text('Kirim',
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
