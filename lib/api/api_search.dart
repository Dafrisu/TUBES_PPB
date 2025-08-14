import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

Future<List<Map<String, dynamic>>> searchbar(String query) async {
  try {
    String encodedQuery = Uri.encodeComponent(query);
    print(encodedQuery);
    final response = await http.get(Uri.parse(
        '$baseUrl/search?search=$encodedQuery'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> result = data.cast<Map<String, dynamic>>();
      return result;
    } else {
      throw Exception("Gagal menemukan Produk");
    }
  } catch (error) {
    print(error);
    return [];
  }
}
