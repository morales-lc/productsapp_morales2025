import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'productinfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
      home: ProductDetailsScreen(),
    );
  }
}
