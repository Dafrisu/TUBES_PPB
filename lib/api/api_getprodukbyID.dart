import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

Future<Map<String, dynamic>> getproduk(int id) async {
  try {
    final response = await http
        .get(Uri.parse('$baseUrl/produk/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } else {
      throw new Exception('Gagal melakukan Fetch');
    }
  } catch (error) {
    print("Gagal: ${error}");
    return {};
  }
}
