import 'package:flutter/material.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/screens/product_info_page.dart';

import 'package:glow_know/services/history_service.dart';

class AllScannedItemsPage extends StatefulWidget {
  @override
  _AllScannedItemsPageState createState() => _AllScannedItemsPageState();
}

class _AllScannedItemsPageState extends State<AllScannedItemsPage> {
  String _filter = 'recent';
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryService.getHistory(); // Fetch from service
    setState(() {
      _products = history;
      _sortProducts(); // Initial sort
    });
  }

  void _sortProducts() {
    setState(() {
      if (_filter == 'score') {
        _products.sort(
          (a, b) => b.productScore.compareTo(a.productScore),
        ); // Fix field name
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Scanned Items')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterButton('Recent', 'recent'),
                const SizedBox(width: 8),
                _buildFilterButton('Score', 'score'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductInfoPage(product: product),
                      ),
                    );
                  },
                  child: ProductListTile(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, String value) {
    return ChoiceChip(
      label: Text(text),
      selected: _filter == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _filter = value;
            _sortProducts();
          });
        }
      },
    );
  }
}

class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.productImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product.productName),
        subtitle: Text(
          'Safety Score: ${product.productScore}',
          style: TextStyle(
            color: _getScoreColor(product.productScore),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return Colors.red;
    if (score >= 6) return Colors.orange;
    if (score >= 4) return Colors.amber;
    return Colors.green;
  }
}
