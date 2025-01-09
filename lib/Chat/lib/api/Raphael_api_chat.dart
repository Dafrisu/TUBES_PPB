import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<List<Map<String, dynamic>>> fetchMessagesByPembeliAndKurir(
    int id_kurir) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id_pembeli = prefs.getInt('sessionId') ?? 0;

  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/getmsgPembeliKurir/$id_pembeli/13'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchchatkurir() async {
  try {
    final response = await http.get(
        Uri.parse('https://umkmapi.azurewebsites.net/message/msgKurir/13'));

    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } catch (error) {
    print(error);
    return [];
  }
}

Future<String> fetchKurirData() async {
  final response = await http.get(Uri.parse(
      'https://umkmapi.azurewebsites.net/kurir/13')); // Ganti dengan URL yang sesuai

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['nama_kurir'] ?? 'Kurir';
  } else {
    print('Failed to load kurir data');
    return 'Kurir';
  }
}

Future<List<Map<String, dynamic>>> fetchMessagesByKurirAndPembeli(
    int id_kurir, int id_pembeli) async {
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/getmsgKurirPembeli/13/$id_pembeli'));

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
  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi.azurewebsites.net/sendchat/pembelikekurir/$id_pembeli/13'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': id_pembeli,
        'id_kurir': 13,
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
    int id_pembeli, String text, int id_kurir, String data) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://umkmapi.azurewebsites.net/sendchat/kurirkepembeli/13/1'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': 1,
        'id_kurir': 13,
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

Future<List<Map<String, dynamic>>> fetchpesananditerima() async {
  try {
    final response = await http.get(
        Uri.parse('https://umkmapi.azurewebsites.net/getpesananditerima/1'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> listProperties =
          data.cast<Map<String, dynamic>>();

      return listProperties;
    } else {
      throw Exception('Gagal load Pesanan');
    }
  } catch (error) {
    print(error);
    return [];
  }
}
