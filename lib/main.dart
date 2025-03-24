import 'package:flutter/material.dart';

import 'homescreen.dart';
import 'productinfo.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      //home: ProductDetailsScreen(),
    );
  }
}
