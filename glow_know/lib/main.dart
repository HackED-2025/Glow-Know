// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:snapping_sheet/snapping_sheet.dart';
// import 'package:glow_know/screens/camera_page.dart';
// import 'package:glow_know/screens/preferences_screen.dart';
// import 'package:glow_know/utils/theme.dart';
// import 'package:glow_know/assets/svgs.dart';
// import 'package:glow_know/screens/home_screen.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'INGREDIA',
//       theme: ThemeData(
//         scaffoldBackgroundColor: AppColors.background,
//         fontFamily: 'Nunito',
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
//           displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
//           titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
//           titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//           bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//           bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//           labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _sheetController = SnappingSheetController();
//   bool _isPressed = false;

//   // Dummy list of recently scanned products
//   final List<Map<String, dynamic>> _recentProducts = [
//     {'score': 10, 'title': 'Product A'},
//     {'score': 7, 'title': 'Product B'},
//     {'score': 4, 'title': 'Product C'},
//     {'score': 2, 'title': 'Product D'},
//   ];

//   Route _createRoute() {
//     return PageRouteBuilder(
//       pageBuilder:
//           (context, animation, secondaryAnimation) => const CameraPage(),
//       transitionDuration: const Duration(milliseconds: 500),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.easeInOut;

//         var tween = Tween(
//           begin: begin,
//           end: end,
//         ).chain(CurveTween(curve: curve));

//         return SlideTransition(position: animation.drive(tween), child: child);
//       },
//     );
//   }

//   void _toggleAnimation() {
//     setState(() {
//       _isPressed = true;
//     });

//     Future.delayed(const Duration(milliseconds: 300), () {
//       Navigator.of(context).push(_createRoute()).then((_) {
//         setState(() {
//           _isPressed = false;
//         });
//       });
//     });
//   }

