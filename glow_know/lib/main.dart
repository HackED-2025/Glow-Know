import 'package:flutter/material.dart';
import 'package:glow_know/screens/camera_page.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glow Know',
      home: MyHomePage(),
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

  void _toggleSheet() => _sheetController.snapToPosition(
    _sheetController.currentPosition < 50
        ? const SnappingPosition.factor(positionFactor: 1.0)
        : const SnappingPosition.factor(positionFactor: 0.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tap to scan product',
                  style: TextStyle(
                    color: Color.fromRGBO(237, 105, 139, 1),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraPage(),
                        ),
                      ),
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        // Outer Circle (Border)
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.15), width: 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Middle Circle (Shadow + White Border)
                        Positioned(
                          top: 29,
                          left: 29,
                          child: Container(
                            width: 222,
                            height: 222,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Inner Circle (Red with Border)
                        Positioned(
                          top: 45.5,
                          left: 45.5,
                          child: Container(
                            width: 189,
                            height: 189,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(175, 50, 82, 1),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color.fromARGB(255, 206, 206, 206), width: 1),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/Vector.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                semanticLabel: 'Camera Icon',
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
          SnappingSheet(
            controller: _sheetController,
            grabbingHeight: 60,
            grabbing: GestureDetector(
              onTap: _toggleSheet,
              child: Container(
                color: Colors.grey[800],
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            snappingPositions: const [
              SnappingPosition.factor(positionFactor: 0.0),
              SnappingPosition.factor(positionFactor: 1.0),
            ],
            sheetBelow: SnappingSheetContent(
              draggable: true,
              child: Container(
                color: Colors.grey[850],
                child: const Center(
                  child: Text(
                    'Product Information',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double diameter;
  final Color backgroundColor;

  const RoundElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.diameter = 80,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.all(diameter * 0.2),
        minimumSize: Size(diameter, diameter),
      ),
      child: child,
    );
  }
}
