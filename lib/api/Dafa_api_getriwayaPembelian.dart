import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_loginPembeli.dart';

//API buat riwayat Pembelian
Future<List<Map<String, dynamic>>> fetchriwayatpembelian() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/getriwayatpesanan/$sessionId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> listProperties =
          data.cast<Map<String, dynamic>>();

      return listProperties;
    } else {
      throw Exception('Gagal load Riwayat Pesanan');
    }
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchpesananaktifpembeli() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/getallpesananaktifpembeli/$sessionId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> listProperties =
          data.cast<Map<String, dynamic>>();

      return listProperties;
    } else {
      throw Exception('Gagal load Riwayat Pesanan');
    }
  } catch (error) {
    print(error);
    return [];
  }
}

Future<void> sendpesanan(int id_keranjang, double total_belanja) async {
  // URL endpoint API
  final Uri url = Uri.parse(
      'http://10.0.2.2/addpesanan/$id_keranjang/$total_belanja/$sessionId');
  try {
    // Melakukan POST request
    final response = await http.post(url);

    // Memeriksa status code response
    if (response.statusCode == 200) {
      // Response berhasil
      final responseBody = jsonDecode(response.body);
      print('Response: $responseBody');
    } else {
      // Response gagal
      print('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (error) {
    // Menangkap error jaringan atau lainnya
    print('Error: $error');
  }
}

Future<List<Map<String, dynamic>>> fetchpembeli() async {
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/pembeli/$sessionId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> listProperties =
          data.cast<Map<String, dynamic>>();

      return listProperties;
    } else {
      throw Exception('Gagal load Riwayat Pesanan');
    }
  } catch (error) {
    print(error);
    return [];
  }
}
