import 'package:flutter/material.dart';
import 'package:glow_know/screens/home_screen.dart';
import 'package:glow_know/utils/theme.dart';

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
