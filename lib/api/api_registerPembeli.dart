import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> registerPembeli(String nama, String nomorTelepon, String username,
    String email, String password, String alamat) async {
  final checkUserUrl = 'https://umkmapi.azurewebsites.net/checkPembeli';
  final registerUrl = 'https://umkmapi.azurewebsites.net/pembeli';

  try {
    // Check if Pembeli already exists
    final checkResponse = await http.post(
      Uri.parse(checkUserUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'username': username}),
    );

    if (checkResponse.statusCode == 200) {
      final result = jsonDecode(checkResponse.body);
      if (result['emailExists'] == true) {
        print('Email already exists');
        return false;
      }
      if (result['usernameExists'] == true) {
        print('Username already exists');
        return false;
      }
    } else {
      print('Failed to check user: ${checkResponse.statusCode}');
      print('Response body: ${checkResponse.body}');
      return false;
    }

    // Proceed with registration
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nama_lengkap': nama,
        'nomor_telepon': nomorTelepon,
        'username': username,
        'email': email,
        'password': password,
        'alamat': alamat,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Registration successful');
      return true;
    } else {
      print('Failed to register: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  }
}
