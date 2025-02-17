import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'product_info_page.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/services/history_service.dart';
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

    // Duplicate check logic
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

      // Create new product (using sample data)
      final newProduct = Product(
        productName: responseData['product']['name'],
        productScore: double.parse(aiResponse[0]),
        productEnvironmentScore: 3.8,
        productType: 'Skincare',
        ingredientsList: 'Nada',
        ingredientsListSummary: aiResponse[1],
        ingredientsListBreakdown: 'Contains 5 beneficial ingredients',
      );

      // Save to history
      await HistoryService.addProduct(newProduct);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductInfoPage(barcode: scannedData, product: newProduct),
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
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
            icon: Icon(
              isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: isTorchOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: toggleTorch,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Scan a barcode/qr code',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
