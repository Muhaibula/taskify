import 'package:flutter/material.dart';
import 'splshscrn.dart'; // make sure the filename matches exactly

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // App starts from Splash Screen
    );
  }
}