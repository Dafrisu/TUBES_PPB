// lib/verifikasi_otp_ganti_pass.dart

import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:tubes_ppb/Dafa_formGantiPassword.dart'; // Halaman selanjutnya

class VerifikasiOtpGantiPass extends StatefulWidget {
  final String email;
  final String otpHash;

  const VerifikasiOtpGantiPass({Key? key, required this.email, required this.otpHash}) : super(key: key);

  @override
  _VerifikasiOtpGantiPassState createState() => _VerifikasiOtpGantiPassState();
}

class _VerifikasiOtpGantiPassState extends State<VerifikasiOtpGantiPass> {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _handleVerification() async {
    if (formKey.currentState?.validate() != true) return;
    
    setState(() => isLoading = true);
    bool isValid = await verifyOTP(widget.email, widget.otpHash, otpController.text);
    setState(() => isLoading = false);

    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Formgantipassword(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP salah atau telah kedaluwarsa.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi Kode OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Masukkan kode OTP yang telah dikirim ke ${widget.email}"),
              const SizedBox(height: 20),
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(labelText: 'Kode OTP', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => (value?.isEmpty ?? true) ? 'OTP tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _handleVerification, child: const Text("Verifikasi")),
            ],
          ),
        ),
      ),
    );
  }
}