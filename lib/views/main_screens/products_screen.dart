import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/widgets/custom_filter_chip.dart';
import 'package:inventory_management_mobile_app/widgets/custom_search_field.dart';
import 'package:inventory_management_mobile_app/widgets/empty_product_view.dart';
import 'package:inventory_management_mobile_app/widgets/product_add_button.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      floatingActionButton: ProductAddButton(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF5E7BF9),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(28),
                //   bottomRight: Radius.circular(28),
                // ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomSearchField(hintText: 'Search products...'),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFilterChip(label: 'Filter', onTap: () {}),
                    Expanded(
                      child: Center(child: EmptyProductView(onTap: () {})),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
