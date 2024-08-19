import 'package:flutter/material.dart';
import 'weather.dart';
import 'forecast.dart';
import 'about.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Template",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.teal)
      ),
      home: const Weather(),
    );
  }
}
