import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_info_page.dart';
import '../services/history_service.dart';
import '../environment.dart';
import '../models/product.dart';
import '../utils/preferences.dart';
import '../utils/theme.dart';

class LoadingScreen extends StatefulWidget {
  final String barcode;

  const LoadingScreen({
    super.key,
    required this.barcode,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _apiCalls();
  }

  static Future<List<dynamic>> _askAi(String ingredients) async {

    final skinTypes = await Preferences.getSkinTypes();
    final hairTypes = await Preferences.getHairTypes();
    final isVegan = await Preferences.isVegan();

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Environment.openAiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': """Return a report about the suitability of each of these cosmetic product ingredients to the user.
                                           The user's skin type is ${skinTypes.join(', ')}, hair type is ${hairTypes.join(', ')}, and they are ${isVegan ? 'vegan' : 'not vegan'}.
                                           First, return the word "HEALTH RATING: " followed by the overall health rating of the whole product from 1 - 10, 1 being lowest risk, 10 being highest risk.
                                           Second, return the word "GENERAL RATING: " followed by the overall suitability of the product for the user, factoring in the health rating, their skin type, hair type, and whether they're vegan. 1 being most suitable, 10 being least suitable.
                                           Then, return the word "SUMMARY: " followed by a simple and brief summary of each ingredient. The summary should be understandable by a layman.
                                           Each key is the name of the ingredient and each value is the brief health summary of the ingredient, no more then 20 words. 
                                           Don't include ** characters. """},
          {'role': 'user', 'content': ingredients},
        ],
      }),);

    final responseJson = jsonDecode(response.body);
    final content = responseJson['choices'][0]['message']['content'];
    print(content);

    final summaryIndex = content.indexOf('SUMMARY: ');
    final healthRatingIndex = content.indexOf ('HEALTH RATING: ');
    final generalRatingIndex = content.indexOf('GENERAL RATING: ');

    final ingredientsList = content.substring(summaryIndex + 11).split('\n').map((ingredient) => ingredient.split(': ')).toList();
    final rating = content.substring(generalRatingIndex + 15, summaryIndex - 1);
    final healthRating = content.substring(healthRatingIndex + 14, generalRatingIndex - 1);

    print('Rating: ${rating} Health Rating: ${healthRating}');
    
    return [rating, healthRating, ingredientsList];
  }

  Future<void> _apiCalls() async {
    
    final response = await http.get(Uri.parse('https://go-upc.com/api/v1/code/${widget.barcode}?key=${Environment.goUpcKey}'));
    final responseData = jsonDecode(response.body);

    print('Fetching...');
    final aiResponse = await _askAi(responseData['product']['ingredients']['text']);

    final newProduct = Product(
      productName: responseData['product']['name'],
      productScore: double.parse(aiResponse[0]),
      productImage: responseData['product']['imageUrl'],
      productHealthScore: double.parse(aiResponse[1]),
      productType: 'Skincare',
      ingredientsList: 'Nada',
      ingredientsListSummary: aiResponse[2],
      ingredientsListBreakdown: 'Contains 5 beneficial ingredients',
    );

    await HistoryService.addProduct(newProduct);
  
  
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductInfoPage(product: newProduct),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
