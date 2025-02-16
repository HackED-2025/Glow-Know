import 'package:flutter/material.dart';

class ProductInfoPage extends StatelessWidget {
  final String barcode;

  const ProductInfoPage({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scanned Barcode: $barcode',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Product Name: Sample Product',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text('Price: \$19.99', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text(
              'Description: This is a sample product description.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
