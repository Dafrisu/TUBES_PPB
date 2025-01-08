import 'package:http/http.dart' as http;
import 'dart:convert';

int lastbatch = 0;

Future<void> addtoKeranjang(int id_pembeli, int id_produk, int id_batch) async {
  try {
    final url = Uri.parse('http://10.0.2.2/keranjang');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Pastikan tipe konten JSON
      },
      body: jsonEncode({
        'id_pembeli': id_pembeli,
        'id_produk': id_produk,
        'id_batch': id_batch,
        'kuantitas': 1,
      }),
    );
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      print('Berhasil menambahkan ke keranjang');
    } else {
      final error = jsonDecode(response.body);
      throw Exception('Gagal: ${error['message']}');
    }
  } catch (error) {
    print('error: $error');
  }
}

Future<void> getlastbatch(int id_pembeli) async {
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/lastbatch/$id_pembeli'));
    Map<String, dynamic> data = jsonDecode(response.body);

    lastbatch = data['latest_batch'];
  } catch (error) {
    print(error);
  }
}

Future<Map<String, dynamic>> searchOnKeranjang(
    int id_pembeli, int id_produk, int id_batch) async {
  try {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2/searchkeranjang/$id_pembeli/$id_produk/$id_batch'));
    Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  } catch (error) {
    print((error));
    return {};
  }
}

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
