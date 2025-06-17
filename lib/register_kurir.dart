import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_ppb/Dafa_register.dart';
import 'package:tubes_ppb/api/api_registerKurir.dart';
import 'package:tubes_ppb/landing.dart';
import 'package:tubes_ppb/login.dart';

class RegisterKurir extends StatefulWidget {
  const RegisterKurir({super.key});

  @override
  _RegisterKurirState createState() => _RegisterKurirState();
}

class _RegisterKurirState extends State<RegisterKurir> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namaController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nomorTeleponController = TextEditingController();
  String? selectedRole = 'kurir';
  String? selectedUMKM;
  List<dynamic> umkmList = [];

  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    loadUMKM();
  }

  Future<void> loadUMKM() async {
    try {
      final umkmData = await fetchUMKM();
      if (mounted) {
        setState(() {
          umkmList = umkmData;
        });
      }
    } catch (error) {
      print('Failed to load UMKM data: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data UMKM: $error')),
        );
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan email ';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan password ';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password min. 8 karakter, kombinasi huruf besar, kecil, angka, & simbol';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan konfirmasi password ';
    } else if (value != passwordController.text) {
      return 'Konfirmasi password  tidak sama';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    namaController.dispose();
    confirmPasswordController.dispose();
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
          '',
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text('Register Kurir',
                            style: GoogleFonts.montserrat(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Text('Pilih Role Anda',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
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
                            if (value == 'pembeli') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Text('Nama',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        TextFormField(
                          controller: namaController,
                          decoration: const InputDecoration(
                              hintText: 'Masukkan Nama ',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tolong masukkan nama ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text('Nomor Telepon',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        TextFormField(
                          controller: nomorTeleponController,
                          decoration: const InputDecoration(
                              hintText: 'Masukkan Nomor Telepon ',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tolong masukkan nomor telepon ';
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
                              hintText: 'Masukkan Email ',
                              border: OutlineInputBorder()),
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 10),
                        Text('Password',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Password ',
                            border: const OutlineInputBorder(),
                            errorMaxLines: 3,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible =
                                      !_passwordVisible;
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
                              hintText: 'Masukkan Konfirmasi Password ',
                              border: OutlineInputBorder(),
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
                        Text('Pilih UMKM',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: selectedUMKM,
                          hint:
                              umkmList.isEmpty ? Text('Memuat data...') : null,
                          items: umkmList.map((umkm) {
                            return DropdownMenuItem<String>(
                              value: umkm['id_umkm'].toString(),
                              child: Text(umkm['nama_usaha'] ?? 'Tanpa Nama'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedUMKM = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tolong pilih UMKM';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Color.fromARGB(255, 101, 136, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () async {
                            if (formKey.currentState?.validate() == true) {
                              bool isRegistered = await registerKurir(
                                  emailController.text.trim(),
                                  namaController.text.trim(),
                                  passwordController.text.trim(),
                                  selectedUMKM!,
                                  nomorTeleponController.text.trim());
                              if (!mounted) return;

                              if (isRegistered) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Registrasi Berhasil! Silakan login.')),
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Registrasi gagal. Email mungkin sudah digunakan.')),
                                );
                              }
                            }
                          },
                          child: Text('Register!',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
