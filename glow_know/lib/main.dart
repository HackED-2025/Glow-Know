import 'package:flutter/material.dart';
import 'package:glow_know/screens/camera_page.dart'; // Update with your project name

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'My App', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  Text(
                    'Glow Know',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                      fontSize: 32,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 60),
            // Middle Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Tap to scan product',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Replace the circular Container with RoundElevatedButton
                  RoundElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                    diameter: 222, // Same size as the original Container
                    backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                color: Color.fromRGBO(223, 223, 223, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 136, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  Container(
                    width: 80,
                    height: 10,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Stack(children: <Widget>[
          
        ]
      ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        shape: const CircleBorder(), // Makes the button round
        padding: EdgeInsets.all(diameter * 0.2), // Adjust padding
        minimumSize: Size(diameter, diameter), // Set button size
      ),
      child: child, // Add the required child parameter
    );
  }
}
