import 'package:flutter/material.dart';
import 'package:glow_know/models/product.dart';

class ProductInfoPage extends StatelessWidget {
  final String barcode;
  final Product product;

  const ProductInfoPage({super.key, required this.barcode, required this.product});

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
            Text(
              'Product Name: ${product.productName}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text('Price: \$19.99', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Danger Score: ${product.productScore}',
            ),
            const SizedBox(height: 10),
            Text(
              'Summary: ${product.ingredientsListSummary}',
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
