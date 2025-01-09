import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/api/api_loginKurir.dart';

//API buat chat
Future<List<Map<String, dynamic>>> fetchchatpembeli() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/message/msgPembeli/$id_pembeli'));

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
        'https://umkmapi.azurewebsites.net/getmsgPembeliUMKM/$id_pembeli/$id_umkm'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchMessagesByPembeliAndKurir() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;

  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/getmsgPembeliKurir/$id_pembeli/$id_kurir'));

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
        'https://umkmapi.azurewebsites.net/message/msgKurir/$id_kurir'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchMessagesByKurirAndPembeli() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/getmsgKurirPembeli/$id_kurir/$id_pembeli'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
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
          'https://umkmapi.azurewebsites.net/sendchat/pembelikeumkm/$id_pembeli/$id_umkm'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': id_pembeli,
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
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;

  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi.azurewebsites.net/sendchat/pembelikekurir/$id_pembeli/$id_kurir'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': id_pembeli,
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
    String text, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;
  int id_kurir = prefs.getInt('kurirSessionId') ?? 0;
  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi.azurewebsites.net/sendchat/kurirkepembeli/$id_kurir/$id_pembeli'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': id_pembeli,
        'id_kurir': id_kurir,
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
      'https://umkmapi.azurewebsites.net/kurir/$kurirSessionId')); // Menggunakan kurirSessionId global

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
      Uri.parse('https://umkmapi.azurewebsites.net/getpesananditerima/$idUmkm'),
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

Future<bool> updateStatusPesananMasuk(int id_umkm, int idBatch) async {
  try {
    final response = await http.put(
      Uri.parse(
          'https://umkmapi.azurewebsites.net/updatestatuspesananmasuk/$id_umkm/$idBatch'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal update status pesanan');
    }
  } catch (error) {
    print('Error update status pesanan diterima: $error');
    return false;
  }
}

Future<List<Map<String, dynamic>>> fetchPesanAndIterima(int id) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://your-api-url.com/getpesananditerima/$id'), // Replace with your actual URL
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load orders');
    }
  } catch (error) {
    print(error);
    return [];
  }
}

Future<bool> updateStatusPesananSelesai(int id_umkm, int idBatch) async {
  try {
    final response = await http.put(
      Uri.parse(
          'https://umkmapi.azurewebsites.net/updatestatuspesananselesai/$id_umkm/$idBatch'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal update status pesanan');
    }
  } catch (error) {
    print('Error update status pesanan selesai: $error');
    return false;
  }
}
