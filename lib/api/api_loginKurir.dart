import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

int kurirSessionId = 0;

Future<bool> loginKurir(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2/loginKurir'),
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
    final data = jsonDecode(response.body);
    kurirSessionId = data['id_kurir'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kurirSessionId', kurirSessionId);
    return true;
  } else {
    print('Failed to login: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }
}
