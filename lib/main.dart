import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/app/app.dart';
import 'package:inventory_management_mobile_app/core/services/hive_service.dart';
import 'package:inventory_management_mobile_app/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await initInjection();
  runApp(const MyApp());
}
