import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/news_view.dart'; // Pastikan path ini benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan GetMaterialApp, bukan MaterialApp biasa
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter News',
      home: NewsView(),
    );
  }
}