// lib/widgets/snapping_sheet_drawer.dart
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/widgets/recently_scanned_product_card.dart';
import 'package:glow_know/utils/theme.dart';
import 'package:glow_know/screens/preferences_screen.dart';

class SnappingSheetDrawer extends StatelessWidget {
  final SnappingSheetController controller;
  final VoidCallback onTap;
  final List<Map<String, dynamic>> recentProducts;

  const SnappingSheetDrawer({
    super.key,
    required this.controller,
    required this.onTap,
    required this.recentProducts,
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
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentProducts.length,
                  itemBuilder: (context, index) {
                    final product = recentProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: RecentlyScannedProductCard(
                        score: product['score'],
                        title: product['title'],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreferencesPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preferences',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
