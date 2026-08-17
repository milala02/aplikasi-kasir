import 'package:flutter/material.dart';

void main() {
  runApp(const WarungPintarApp());
}

class WarungPintarApp extends StatelessWidget {
  const WarungPintarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Pintar',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Warung Pintar'),
        ),
        body: const Center(
          child: Text('Warung Pintar Engine'),
        ),
      ),
    );
  }
}
