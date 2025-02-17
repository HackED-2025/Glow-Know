import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'product_info_page.dart';
import '../models/product.dart';
import '../services/history_service.dart';
import '../utils/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../environment.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late MobileScannerController cameraController;
  bool isProcessing = false;
  String? lastScannedCode;
  DateTime? lastScanTime;
  bool isTorchOn = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(torchEnabled: isTorchOn);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void toggleTorch() {
    setState(() {
      isTorchOn = !isTorchOn;
      cameraController.toggleTorch();
    });
  }

  static Future<List<String>> _askAi(String ingredients) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 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',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {'role': 'system', 'content': """Return a report about the danger of each of these cosmetic product ingredients.
                                           First, return the word "RATING: " followed by the health rating of the product from 1 - 10, 1 being safe, 10 being highest risk.
                                           Then, return the word "SUMMARY: " followed by a brief summary of each ingredient.
                                           Each key is the name of the ingredient and each value is the brief health summary of the ingredient, no more then 20 words. 
                                           Don't include ** characters. """},
          {'role': 'user', 'content': ingredients},
        ],
      }),);

    final responseJson = jsonDecode(response.body);
    final content = responseJson['choices'][0]['message']['content'];

    final summaryIndex = content.indexOf('SUMMARY: ');
    final ratingIndex = content.indexOf('RATING: ');

    final ingredientsList = content.substring(summaryIndex + 9);

    final rating = content.substring(ratingIndex + 8, summaryIndex - 1);

    print(rating);
    
    return [rating, ingredientsList];
  }

  void _handleBarcode(String scannedData) async {
    final now = DateTime.now();

    if (lastScannedCode == scannedData &&
        lastScanTime != null &&
        now.difference(lastScanTime!) < const Duration(seconds: 2)) {
      return;
    }

    setState(() {
      lastScannedCode = scannedData;
      lastScanTime = now;
    });

    try {
      final response = await http.get(Uri.parse('https://go-upc.com/api/v1/code/$scannedData?key=${Environment.goUpcKey}'))
        .timeout(const Duration(seconds: 10));
      final responseData = jsonDecode(response.body);

      print('Fetching...');
      final aiResponse = await _askAi(responseData['product']['ingredients']['text']);

      final newProduct = Product(
        productName: responseData['product']['name'],
        productScore: double.parse(aiResponse[0]),
        productImage: responseData['product']['imageUrl'],
        productEnvironmentScore: 3.8,
        productType: 'Skincare',
        ingredientsList: 'Nada',
        ingredientsListSummary: aiResponse[1],
        ingredientsListBreakdown: 'Contains 5 beneficial ingredients',
      );

      await HistoryService.addProduct(newProduct);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductInfoPage(product: newProduct),
        ),
      );
    } on TimeoutException catch (e) {
      print('Timeout: $e');
    } on Exception catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scanner'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.fontPrimary,
                  size: 14,
                ),
                const SizedBox(width: 2),
                Text(
                  'Back',
                  style: TextStyle(
                    color: AppColors.fontPrimary,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isTorchOn ? Icons.flash_on : Icons.flash_off,
              color:
                  isTorchOn
                      ? AppColors.secondary
                      : AppColors.fontPrimary.withOpacity(0.6),
            ),
            onPressed: toggleTorch,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5, // Reduced height
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final scannedData = barcodes.first.rawValue;
                    if (scannedData != null) _handleBarcode(scannedData);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.fontSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Center the barcode within the frame\n'
                    '2. Hold steady for 1-2 seconds\n'
                    '3. Ensure good lighting conditions\n'
                    '4. Toggle the flash if needed',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.fontPrimary.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      'Powered by Ingredia',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.fontPrimary.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}
