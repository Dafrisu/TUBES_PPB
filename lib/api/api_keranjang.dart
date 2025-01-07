import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> keranjangpembeli(int id_pembeli) async {
  try {
    final url = Uri.parse('http://10.0.2.2/keranjangstandby/$id_pembeli');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> keranjang = data.cast<Map<String, dynamic>>();

      return keranjang;
    } else {
      throw Exception('Gagal mendapatkan keranjang');
    }
  } catch (error) {
    print(error);
    return [];
  }
}
