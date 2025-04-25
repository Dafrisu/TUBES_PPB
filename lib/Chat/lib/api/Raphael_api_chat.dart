import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/api/api_loginKurir.dart';
import 'package:tubes_ppb/api/api_loginPembeli.dart';

Future<List<Map<String, dynamic>>> fetchchatpembeli() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/message/msgPembeli/$sessionId'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchMessagesByPembeliAndUMKM(
    int id_umkm) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/getmsgPembeliUMKM/$sessionId/$id_umkm'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchMessagesByPembeliAndKurir(int id_kurir) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;

  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/getmsgPembeliKurir/$sessionId/$id_kurir'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchchatkurir() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/message/msgKurir/$kurirSessionId'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchchatpembelikurir() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/message/msgPembeli/$id_pembeli'));


    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchMessagesByKurirAndPembeli(int id_pembeli) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;

  // Log nilai ID
  print('Debug: id_kurir = $kurirSessionId, id_pembeli = $sessionId');

  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi-production.up.railway.app/getmsgKurirPembeli/$kurirSessionId/$id_pembeli'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print('Error fetching messages: $error');
    return [];
  }
}

// API untuk mengirim pesan dari pembeli ke UMKM
Future<Map<String, dynamic>> sendMessagePembeliKeUMKM(
    String text, int id_umkm, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi-production.up.railway.app/sendchat/pembelikeumkm/$sessionId/$id_umkm'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': sessionId,
        'id_umkm': id_umkm,
        'message': text,
        'sent_at': DateTime.now().toIso8601String(),
        'is_read': false,
        'receiver_type': "UMKM",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Message sent successfully: $responseData');
      return responseData;
    } else {
      throw Exception(
          'Gagal mengirim pesan. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    return {'error': error.toString()};
  }
}

// API untuk mengirim pesan dari pembeli ke UMKM
Future<Map<String, dynamic>> sendMessagePembeliKeKurir(
    String text, int id_kurir, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;

  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi-production.up.railway.app/sendchat/pembelikekurir/$sessionId/$id_kurir'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': sessionId,
        'id_kurir': id_kurir,
        'message': text,
        'sent_at': DateTime.now().toIso8601String(),
        'is_read': false,
        'receiver_type': "kurir",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Message sent successfully: $responseData');
      return responseData;
    } else {
      throw Exception(
          'Gagal mengirim pesan. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    return {'error': error.toString()};
  }
}

Future<Map<String, dynamic>> sendMessageKurirkePembeli(
    String text, String data, int id_pembeli) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;
  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi-production.up.railway.app/sendchat/kurirkepembeli/$kurirSessionId/$id_pembeli'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': id_pembeli,
        'id_kurir': kurirSessionId,
        'message': text,
        'sent_at': DateTime.now().toIso8601String(),
        'is_read': false,
        'receiver_type': "Pembeli",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Message sent successfully: $responseData');
      return responseData;
    } else {
      throw Exception(
          'Gagal mengirim pesan. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    return {'error': error.toString()};
  }
}

Future<Map<String, dynamic>> fetchKurirData() async {
  final response = await http.get(Uri.parse(
      'https://umkmapi-production.up.railway.app/kurir/$kurirSessionId')); // Menggunakan kurirSessionId global

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      'nama_kurir': data['nama_kurir'] ?? 'Kurir',
      'id_umkm': data['id_umkm'] ?? 0, // Mengembalikan id_umkm
    };
  } else {
    print('Failed to load kurir data');
    return {
      'nama_kurir': 'Kurir',
      'id_umkm': 0, // Nilai default jika gagal
    };
  }
}

Future<List<Map<String, dynamic>>> getPesananDiterima() async {
  try {
    // Ambil data kurir dari fetchKurirData
    Map<String, dynamic> kurirData = await fetchKurirData();
    int idUmkm = kurirData['id_umkm'];

    if (idUmkm == 0) {
      print('ID UMKM tidak ditemukan');
      return [];
    }

    final response = await http.get(
      Uri.parse(
          'https://umkmapi-production.up.railway.app/getpesananditerima/$idUmkm'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Pastikan data dapat dikonversi menjadi list map
      final List<Map<String, dynamic>> listPesanan =
          data.cast<Map<String, dynamic>>();

      return listPesanan;
    } else {
      throw Exception('Gagal mengambil data pesanan diterima');
    }
  } catch (error) {
    print('Error saat mengambil data pesanan diterima: $error');
    return [];
  }
}

Future<void> updateStatusPesananSelesai(int idBatch) async {
  try {
    // Ambil data kurir untuk mendapatkan id_umkm
    Map<String, dynamic> kurirData = await fetchKurirData();
    int idUmkm = kurirData['id_umkm'];

    if (idUmkm == 0) {
      print('ID UMKM tidak ditemukan');
      return;
    }

    // URL untuk update status pesanan
    final url = Uri.parse(
        'https://umkmapi-production.up.railway.app/updatestatuspesananselesai/$idUmkm/$idBatch');

    // Mengirim request PUT untuk update status
    final response = await http.put(url);

    if (response.statusCode == 200) {
      // Status berhasil diperbarui
      print('Status pesanan selesai berhasil diperbarui');
    } else {
      // Gagal memperbarui status pesanan
      print('Gagal memperbarui status pesanan: ${response.statusCode}');
    }
  } catch (error) {
    print('Error saat memperbarui status pesanan: $error');
  }
}

const String baseUrl =
    "https://umkmapi-production.up.railway.app/"; // Update with your actual backend URL

Future<Map<String, dynamic>> getLatestMsgPembeliUMKM(int idUmkm) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int idPembeli = prefs.getInt('sessionId') ?? 0;

  try {
    final response = await http
        .get(Uri.parse('$baseUrl/getLatestMsgPembeliUMKM/$idPembeli/$idUmkm'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch latest message: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error fetching latest message: $error');
    return {};
  }
}

Future<Map<String, dynamic>> getLatestMsgPembeliKurir(int idKurir) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int idPembeli = prefs.getInt('sessionId') ?? 0;

  try {
    final response = await http.get(
        Uri.parse('$baseUrl/getLatestMsgPembeliKurir/$idPembeli/$idKurir'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch latest message: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error fetching latest message: $error');
    return {};
  }
}

Future<Map<String, dynamic>> getLatestMsgKurirPembeli(int idPembeli) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int idKurir = prefs.getInt('kurirSessionId') ??
      0; // Assuming kurir session ID is stored

  try {
    final response = await http.get(
        Uri.parse('$baseUrl/getLatestMsgKurirPembeli/$idKurir/$idPembeli'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch latest message: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error fetching latest message: $error');
    return {};
  }
}