//   void _toggleSheet() {
//     // Toggle between open and closed sheet positions
//     if (_sheetController.currentPosition == 0.0) {
//       // If the sheet is closed, open it
//       _sheetController.snapToPosition(
//         const SnappingPosition.factor(
//           positionFactor: 1.0,
//           grabbingContentOffset: GrabbingContentOffset.bottom,
//         ),
//       );
//     } else {
//       // If the sheet is open, close it
//       _sheetController.snapToPosition(
//         const SnappingPosition.factor(
//           positionFactor: 0.0,
//           grabbingContentOffset: GrabbingContentOffset.top,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Stack(
//         children: [
//           // Main content with positioned header and scan area
//           Container(
//             height: screenHeight,
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 // Header: logo and title, positioned a bit lower
//                 Positioned(
//                   top: 100,
//                   left: 0,
//                   right: 0,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SvgPicture.string(inlineSvg, height: 50),
//                       const SizedBox(height: 10),
//                       Text(
//                         'INGREDIA',
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontSize: 32,
//                           fontWeight: FontWeight.normal,
//                           letterSpacing: 4.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Scan area: tap message and camera button, centered
//                 Positioned(
//                   top: screenHeight * 0.3,
//                   left: 0,
//                   right: 0,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Tap to scan product',
//                         style: TextStyle(
//                           color: AppColors.fontPrimary,
//                           fontFamily: 'Inter',
//                           fontSize: 16,
//                           fontWeight: FontWeight.normal,
//                           height: 1,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       GestureDetector(
//                         onTap: _toggleAnimation,
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           width: 280,
//                           height: 280,
//                           child: Stack(
//                             children: [
//                               // Outer Circle (Border)
//                               AnimatedContainer(
//                                 duration: const Duration(milliseconds: 300),
//                                 width: 280,
//                                 height: 280,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color:
//                                         _isPressed
//                                             ? AppColors.secondary
//                                             : AppColors.fontPrimary.withOpacity(
//                                               0.15,
//                                             ),
//                                     width: 1,
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               // Middle Circle (Shadow + White Border)
//                               AnimatedPositioned(
//                                 duration: const Duration(milliseconds: 300),
//                                 top: 29,
//                                 left: 29,
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 300),
//                                   width: 222,
//                                   height: 222,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.white,
//                                     border: Border.all(
//                                       color: Colors.white,
//                                       width: 1,
//                                     ),
//                                     boxShadow:
//                                         _isPressed
//                                             ? [
//                                               BoxShadow(
//                                                 color: AppColors.secondary
//                                                     .withOpacity(0.5),
//                                                 offset: const Offset(0, 0),
//                                                 blurRadius: 50,
//                                               ),
//                                             ]
//                                             : [
//                                               BoxShadow(
//                                                 color: AppColors.fontPrimary
//                                                     .withOpacity(0.25),
//                                                 offset: const Offset(0, 2),
//                                                 blurRadius: 4,
//                                               ),
//                                             ],
//                                   ),
//                                 ),
//                               ),
//                               // Inner Circle (Primary with Border)
//                               AnimatedPositioned(
//                                 duration: const Duration(milliseconds: 300),
//                                 top: 45.5,
//                                 left: 45.5,
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 300),
//                                   width: 189,
//                                   height: 189,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.primary,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color:
//                                           _isPressed
//                                               ? AppColors.fontPrimary
//                                                   .withOpacity(0.25)
//                                               : AppColors.fontSecondary,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: AnimatedContainer(
//                                       duration: const Duration(
//                                         milliseconds: 300,
//                                       ),
//                                       width: _isPressed ? 60 : 50,
//                                       height: _isPressed ? 60 : 50,
//                                       child: Image.asset(
//                                         'assets/Vector.png',
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Snapping Sheet (drawer)
//           SnappingSheet(
//             controller: _sheetController,
//             grabbingHeight: 60,
//             grabbing: GestureDetector(
//               onTap: _toggleSheet,
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Drag indicator
//                     Container(
//                       width: 48,
//                       height: 6,
//                       decoration: BoxDecoration(
//                         color: AppColors.background,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Drag to expand',
//                       style: TextStyle(
//                         color: AppColors.fontPrimary,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             snappingPositions: const [
//               SnappingPosition.factor(
//                 positionFactor: 0.0,
//                 grabbingContentOffset: GrabbingContentOffset.top,
//               ),
//               SnappingPosition.factor(
//                 positionFactor: 1.0,
//                 grabbingContentOffset: GrabbingContentOffset.bottom,
//               ),
//             ],
//             sheetBelow: SnappingSheetContent(
//               draggable: true,
//               child: Container(
//                 color: AppColors.background,
//                 padding: const EdgeInsets.all(20),
//                 // Removed the "Product Information" text
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Carousel of recently scanned products
//                     SizedBox(
//                       height: 120,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _recentProducts.length,
//                         itemBuilder: (context, index) {
//                           final product = _recentProducts[index];
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: RecentlyScannedProductCard(
//                               score: product['score'],
//                               title: product['title'],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     // Preferences Button: more square and text aligned to left
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const PreferencesPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         minimumSize: const Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Preferences',
//                           style: TextStyle(
//                             color: AppColors.background,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// A card representing a recently scanned product with a colored hexagon and title.
// class RecentlyScannedProductCard extends StatelessWidget {
//   final int score;
//   final String title;
//   const RecentlyScannedProductCard({
//     Key? key,
//     required this.score,
//     required this.title,
//   }) : super(key: key);

//   // Returns the appropriate color based on the score.
//   Color getColorForScore(int score) {
//     if (score >= 8) {
//       return Colors.red;
//     } else if (score >= 6) {
//       return Colors.orange;
//     } else if (score >= 4) {
//       return Colors.yellow;
//     } else {
//       return Colors.green;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100, // A square container
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Circle instead of hexagon
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: getColorForScore(score),
//             ),
//             child: Center(
//               child: Text(
//                 '$score',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12, color: Colors.black87),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// A custom clipper to create a hexagon shape.
// class HexagonClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final double width = size.width;
//     final double height = size.height;
//     final Path path = Path();
//     // Define points for a hexagon
//     path.moveTo(width * 0.25, 0);
//     path.lineTo(width * 0.75, 0);
//     path.lineTo(width, height * 0.5);
//     path.lineTo(width * 0.75, height);
//     path.lineTo(width * 0.25, height);
//     path.lineTo(0, height * 0.5);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }



import 'package:flutter/material.dart';
import 'package:glow_know/screens/home_screen.dart';
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
      theme: themeData,
      home: const MyHomePage(),
    );
  }
}