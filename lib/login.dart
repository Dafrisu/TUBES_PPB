import 'package:flutter/material.dart';
import 'masukkanEmail.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/Dafa_register.dart';
import 'api/api_loginPembeli.dart';

import 'package:tubes_ppb/login_kurir.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<login> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole = 'pembeli';

  bool _loginPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 136, 100),
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
          'Login',
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
                    Center(
                      child: Text('Selamat Datang Kembali',
                          style: GoogleFonts.montserrat(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                    Text('Pilih Role',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: selectedRole,
                      items: [
                        DropdownMenuItem(
                          value: 'pembeli',
                          child: Text('Pembeli'),
                        ),
                        DropdownMenuItem(
                          value: 'kurir',
                          child: Text('Kurir'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                          if (value == 'kurir') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginKurir(),
                              ),
                            );
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tolong pilih role anda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text('Email',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Email Anda';
                        }
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!regex.hasMatch(value)) {
                          return 'Email Tidak Valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text('Password',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_loginPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Password',
                        border: OutlineInputBorder(),
                        errorMaxLines: 3,
                        suffixIcon: IconButton(
                        icon: Icon(
                          _loginPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _loginPasswordVisible = !_loginPasswordVisible;
                          });
                        },
                      ),
                      ),
                      
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tolong Masukkan Password Anda';
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
                                    builder: (context) =>
                                        const Masukkanemail()),
                              );
                            },
                            child: Text('Lupa Password?',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color.fromARGB(255, 101, 136, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      onPressed: () async {
                        if (formKey.currentState?.validate() == true) {
                          if (selectedRole == 'pembeli') {
                            await fetchLogin(context, emailController.text,
                                passwordController.text);
                          } else if (selectedRole == 'kurir') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginKurir(),
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Masuk',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Tidak Memiliki akun?",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
                              ),
                            );
                          },
                          child: Text('Register',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w400,),
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.clip,),
                        ),
                      ],
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
