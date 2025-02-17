import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/screens/camera_page.dart';
import 'package:glow_know/utils/theme.dart';
import 'package:glow_know/assets/svgs.dart';
import 'package:glow_know/screens/product_info_page.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/services/history_service.dart';
import 'package:glow_know/screens/all_scanned_items_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'INGREDIA',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _sheetController = SnappingSheetController();
  bool _isPressed = false;
  late Future<List<Product>> _historyFuture; // Add this line

  @override
  void initState() {
    super.initState();
    _refreshHistory(); // Initialize history
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = HistoryService.getHistory(); // Correct initialization
    });
  }

  // Dummy list of recently scanned products
  final List<Map<String, dynamic>> _recentProducts = [
    {'score': 10, 'title': 'Product A'},
    {'score': 7, 'title': 'Product B'},
    {'score': 4, 'title': 'Product C'},
    {'score': 2, 'title': 'Product D'},
  ];

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => const CameraPage(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  void _toggleAnimation() {
    setState(() {
      _isPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).push(_createRoute()).then((_) {
        setState(() {
          _isPressed = false;
        });
      });
    });
  }

  void _toggleSheet() {
    // Toggle between open and closed sheet positions
    if (_sheetController.currentPosition == 0.0) {
      // If the sheet is closed, open it
      _sheetController.snapToPosition(
        const SnappingPosition.factor(
          positionFactor: 1.0,
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      );
    } else {
      // If the sheet is open, close it
      _sheetController.snapToPosition(
        const SnappingPosition.factor(
          positionFactor: 0.0,
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content with positioned header and scan area
          Container(
            height: screenHeight,
            width: double.infinity,
            child: Stack(
              children: [
                // Header: logo and title, positioned a bit lower
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.string(inlineSvg, height: 50),
                      const SizedBox(height: 10),
                      Text(
                        'VESPERA',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scan area: tap message and camera button, centered
                Positioned(
                  top: screenHeight * 0.3,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tap to scan product',
                        style: TextStyle(
                          color: AppColors.fontPrimary,
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _toggleAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 280,
                          height: 280,
                          child: Stack(
                            children: [
                              // Outer Circle (Border)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        _isPressed
                                            ? AppColors.secondary
                                            : AppColors.fontPrimary.withOpacity(
                                              0.15,
                                            ),
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Middle Circle (Shadow + White Border)
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                top: 29,
                                left: 29,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 222,
                                  height: 222,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    boxShadow:
                                        _isPressed
                                            ? [
                                              BoxShadow(
                                                color: AppColors.secondary
                                                    .withOpacity(0.5),
                                                offset: const Offset(0, 0),
                                                blurRadius: 50,
                                              ),
                                            ]
                                            : [
                                              BoxShadow(
                                                color: AppColors.fontPrimary
                                                    .withOpacity(0.25),
                                                offset: const Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                  ),
                                ),
                              ),
                              // Inner Circle (Primary with Border)
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                top: 45.5,
                                left: 45.5,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 189,
                                  height: 189,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          _isPressed
                                              ? AppColors.fontPrimary
                                                  .withOpacity(0.25)
                                              : AppColors.fontSecondary,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: _isPressed ? 60 : 50,
                                      height: _isPressed ? 60 : 50,
                                      child: Image.asset(
                                        'assets/Vector.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Snapping Sheet (drawer)
          SnappingSheet(
            controller: _sheetController,
            grabbingHeight: 60,
            grabbing: GestureDetector(
              onTap: _toggleSheet,
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            snappingPositions: const [
              SnappingPosition.factor(
                positionFactor: 0.0,
                grabbingContentOffset: GrabbingContentOffset.top,
              ),
              SnappingPosition.factor(
                positionFactor: 1.0,
                grabbingContentOffset: GrabbingContentOffset.bottom,
              ),
            ],
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<List<Product>>(
                  future: _historyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = snapshot.data ?? [];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (products.isEmpty)
                          const Center(
                            child: Text(
                              'Scan items to compare!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          Column(
                            children: [
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return GestureDetector(
                                      onTap: () => _navigateToProduct(product),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: ProductCard(product: product),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AllScannedItemsPage(),
                                    ),
                                  ).then((_) => _refreshHistory());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text('View All'),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        // ... keep preferences button
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductInfoPage(product: product),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.productImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(product.productScore),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${product.productScore}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              product.productName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    final int roundedScore = score.round();
    if (roundedScore >= 8) return Colors.red;
    if (roundedScore >= 6) return Colors.orange;
    if (roundedScore >= 4) return Colors.yellow;
    return Colors.green;
  }
}
