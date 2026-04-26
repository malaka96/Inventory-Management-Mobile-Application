import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/injection.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_provider.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_status_provider.dart';
import 'package:inventory_management_mobile_app/presentation/views/screen_manager.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              ProductProvider(productRepositoryImpl)..loadProducts(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProductStatusProvider(productStatusRepositoryImpl)
                ..loadProductStatuses(),
        ),
      ],
      child: MaterialApp(home: ScreenManager()),
    );
  }
}
