import 'package:flutter/material.dart';
import 'package:glow_know/screens/camera_page.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/screens/camera_page.dart'; // Update with your project name
import 'package:glow_know/screens/preferences_screen.dart';

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
                  'Glow Know',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                RoundElevatedButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraPage(),
                        ),
                      ),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                  diameter: 120,
                  backgroundColor: Colors.grey[300]!,
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
