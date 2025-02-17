import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/screens/camera_page.dart';
// import 'package:glow_know/screens/preferences_screen.dart';
// import 'package:glow_know/widgets/recently_scanned_product_card.dart';
import 'package:glow_know/utils/theme.dart';
import 'package:glow_know/assets/svgs.dart';


// import 'package:flutter/material.dart';
import 'package:glow_know/widgets/snapping_sheet_drawer.dart';
// import 'package:snapping_sheet/snapping_sheet.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final _sheetController = SnappingSheetController();
  bool _isPressed = false;

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
    if (_sheetController.currentPosition == 0.0) {
      _sheetController.snapToPosition(
        const SnappingPosition.factor(
          positionFactor: 1.0,
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      );
    } else {
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
                        'INGREDIA',
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
          // 
          SnappingSheetDrawer(
            controller: _sheetController,
            onTap: _toggleSheet,
            recentProducts: _recentProducts,
          ),
        ],
      ),
    );
  }
}