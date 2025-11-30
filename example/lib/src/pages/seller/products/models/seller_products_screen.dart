import 'package:flutter/material.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Products')),
      body: const Center(
        child: Text('List of Seller Products will be shown here.'),
      ),
    );
  }
}
