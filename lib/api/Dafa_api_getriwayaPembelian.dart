import 'package:http/http.dart' as http;
import 'dart:convert';

//API buat riwayat Pembelian
Future<List<Map<String, dynamic>>> fetchriwayatpembelian() async {
  try {
    final response = await http.get(
        Uri.parse('https://umkmapi.azurewebsites.net/getriwayatpesanan/1'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, dynamic>> listProperties =
          data.cast<Map<String, dynamic>>();

      return listProperties;
    } else {
      throw Exception('Gagal load Riwayat Pesanan');
    }
  } catch (error) {
    print(error);
    return [];
  }
}

// Future<void> updateStatusPesanan(String id) async {

//     final url = Uri.parse('https://umkmapi.azurewebsites.net/updatestatuspesananselesai/$id');

//     try {
//       final response = await http.put(url, headers: {
//         'Content-Type': 'application/json',
//       });

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Status pesanan berhasil diperbarui")),
//         );
//         print("Response: $data");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Gagal memperbarui status pesanan")),
//         );
//         print("Error: ${response.body}");
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Terjadi kesalahan: $error")),
//       );
//       print("Exception: $error");
//     }
// }