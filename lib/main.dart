import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/views/screen_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ScreenManager(),);
  }
}