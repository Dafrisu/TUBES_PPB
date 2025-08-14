import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['BASE_URL'] ?? '';

Future<List<Map<String, dynamic>>> getprodukUMKM(int id_umkm) async {
  try {
    final response = await http.get(Uri.parse(
        '$baseUrl/produkumkm/$id_umkm'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> produkUMKM =
          data.cast<Map<String, dynamic>>();
      return produkUMKM;
    } else {
      throw Exception('gagal mendapatkan produk UMKM');
    }
  } catch (error) {
    print(error);
    return [];
  }
}
