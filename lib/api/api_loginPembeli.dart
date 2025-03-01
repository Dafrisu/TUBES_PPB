import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

int sessionId = 0;
// Future<List<Map<String, dynamic>>> profilePembeli = fetchUserData(sessionId);
Future<Map<String, dynamic>?> profilePembeli = Future.value(null);
// List<Map<String, dynamic>> getProfilePembeli = await profilePembeli;

Future<void> fetchLogin(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('localhost/loginpembeli'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print('Request body: ${jsonEncode(<String, String>{
          'email': email,
          'password': password
        })}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      sessionId = data['id_pembeli'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('sessionId', sessionId);
    } else {
      throw Exception('Failed to load Pembeli');
    }
  } catch (error) {
    print(error);
  }
}

Future<Map<String, dynamic>> fetchUserData(int userId) async {
  try {
    final response = await http.get(Uri.parse('localhost/pembeli/$sessionId'));

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
