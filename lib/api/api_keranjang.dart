import 'package:http/http.dart' as http;
import 'dart:convert';

int lastbatch = 0;

Future<Map<String, dynamic>> addtoKeranjang(
    int id_pembeli, int id_produk, int id_batch) async {
  try {
    final url = Uri.parse('https://umkmapi.azurewebsites.net/keranjang');

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
      return jsonDecode(
          response.body); // Mengembalikan response body jika sukses
    } else {
      final error = jsonDecode(response.body);
      throw Exception('Gagal: ${error['message']}');
    }
  } catch (error) {
    return {
      'message': error.toString()
    }; // Mengembalikan error message jika terjadi error
  }
}

Future<void> getlastbatch(int id_pembeli) async {
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/lastbatch/$id_pembeli'));
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['latest_batch'] == null) {
      lastbatch = 1;
    } else {
      lastbatch = data['latest_batch'];
    }
    print(lastbatch);
  } catch (error) {
    print("error: ${error}");
  }
}

Future<void> addbatch(int id_pembeli, int id_batch) async {
  try {
    final url = Uri.parse(
        'https://umkmapi.azurewebsites.net/addbatch/$id_pembeli/$id_batch');
    final response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      print('berhasil menambah batch');
    } else {
      throw Exception('Gagal menambah batch');
    }
  } catch (error) {
    print(error);
  }
}

Future<Map<String, dynamic>> searchOnKeranjang(
    int id_pembeli, int id_produk, int id_batch) async {
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/searchkeranjang/$id_pembeli/$id_produk/$id_batch'));
    Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  } catch (error) {
    print((error));
    return {};
  }
}

Future<List<Map<String, dynamic>>> keranjangpembeli(int id_pembeli) async {
  try {
    final url = Uri.parse(
        'https://umkmapi.azurewebsites.net/keranjangstandby/$id_pembeli');

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
