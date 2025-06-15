import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart'; 
import 'package:tubes_ppb/api/api_loginPembeli.dart';
import 'package:google_fonts/google_fonts.dart';


class OTPScreen extends StatefulWidget {
  final String email;
  final String hash;
  final int userId;

  const OTPScreen({
    Key? key,
    required this.email,
    required this.hash,
    required this.userId,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    if (formKey.currentState?.validate() != true) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://umkmapi-production.up.railway.app/api/pembeli/verify-otp'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': widget.email,
          'otp': otpController.text,
          'hash': widget.hash,
        }),
      );

      if (response.statusCode == 200) {
        sessionId = widget.userId;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('sessionId', widget.userId);
        await prefs.setString('userRole', 'pembeli');

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homepage()),
          (Route<dynamic> route) => false,
        );
      } else {
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? 'OTP tidak valid.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifikasi OTP', style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor:  const Color.fromARGB(255, 101, 136, 100),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop(); 
        },
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Masukkan 4 digit kode OTP yang dikirim ke Spam Email:\n${widget.email}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: otpController,
                      keyboardType: TextInputType.text,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, letterSpacing: 16),
                      decoration: InputDecoration(
                        hintText: 'O T P',
                        counterText: "", 
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'OTP tidak boleh kosong';
                        }
                        if (value.length < 4) {
                          return 'OTP harus 4 digit';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Color.fromARGB(255, 101, 136, 100),
                              padding: EdgeInsets.symmetric(vertical: 16),
                               shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            onPressed: _verifyOTP,
                            child: Text(
                              'Verifikasi',
                              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
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