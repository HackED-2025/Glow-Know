import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'product_info_page.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/services/history_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      print('Fetching...');
      final response = await http
          .get(
            Uri.parse(
              'https://go-upc.com/api/v1/code/$scannedData?key=eefd39939a2b498eca937819b56c956c998335e694f38204b2e4630e6a1aaf58',
            ),
          )
          .timeout(const Duration(seconds: 10));
      final responseData = jsonDecode(response.body);
      print(responseData);

      // Create new product (using sample data)
      final newProduct = Product(
        productName: responseData['product']['name'],
        productScore: 4.5,
        productEnvironmentScore: 3.8,
        productType: 'Skincare',
        ingredientsList: 'Nada',
        ingredientsListSummary: 'Moisturizing formula',
        ingredientsListBreakdown: 'Contains 5 beneficial ingredients',
      );

      // Save to history
      await HistoryService.addProduct(newProduct);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  ProductInfoPage(barcode: scannedData, product: newProduct),
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
