import 'package:flutter/material.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:tubes_ppb/Dafa_formGantiPassword.dart'; 
import 'package:google_fonts/google_fonts.dart';

class VerifikasiOtpGantiPass extends StatefulWidget {
  final String email;
  final String otpHash;

  const VerifikasiOtpGantiPass(
      {Key? key, required this.email, required this.otpHash})
      : super(key: key);

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

  if (!mounted) return;

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
      appBar: AppBar(
        title: Text(
          'Verifikasi OTP',
          style: GoogleFonts.montserrat(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 136, 100),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      "Masukkan kode OTP yang telah dikirim ke Spam Email:\n${widget.email}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: otpController,
                    decoration: const InputDecoration(
                      hintText: 'O T P',
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 16),
                    keyboardType: TextInputType.text,
                    maxLength: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'OTP tidak boleh kosong';
                      }
                      if (value.length < 4) {
                        return 'OTP harus 4 digit';
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const RoundedRectangleBorder(),
                          ),
                          onPressed: _handleVerification,
                          child: Text(
                            "Verifikasi",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}