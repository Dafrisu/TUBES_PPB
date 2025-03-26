import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchAllUlasans() async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('http://10.0.2.2/ulasans'),
  );

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    return data.map((review) {
      return {
        'username': review['username'],
        'ulasan': review['ulasan'],
        'rating': review['rating'],
        'tanggalUlasan': review['createdAt'],
      };
    }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetchUlasansUMKM(int id) async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('http://10.0.2.2/ulasans/umkm/$id'),
  );
  print(response.body);

  if (response.statusCode == 200) {
    // Decode the response body as a List
    final List<dynamic> data = jsonDecode(response.body);

    return data.map((review) {
      return {
        'id_produk': review['id_produk'],
        'username': review['username'],
        'ulasan': review['ulasan'],
        'rating': review['rating'],
        'namaProduk': review['Produk']['nama_barang'],
        'imgSource': review['Produk']['image_url'],
        'tanggalUlasan': review['createdAt'],
        'fotoProfil': review['Pembeli']['profileImg'],
      };
    }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
