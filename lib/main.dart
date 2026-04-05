import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/app/app.dart';
import 'package:inventory_management_mobile_app/core/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}
