import 'package:flutter/material.dart';
import 'package:glow_know/screens/home_screen.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:snapping_sheet/snapping_sheet.dart';
// import 'package:glow_know/screens/camera_page.dart';
import 'package:glow_know/utils/theme.dart';
// import 'package:glow_know/assets/svgs.dart';
// import 'package:glow_know/screens/product_info_page.dart';
// import 'package:glow_know/models/product.dart';
// import 'package:glow_know/services/history_service.dart';
// import 'package:glow_know/screens/all_scanned_items_page.dart';

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