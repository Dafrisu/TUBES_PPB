import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchData() async {
  final response = await http
      .get(Uri.parse('https://umkmapi-production.up.railway.app/produk'));

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
        'https://umkmapi-production.up.railway.app/produkbytipe/tipe?tipe_barang=$tipeBarang'),
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
    Uri.parse('https://umkmapi-production.up.railway.app/umkm'),
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
