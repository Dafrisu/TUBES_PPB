import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchProduk() async {
  final response =
      await http.get(Uri.parse('https://umkmapi.azurewebsites.net/produk'));

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Gagal load Produk UMKM');
  }
}

Future<List<Map<String, dynamic>>> fetchMakanan() async {
  final response = await http
      .get(Uri.parse('https://umkmapi.azurewebsites.net/produk/makanan'));

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Gagal load Makanan UMKM');
  }
}

Future<List<Map<String, dynamic>>> fetchMinuman() async {
  final response = await http
      .get(Uri.parse('https://umkmapi.azurewebsites.net/produk/minuman'));

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Gagal load Minuman UMKM');
  }
}

Future<List<Map<String, dynamic>>> fetchMisc() async {
  final response = await http
      .get(Uri.parse('https://umkmapi.azurewebsites.net/produk/misc'));

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Gagal load Misc UMKM');
  }
}

//API buat riwayat Pembelian
Future<List<Map<String, dynamic>>> fetchriwayatpembelian() async {
  final response = await http
      .get(Uri.parse('https://umkmapi.azurewebsites.net/getriwayatpesanan'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Gagal load Riwayat Pesanan');
  }
}
