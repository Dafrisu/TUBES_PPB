import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:tubes_ppb/component/appbar.dart';


final List<String> events = [
  'Pesanan Dikonfirmasi',
  'Pesanan Diproses',
  'Pesanan Dikemas',
  'Pesanan Dikirim',
  'Pesanan Diterima',
];

class InformasiPemesanan extends StatelessWidget {
  const InformasiPemesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarUMKMku(titleText: 'Informasi Pemesanan'),
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
                child: Text(events[index]),
              ),
            ),
            connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
            indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
            itemCount: 5,
          ),
        )
    );
  }
}
