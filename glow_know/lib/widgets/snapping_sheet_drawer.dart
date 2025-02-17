// lib/widgets/snapping_sheet_drawer.dart
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/widgets/recently_scanned_product_card.dart';
import 'package:glow_know/utils/theme.dart';
import 'package:glow_know/screens/preferences_screen.dart';
import 'package:glow_know/screens/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glow_know/screens/camera_page.dart';
import 'package:glow_know/assets/svgs.dart';
import 'package:glow_know/screens/product_info_page.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/services/history_service.dart';
import 'package:glow_know/screens/all_scanned_items_page.dart';

class SnappingSheetDrawer extends StatelessWidget {
  final SnappingSheetController controller;
  final VoidCallback onTap;
  final List<Map<String, dynamic>> recentProducts;
  final Future<List<Product>> historyFuture; // Add this parameter
  final VoidCallback refreshHistory;

  const SnappingSheetDrawer({
    super.key,
    required this.controller,
    required this.onTap,
    required this.recentProducts,
    required this.historyFuture, // Pass this to constructor
    required this.refreshHistory, // Pass this to constructor
  });

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: controller,
      grabbingHeight: 60,
      grabbing: GestureDetector(
        onTap: onTap, //????
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
              const SizedBox(height: 8),
              Text(
                'Drag to expand',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
            future: historyFuture,
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
                                height: 180, //120?
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    //                 return Padding(
                                  //         //   padding: const EdgeInsets.only(right: 10),
                                  //         //   child: RecentlyScannedProductCard(
                                  //         //     score: product['score'],
                                  //         //     title: product['title'],
                                  //         //   ),
                                  //         // );
                                    return GestureDetector(
                                      onTap: () => _navigateToProduct(context, product),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: ProductCard(product: product),
                                      ),
                                    );
                                  },

                                  // itemBuilder: (context, index) {
                                  //   final product = products[index];
                                  //         //                 return Padding(
                                  //         //   padding: const EdgeInsets.only(right: 10),
                                  //         //   child: RecentlyScannedProductCard(
                                  //         //     score: product['score'],
                                  //         //     title: product['title'],
                                  //         //   ),
                                  //         // );
                                  //   return GestureDetector(
                                  //     onTap: () => _navigateToProduct(product),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(
                                  //         right: 16,
                                  //       ),
                                  //       child: ProductCard(product: product),
                                  //     ),
                                  //   );
                                  // },
                                ),
                              ),
                              const SizedBox(height: 16), //20??
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AllScannedItemsPage(),
                                    ),
                                  ).then((_) => refreshHistory());
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
                              const SizedBox(height: 20),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => const PreferencesPage(),
                                      //       ),
                                      //     );
                                      //   },
                                      //   style: ElevatedButton.styleFrom(
                                      //     backgroundColor: AppColors.primary,
                                      //     minimumSize: const Size(double.infinity, 50),
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(8),
                                      //     ),
                                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                                      //   ),
                                      //   child: Container(
                                      //     alignment: Alignment.centerLeft,
                                      //     child: Text(
                                      //       'Preferences',
                                      //       style: TextStyle(
                                      //         color: AppColors.background,
                                      //         fontSize: 16,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
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
    );
  }


          // child: ListView(
          //   shrinkWrap: true,
          //   padding: EdgeInsets.zero,
          //   children: [
          //     SizedBox(
          //       height: 120,
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: recentProducts.length,
          //         itemBuilder: (context, index) {
          //           final product = recentProducts[index];
              //       return Padding(
              //         padding: const EdgeInsets.only(right: 10),
              //         child: RecentlyScannedProductCard(
              //           score: product['score'],
              //           title: product['title'],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const PreferencesPage(),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppColors.primary,
              //     minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                 ),
//                 child: Container(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Preferences',
//                     style: TextStyle(
//                       color: AppColors.background,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
  void _navigateToProduct(BuildContext context, Product product) {
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
