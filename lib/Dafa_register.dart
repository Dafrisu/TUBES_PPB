import 'package:flutter/material.dart';
//route
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/login.dart';
import 'package:tubes_ppb/register_kurir.dart';
import 'api/api_registerPembeli.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();
  final telephoneController = TextEditingController();
  final usernameController = TextEditingController();
  final alamatController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$');
  final telephoneRegex = RegExp(r'^\+?[\d\s]{10,15}$');
  String? selectedRole = 'pembeli';

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan password';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Memiliki minimal 8 karakter, termasuk satu huruf besar, satu huruf kecil, satu angka, dan satu karakter spesial';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan konfirmasi password ';
    } else if (value != passwordController.text) {
      return 'password tidak sama';
    }
    return null;
  }

  String? validateTelephone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan nomor telepon';
    } else if (!telephoneRegex.hasMatch(value)) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    namaController.dispose();
    telephoneController.dispose();
    usernameController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 101, 136, 100),
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
          ' ',
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Register',
                          style: GoogleFonts.montserrat(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text('Pilih Role Anda',
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
                          });
                          if (value == 'kurir') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterKurir(),
                              ),
                            );
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tolong pilih pendaftaran';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Text('Nama',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextFormField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nama',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tolong masukkan nama';
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
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 10),
                      Text('Username',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tolong masukkan username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Text('Password',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          border: OutlineInputBorder(),
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 10),
                      Text('Konfirmasi Password',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !_confirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Konfirmasi Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible = !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: validateConfirmPassword,
                      ),
                      const SizedBox(height: 10),
                      Text('Nomor Telepon',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextFormField(
                        controller: telephoneController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Nomor Telepon',
                          border: OutlineInputBorder(),
                        ),
                        validator: validateTelephone,
                      ),
                      const SizedBox(height: 10),
                      Text('Alamat',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextFormField(
                        controller: alamatController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Alamat',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tolong masukkan alamat ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 101, 136, 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            bool isRegistered = false;
                            if (selectedRole == 'kurir') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterKurir(),
                                ),
                              );
                            } else {
                              isRegistered = await registerPembeli(
                                namaController.text.trim(),
                                telephoneController.text.trim(),
                                usernameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                alamatController.text.trim(),
                              );
                            }
                  
                            print('isRegistered: $isRegistered');
                  
                            if (!mounted) return;
                  
                            if (isRegistered) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Registrasi Berhasil! harap login kembali')),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => login(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Email atau Username sudah digunakan')),
                              );
                            }
                          }
                        },
                        child: Text('Register!',
                            style: GoogleFonts.montserrat(
                                    fontSize: 20, color: Colors.white)
                                .copyWith(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
