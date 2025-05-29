import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchAllUlasans() async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('https://umkmapi-production.up.railway.app/ulasans'),
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
    Uri.parse('https://umkmapi-production.up.railway.app/ulasans/umkm/$id'),
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

Future<Map<String, dynamic>> postUlasan({
  required int id_pembeli,
  required int id_produk,
  required String username,
  required String ulasan,
  required double rating,
}) async {
  try {
    // Validate inputs
    if (username.isEmpty || ulasan.isEmpty) {
      return {'message': 'Username and ulasan cannot be empty'};
    }
    if (rating < 0 || rating > 5) {
      return {'message': 'Rating must be between 0 and 5'};
    }

    final url = Uri.parse('https://umkmapi-production.up.railway.app/ulasans');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_pembeli': id_pembeli,
        'id_produk': id_produk,
        'username': username,
        'ulasan': ulasan,
        'rating': rating,
      }),
    );

    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      return {'message': 'Failed to add ulasan: ${error['message']}'};
    }
  } catch (error) {
    return {'message': 'Error adding ulasan: $error'};
  }
}

Future<List<Map<String, dynamic>>> fetchUlasansByProdukId(int id) async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('https://umkmapi-production.up.railway.app/ulasans/produk/$id'),
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