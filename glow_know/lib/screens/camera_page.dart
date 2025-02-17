import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/theme.dart';
import 'loading.dart';

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

  void _handleBarcode(String scannedData) {
    cameraController.stop();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(barcode: scannedData),
      ),
    );
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
