import 'package:flutter/material.dart'; 

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/otp_screen.dart'; 

int sessionId = 0;
// Future<List<Map<String, dynamic>>> profilePembeli = fetchUserData(sessionId);
Future<Map<String, dynamic>?> profilePembeli = Future.value(null);
// List<Map<String, dynamic>> getProfilePembeli = await profilePembeli;

Future<void> fetchLogin(BuildContext context, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('https://umkmapi-production.up.railway.app/loginpembeli'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Logika baru: Navigasi ke halaman OTP, bukan simpan session
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            email: data['email'],
            hash: data['hash'],
            userId: data['id_pembeli'],
          ),
        ),
      );
    } else {
      // Menampilkan pesan error dari server jika ada
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body.toString())),
      );
    }
  } catch (error) {
    // Menampilkan error jika tidak bisa terhubung ke server
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Gagal terhubung ke server.')));
    print(error);
  }
}

Future<Map<String, dynamic>> fetchUserData(int userId) async {
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/pembeli/$sessionId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Gagal load User Pembeli');
    }
  } catch (error) {
    print(error);
    return {};
  }
}

void nullifyProfilePembeli() {
  profilePembeli = Future.value(null);
}

void printdata() async {
  Map<String, dynamic> keranjang = await profilePembeli ?? {};
  keranjang.forEach((key, value) {
    print('$key: $value');
  });
}
