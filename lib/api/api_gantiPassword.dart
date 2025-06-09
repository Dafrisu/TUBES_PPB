// lib/api/api_gantiPassword.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tubes_ppb/models/gantipass_response_model.dart'; // Pastikan model ini ada

var client = http.Client();
const String baseUrl = "https://umkmapi-production.up.railway.app"; // Definisikan base URL

// Fungsi untuk mengecek email
Future<bool> checkPembeliByEmail(String email) async {
  try {
    final response = await client.post(
      Uri.parse('$baseUrl/checkPembeliByEmail'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['emailExists'] == true;
    }
    return false;
  } catch (e) {
    print('Error checking email: $e');
    return false;
  }
}

// Fungsi untuk mengirim permintaan OTP
Future<GantipassResponseModel> sendPasswordResetOTP(String email) async {
  try {
    final response = await client.post(
      Uri.parse('$baseUrl/otp/sendOTP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      return gantipassResponseModelFromJson(response.body);
    } else {
      throw Exception('Failed to send OTP');
    }
  } catch (e) {
    throw Exception('Failed to connect to server: $e');
  }
}

// Fungsi untuk verifikasi OTP
Future<bool> verifyOTP(String email, String otpHash, String otpCode) async {
  try {
    final response = await client.post(
      Uri.parse('$baseUrl/otp/verifyOTP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otpCode, 'hash': otpHash}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['verified'] == true;
    }
    return false;
  } catch (e) {
    print('Error verifying OTP: $e');
    return false;
  }
}

// Fungsi untuk mengganti password di backend
Future<bool> changePassword(String email, String newPassword) async {
  try {
    final response = await client.put(
      Uri.parse('$baseUrl/changepassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print('Error changing password: $e');
    return false;
  }
}