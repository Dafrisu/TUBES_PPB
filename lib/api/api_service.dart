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
    Uri.parse('https://umkmapi.azurewebsites.net/ulasans/$id'),
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

Future<List<Map<String, dynamic>>> fetchAllUlasans() async {
  // Construct the URL with the query parameter
  final response = await http.get(
    Uri.parse('https://umkmapi.azurewebsites.net/ulasans'),
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
    Uri.parse('https://umkmapi.azurewebsites.net/ulasans/umkm/$id'),
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
