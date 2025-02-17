import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glow_know/assets/svgs.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/utils/theme.dart';
import 'package:glow_know/screens/product_info_page.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/screens/all_scanned_items_page.dart';
import 'package:glow_know/screens/preferences_screen.dart';
import 'package:glow_know/widgets/recently_scanned_product_card.dart';

class SnappingSheetDrawer extends StatelessWidget {
  final SnappingSheetController controller;
  final VoidCallback onTap;
  final Future<List<Product>> historyFuture;
  final VoidCallback refreshHistory;

  const SnappingSheetDrawer({
    super.key,
    required this.controller,
    required this.onTap,
    required this.historyFuture,
    required this.refreshHistory,
  });

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: controller,
      grabbingHeight: 60,
      grabbing: GestureDetector(
        onTap: onTap,
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

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (products.isEmpty)
                    const Center(
                      child: Text(
                        'Scan items to compare!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  else
                    Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio:
                              0.9, // Adjusted for better aspect ratio
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          padding: const EdgeInsets.all(8),
                          children:
                              products
                                  .take(4)
                                  .map(
                                    (product) => GestureDetector(
                                      onTap:
                                          () => _navigateToProduct(
                                            context,
                                            product,
                                          ),
                                      child: RecentlyScannedProductCard(
                                        score: product.productScore.round(),
                                        title: product.productName,
                                        imageUrl: product.productImage,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        if (products.length > 1)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllScannedItemsPage(),
                                ),
                              ).then((_) => refreshHistory());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('View More'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 16),
                              ],
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreferencesPage(),
                        ),
                      ).then((_) {
                        refreshHistory();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.snapToPosition(
                            const SnappingPosition.factor(
                              positionFactor: 0.0,
                              grabbingContentOffset: GrabbingContentOffset.top,
                            ),
                          );
                        });
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        return states.contains(WidgetState.pressed)
                            ? AppColors
                                .primary // Filled color when pressed
                            : Colors.transparent; // Transparent by default
                      }),
                      side: WidgetStateProperty.all(
                        const BorderSide(color: AppColors.primary),
                      ),
                      minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 50),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          pencilSvg,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            WidgetStateProperty.resolveWith<Color>((
                              Set<WidgetState> states,
                            ) {
                              return states.contains(WidgetState.pressed)
                                  ? AppColors
                                      .background // SVG color when pressed
                                  : AppColors.secondary; // SVG color by default
                            }).resolve({}),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Preferences',
                          style: TextStyle(
                            color: WidgetStateProperty.resolveWith<Color>((
                              Set<WidgetState> states,
                            ) {
                              return states.contains(WidgetState.pressed)
                                  ? AppColors
                                      .background // Text color when pressed
                                  : AppColors.primary; // Text color by default
                            }).resolve({}),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductInfoPage(product: product),
      ),
    );
  }
}
