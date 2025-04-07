import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> getbookmark(int id_pembeli) async {
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/bookmark/$id_pembeli'));

    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);

      if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey("message")) {
        print("Bookmark Kosong");
        return [];
      }

      if (decodedData is List) {
        return decodedData.cast<Map<String, dynamic>>();
      }

      // Jika format tidak sesuai, lempar error
      throw Exception("Format data dari API tidak sesuai.");
    } else {
      throw Exception('Gagal mendapatkan Bookmark');
    }
  } catch (error) {
    print(error);
    return [];
  }
}

Future<Map<String, dynamic>> checkbookmark(
    int id_produk, int id_pembeli) async {
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/bookmark/check/$id_produk/$id_pembeli'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception('Gagal memeriksa bookmark');
    }
  } catch (error) {
    print(error);
    return {};
  }
}

Future<void> addtobookmark(int id_pembeli, int id_produk) async {
  try {
    final response = await http.post(Uri.parse(
        "https://umkmapi-production.up.railway.app/bookmark/$id_pembeli/$id_produk"));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  } catch (error) {
    print(error);
  }
}

Future<void> deletebookmark(int id_pembeli, int id_produk) async {
  try {
    final response = await http.delete(Uri.parse(
        "https://umkmapi-production.up.railway.app/bookmark/$id_pembeli/$id_produk"));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  } catch (error) {
    print(error);
  }
}
