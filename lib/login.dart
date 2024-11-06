import 'package:flutter/material.dart';
import 'package:tubes_ppb/formGantiPassword.dart';
import 'package:tubes_ppb/kurir.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/register.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const landingPage(),
              ),
            );
          },
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Login!',
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
              Center(
                child: Text('Selamat Datang Kembali',
                    style: GoogleFonts.montserrat(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Text('Email',  
                  style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700)),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Masukkan Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('Password', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Masukkan Password',),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Formgantipassword()),
                        );
                      },
                      child: Text('Lupa Password?', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      if (emailController.text == '@kurir') {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp(), 
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(),
                          ),
                        );
                      }
                  }
                },
                child:
                    const Text('Masuk', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Tidak Memiliki akun?", 
                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const register(),
                        ),
                      );
                    },
                    child: Text('Register', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
