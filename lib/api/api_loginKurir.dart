import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> loginKurir(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://umkmapi.azurewebsites.net/loginKurir'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    print('Login successful');
    return true;
  } else {
    print('Failed to login: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }
}