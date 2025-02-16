import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';

class HistoryService {
  static const String _key = 'productHistory';
  static const int _maxHistory = 10;

  static Future<List<Product>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_key) ?? [];
    return historyJson
        .map((json) => Product.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> addProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Add new product to beginning
    history.insert(0, product);

    // Remove old items if exceeds max
    if (history.length > _maxHistory) {
      history.removeRange(_maxHistory, history.length);
    }

    // Save updated list
    await prefs.setStringList(
      _key,
      history.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }
}
