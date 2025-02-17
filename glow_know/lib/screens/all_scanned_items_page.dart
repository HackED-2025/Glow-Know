import 'package:flutter/material.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/screens/product_info_page.dart';
import 'package:glow_know/services/history_service.dart';
import 'package:glow_know/utils/theme.dart ';

class AllScannedItemsPage extends StatefulWidget {
  @override
  _AllScannedItemsPageState createState() => _AllScannedItemsPageState();
}

class _AllScannedItemsPageState extends State<AllScannedItemsPage> {
  String _filter = 'recent';
  List<Product> _products = [];
  List<Product> _originalProducts = []; // To store the original order

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryService.getHistory();
    setState(() {
      _products = history;
      _originalProducts = List.from(history); // Preserve the original order
    });
  }

  void _sortProducts() {
    setState(() {
      if (_filter == 'score') {
        _products.sort((a, b) => b.productScore.compareTo(a.productScore));
      } else if (_filter == 'recent') {
        // Reset to the original order
        _products = List.from(_originalProducts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Scanned Items'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
      ),
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
      label: Text(
        text,
        style: TextStyle(
          color:
              _filter == value ? AppColors.background : AppColors.fontPrimary,
        ),
      ),
      selected: _filter == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _filter = value;
            _sortProducts();
          });
        }
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
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
        color: AppColors.background,
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
        title: Text(
          product.productName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.fontPrimary),
        ),
        subtitle: Text(
          'Safety Score: ${product.productScore}',
          style: TextStyle(
            color: _getScoreColor(context, product.productScore),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.fontPrimary),
      ),
    );
  }

  Color _getScoreColor(BuildContext context, double score) {
    final colorScheme = Theme.of(context).colorScheme;
    if (score >= 8) return colorScheme.error;
    if (score >= 6) return colorScheme.tertiary;
    if (score >= 4) return colorScheme.secondary;
    return colorScheme.primary;
  }
}
