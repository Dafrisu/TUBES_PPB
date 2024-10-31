import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

final List<String> events = [
  'Pesanan Dikonfirmasi',
  'Pesanan Diproses',
  'Pesanan Dikemas',
  'Pesanan Dikirim',
  'Pesanan Tiba di Kota Tujuan',
  'Pesanan Sedang Diantar',
  'Pesanan Telah Diterima',
  'Pesanan Selesai',
  'Feedback Diberikan',
  'Pesanan Ditutup'
];

class InformasiPemesanan extends StatelessWidget {
  const InformasiPemesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            'Informasi Pemesanan',
            style: GoogleFonts.montserrat(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: FixedTimeline.tileBuilder(
          builder: TimelineTileBuilder.connectedFromStyle(
            contentsAlign: ContentsAlign.reverse,
            oppositeContentsBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('22/12/2021'),
            ),
            contentsBuilder: (context, index) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pesanan Dikemas'),
              ),
            ),
            connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
            indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            itemCount: 4,
          ),
        )
    );
  }
}

// buat test run
// void main() {
//   runApp(MaterialApp(
//     home: InformasiPemesanan(),
//   ));
// }
