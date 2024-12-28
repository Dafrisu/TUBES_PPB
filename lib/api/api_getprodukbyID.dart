import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> getproduk(int id) async {
  try {
    final response = await http
        .get(Uri.parse('https://umkmapi.azurewebsites.net/produk/$id'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = jsonDecode(response.body);

      return data;
    } else {
      throw new Exception('Gagal melakukan Fetch');
    }
  } catch (error) {
    print("Gagal: ${error}");
    return [];
  }
}
