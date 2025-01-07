import 'package:http/http.dart' as http;
import 'dart:convert';

//API buat riwayat Pembelian
Future<List<Map<String, dynamic>>> fetchriwayatpembelian() async {
  try {
    final response =
        await http.get(Uri.parse('http://localhost/getriwayatpesanan/1'));

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
    final response =
        await http.get(Uri.parse('http://localhost/getpesananaktifpembeli/1'));

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
