import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final String endereco;

  const AddressCard({super.key, required this.endereco});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(endereco, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}