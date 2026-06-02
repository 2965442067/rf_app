import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const RFApp());
}

class RFApp extends StatelessWidget {
  const RFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '射频管家',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}