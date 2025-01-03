import 'package:flutter/material.dart';
import 'package:tubes_ppb/landing.dart';

import 'Dafa_verifikasi.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

class register extends StatelessWidget {
  const register({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => landingPage(),
              ),
            );
          },
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Masuk',
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
              Text('Register',
                  style: GoogleFonts.montserrat(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text('Email',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Masukkan Email anda'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text('Masukkan Password',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text('Confirm Password',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirm Your Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text('Telephone Number',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Enter Your Telephone Number'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your telephone number';
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
                onPressed: () {
                  if (formKey.currentState?.validate() == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration Successful')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const verifikasi(previousPage: 'register'),
                      ),
                    );
                  }
                },
                child: Text('Register!',
                    style: GoogleFonts.montserrat(
                        fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Login',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.w400)),
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
