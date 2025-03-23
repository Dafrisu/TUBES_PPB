import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ProductCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: 150), // nanti sesuaikan height sama width
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class ProductCardURL extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int price;

  const ProductCardURL(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(imageUrl,
              fit: BoxFit.cover,
              height: 250,
              width: 250), // nanti sesuaikan height sama width
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rp.${price}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
    );
  }
}
