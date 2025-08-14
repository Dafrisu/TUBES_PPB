import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

Future<Map<String, dynamic>> getumkm(int id) async {
  try {
    final response = await http
        .get(Uri.parse('$baseUrl/umkm/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> umkm = jsonDecode(response.body);
      return umkm;
    } else {
      throw new Exception('Gagal Fetch Profile UMKM');
    }
  } catch (error) {
    print(error);
    return {};
  }
}
