import 'package:flutter/material.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/api/api_gantiPassword.dart';

class Formgantipassword extends StatelessWidget {
  final String email;
  const Formgantipassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Password')),
      body: Padding(
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
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Password Baru';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    await changePassword(email, passwordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password sudah di set ulang')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const login(),
                      ),
                    );
                  }
                },
                child: const Text('Ubah Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}