import 'package:http/http.dart' as http;
import 'package:tubes_ppb/models/gantipass_response_model.dart';
import 'dart:convert';

var client = http.Client();

Future<GantipassResponseModel> gantiPassword(String email) async {
  try {
    var response = await client.post(
      Uri.parse('https://umkmapi.azurewebsites.net/otp/sendOTP'), // Ensure the port matches your server
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return gantipassResponseModelFromJson(jsonString);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server');
  }
}

Future<bool> verifyOTP(String email, String otpHash, String otpCode) async {
  try {
    var response = await client.post(
      Uri.parse('https://umkmapi.azurewebsites.net/otp/verifyOTP'), 
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'otp': otpCode,
        'hash': otpHash,
      }),
    );

    print('Request: ${response.request}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['verified'];
    } else {
      print('Failed to verify OTP: ${response.statusCode}');
      throw Exception('Failed to verify OTP');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to connect to the server');
  }
}

Future<bool> checkPembeliByEmail(String email) async {
  final checkUrl = 'https://umkmapi.azurewebsites.net/checkPembeliByEmail'; // Ensure the port matches your server

  try {
    final checkResponse = await http.post(
      Uri.parse(checkUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (checkResponse.statusCode == 200) {
      final checkResponseBody = jsonDecode(checkResponse.body);
      return checkResponseBody['emailExists'] == true;
    } else {
      print('Failed to check email: ${checkResponse.statusCode}');
      print('Response body: ${checkResponse.body}');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  }
}

Future<bool> changePassword(String email, String newPassword) async {
  try {
    var response = await client.put(
      Uri.parse('https://umkmapi.azurewebsites.net/changepassword'), // Ensure the port matches your server
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['message'] == 'Password changed successfully';
    } else {
      print('Failed to change password: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}