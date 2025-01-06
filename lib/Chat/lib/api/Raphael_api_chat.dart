import 'package:http/http.dart' as http;
import 'dart:convert';

//API buat riwayat Pembelian
Future<List<Map<String, dynamic>>> fetchchatpembeli() async {
  try {
    final response = await http.get(
        Uri.parse('https://umkmapi.azurewebsites.net/message/msgPembeli/1'));

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

// API untuk mengirim pesan dari pembeli ke UMKM
Future<Map<String, dynamic>> sendMessagePembeliKeUMKM(
    int idPembeli, int idUMKM, Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse('https://umkmapi.azurewebsites.net/sendchat/pembelikeumkm/1/1'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_pembeli': idPembeli,
        'id_umkm': idUMKM,
        'message': data['message'],
        'sent_at': data['sent_at'],
        'is_read': data['is_read'],
        'id_kurir': null,
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

Future<List<Map<String, dynamic>>> fetchchatkurir() async {
  try {
    final response = await http.get(Uri.parse(
        'https://umkmapi.azurewebsites.net/message/msgKurir/:id_kurir'));

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
