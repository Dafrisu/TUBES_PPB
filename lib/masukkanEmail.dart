import 'package:flutter/material.dart';
import 'package:tubes_ppb/Dafa_verifikasi.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';
import 'package:tubes_ppb/models/gantipass_response_model.dart';

class Masukkanemail extends StatelessWidget {
  const Masukkanemail({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
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
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    bool emailExists = await checkPembeliByEmail(emailController.text);
                    if (emailExists) {
                      GantipassResponseModel response = await gantiPassword(emailController.text);
                      String otpHash = response.data ?? '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Instruksi reset password telah dikirim')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => verifikasi(
                            previousPage: 'masukkanEmail',
                            email: emailController.text,
                            otpHash: otpHash,
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
                child: const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}