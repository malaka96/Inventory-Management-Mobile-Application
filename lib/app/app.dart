import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/views/screen_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ScreenManager(),);
  }
}