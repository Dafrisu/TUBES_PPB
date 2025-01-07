import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchData() async {
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
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetchDataByType(String tipeBarang) async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse(
        'https://umkmapi.azurewebsites.net/produkbytipe/tipe?tipe_barang=$tipeBarang'),
  );

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetchDataUMKM() async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('https://umkmapi.azurewebsites.net/umkm'),
  );

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetchUlasansByProdukId(int id) async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('https://umkmapi.azurewebsites.net/ulasan/$id'),
  );

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    // Cast the List<dynamic> to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> listProperties =
        data.cast<Map<String, dynamic>>();

    return listProperties;
  } else {
    throw Exception('Failed to load data');
  }
}