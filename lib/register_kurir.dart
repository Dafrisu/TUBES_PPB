import 'package:flutter/material.dart';
import 'package:tubes_ppb/Dafa_register.dart';
import 'package:tubes_ppb/api/api_registerPembeli.dart';
import 'package:tubes_ppb/landing.dart';
import 'api/api_registerKurir.dart';

//packages
import 'package:google_fonts/google_fonts.dart';

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
  // final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? selectedRole = 'kurir';
  String? selectedUMKM;
  List<dynamic> umkmList = [];
  
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  @override
  void initState() {
    super.initState();
    loadUMKM();
  }

   Future<void> loadUMKM() async {
    try {
      final umkmData = await fetchUMKM();
      setState(() {
        umkmList = umkmData;
      });
    } catch (error) {
      print('Failed to load UMKM data: $error');
    }
  }

  

   String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan email anda';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Tolong masukkan password anda';
  } else if (!passwordRegex.hasMatch(value)) {
    return 'Password harus memiliki minimal 8 karakter, termasuk satu huruf besar, satu huruf kecil, satu angka, dan satu karakter spesial';
  }
  return null;
}

 String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan konfirmasi password anda';
    } else if (value != passwordController.text) {
      return 'konfirmasi password anda tidak sama';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    namaController.dispose();
    // usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          ' ',
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Register Kurir',
                    style: GoogleFonts.montserrat(
                        fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                  Text('Pilih Role Anda ',
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
                    if (value == 'pembeli') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
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
                  decoration:
                      const InputDecoration(labelText: 'Masukkan Nama Anda', border: OutlineInputBorder(),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan nama anda';
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
                  decoration:
                      const InputDecoration(labelText: 'Masukkan Email Anda', border: OutlineInputBorder(),),
                  validator: validateEmail,
                ),
                const SizedBox(height: 10),
                // Text('Username',
                //     style: GoogleFonts.montserrat(
                //         fontSize: 16, fontWeight: FontWeight.w700)),
                // TextFormField(
                //   controller: usernameController,
                //   decoration: const InputDecoration(
                //       labelText: 'Masukkan Username Anda'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Tolong masukkan username anda';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 10),
                Text('Password',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Masukkan Password Anda', border: OutlineInputBorder(),),
                  obscureText: true,
                  validator: validatePassword,
                ),
                const SizedBox(height: 10),
                 Text('Konfirmasi Password',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                      labelText: 'Masukkan Konfirmasi Password Anda', border: OutlineInputBorder(),),
                  obscureText: true,
                  validator: validateConfirmPassword,
                ),
                const SizedBox(height: 10),
                Text('Pilih UMKM',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: selectedUMKM,
                  items: umkmList.map((umkm) {
                    return DropdownMenuItem<String>(
                      value: umkm['id_umkm'].toString(),
                      child: Text(umkm['nama_usaha']),
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
                    backgroundColor: Colors.green,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      bool isRegistered = await registerKurir(
                        emailController.text.trim(),
                        namaController.text.trim(),
                        passwordController.text.trim(),
                        selectedUMKM!,
                      );
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
                            builder: (context) => landingPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Email sudah digunakan')),
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
      ),
    );
  }
}