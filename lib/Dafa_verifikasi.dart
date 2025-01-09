import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tubes_ppb/Dafa_formGantiPassword.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:google_fonts/google_fonts.dart';

class verifikasi extends StatelessWidget {
  final String previousPage;
  final String email;
  final String otpHash;
  const verifikasi({super.key, required this.previousPage, required this.email, required this.otpHash});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kode Verifikasi'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 101, 136, 100),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text(
                  'Untuk melindungi keamanan akun Anda, kami memerlukan kode verifikasi yang dikirimkan ke email Anda.',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(fontSize: 18))),
              Padding(padding: EdgeInsets.only(bottom: 30)),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Kode Verifikasi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kode verifikasi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 101, 136, 100),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1))),
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    try {
                      bool isVerified = await verifyOTP(email, otpHash, codeController.text);
                      if (isVerified) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Formgantipassword(email: email)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kode verifikasi salah')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}