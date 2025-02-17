import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:glow_know/screens/camera_page.dart';
import 'package:glow_know/screens/preferences_screen.dart';
import 'package:glow_know/utils/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vespera',
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
    _sheetController.snapToPosition(
      _sheetController.currentPosition < 50
          ? const SnappingPosition.factor(positionFactor: 1.0)
          : const SnappingPosition.factor(positionFactor: 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header with logo and app name
                const SizedBox(height: 60), // Adjust spacing as needed
                SvgPicture.asset('assets/logo.svg', height: 100),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Text(
                    'VESPERA',
                    style: TextStyle(
                      color: AppColors.fontPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 4.0,
                    ),
                  ),
                ),
                // Your original center content
                Center(
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
          // Snapping Sheet remains unchanged
          SnappingSheet(
            controller: _sheetController,
            grabbingHeight: 60,
            grabbing: GestureDetector(
              onTap: _toggleSheet,
              child: Container(
                color: AppColors.primary,
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.background,
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
                color: AppColors.background,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Product Information',
                      style: TextStyle(
                        color: AppColors.fontPrimary,
                        fontSize: 20,
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
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Preferences',
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
