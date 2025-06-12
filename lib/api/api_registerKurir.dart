import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> registerKurir(
    String email, String nama, String password, String idUmkm, String nomorTelepon) async {
  final checkUrl = 'https://umkmapi-production.up.railway.app/checkkurir';
  final registerUrl = 'https://umkmapi-production.up.railway.app/kurir';

  try {
    // Check if Kurir already exists
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
      if (checkResponseBody['emailExists'] == true) {
        print('Email already exists');
        return false;
      }
    } else {
      print('Failed to check Kurir: ${checkResponse.statusCode}');
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
        'nama_kurir': nama,
        'email': email,
        'password': password,
        'id_umkm': idUmkm,
        'status': 'Belum Terdaftar',
        'nomor_telepon': nomorTelepon,
      }),
    );

    if (response.statusCode == 201) {
      print('Registration successful');
      return true;
    } else {
      print('Failed to register Kurir: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  }
}

Future<List<dynamic>> fetchUMKM() async {
  final response = await http
      .get(Uri.parse('https://umkmapi-production.up.railway.app/umkm'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load UMKM data');
  }
}
