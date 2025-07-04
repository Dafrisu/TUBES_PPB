import 'package:flutter/material.dart';
import 'package:tubes_ppb/kurir.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/register_kurir.dart';
import 'api/api_loginKurir.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

class LoginKurir extends StatefulWidget {
  const LoginKurir({super.key});

  @override
  State<LoginKurir> createState() => _LoginKurirState();
}

class _LoginKurirState extends State<LoginKurir> {
   final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedRole = 'kurir';
    bool _kurirPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 136, 100),
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
          'Login Kurir!',
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
                          if (value == 'pembeli') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => login(),
                              ),
                            );
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tolong pilih role ';
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
                        hintText: 'Email ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Email';
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
                      obscureText: !_kurirPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _kurirPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _kurirPasswordVisible = !_kurirPasswordVisible;
                              });
                            },
                          ),
                      ),
                      
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tolong Masukkan Password ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 101, 136, 100),
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: () async {
                        if (formKey.currentState?.validate() == true) {
                          try {
                            bool isLoggedIn = await loginKurir(
                                emailController.text, passwordController.text);
                            if (isLoggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Kurir(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Email atau Password salah'),
                                ),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Terjadi kesalahan, coba lagi nanti'),
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
                                builder: (context) => const RegisterKurir(),
                              ),
                            );
                          },
                          child: Text('Register',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.clip),
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
