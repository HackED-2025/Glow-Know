import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'product_info_page.dart';
import '../models/product.dart';
import '../services/history_service.dart';
import '../utils/theme.dart';
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
      final response = await http
          .get(
            Uri.parse(
              'https://go-upc.com/api/v1/code/$scannedData?key=eefd39939a2b498eca937819b56c956c998335e694f38204b2e4630e6a1aaf58',
            ),
          )
          .timeout(const Duration(seconds: 10));
      final responseData = jsonDecode(response.body);

      final newProduct = Product(
        productName: responseData['product']['name'],
        productScore: 4.5,
        productEnvironmentScore: 3.8,
        productType: 'Skincare',
        ingredientsList: 'Nada',
        ingredientsListSummary: 'Moisturizing formula',
        ingredientsListBreakdown: 'Contains 5 beneficial ingredients',
      );

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
