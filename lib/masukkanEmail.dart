import 'package:flutter/material.dart';
import 'package:tubes_ppb/Dafa_verifikasi.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/models/gantipass_response_model.dart';
import 'package:tubes_ppb/Dafa_formGantiPassword.dart';

import 'package:google_fonts/google_fonts.dart';



class Masukkanemail extends StatelessWidget {
  const Masukkanemail({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
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
      body: Padding(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    bool emailExists = await checkPembeliByEmail(emailController.text);
                    if (emailExists) {
                      // GantipassResponseModel response = await gantiPassword(emailController.text);
                      // String otpHash = response.data ?? '';
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Instruksi reset password telah dikirim')),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Formgantipassword(
                           email: emailController.text,    
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email tidak ditemukan')),
                      );
                    }
                  }
                },
                child: const Text('Kirim', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}