import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const BuggieApp());
}

class BuggieApp extends StatelessWidget {
  const BuggieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}