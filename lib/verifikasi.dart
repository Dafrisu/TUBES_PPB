import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tubes_ppb/homepage.dart';

class verifikasi extends StatelessWidget {
  const verifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Kode Verifikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Masukkan Kode Verifikasi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
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
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode Verifikasi Benar')));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const homePage(),
                      ),
                    );
                  }
                },
                child: const Text('Verifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}