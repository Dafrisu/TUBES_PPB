import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String isi;
  final String label;
  final bool readOnly;

  const CustomFormField({super.key, required this.isi, required this.label, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        initialValue: isi,
        readOnly: readOnly,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
