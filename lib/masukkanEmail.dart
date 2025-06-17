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

    if (!mounted) return; // Pastikan widget masih ada sebelum melanjutkan

     if (emailExists) {
    try {
      var response = await sendPasswordResetOTP(emailController.text);
      if (!mounted) return;

      String otpHash = (response.data?.hash as String?) ?? '';
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
          content: Text("OTP terkirim! Mohon periksa folder spam email Anda."),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim OTP.')),
      );
    }
  } else {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email tidak ditemukan')),
    );
  }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 101, 136, 100),
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
                        hintText: 'Email',
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
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Color.fromARGB(255, 101, 136, 100),
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
