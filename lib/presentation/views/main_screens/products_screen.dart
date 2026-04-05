import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/add_product_botton_sheet_body.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_filter_chip.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_search_field.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/empty_product_view.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/product_add_button.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController productNameController = TextEditingController();

  final TextEditingController initialQuantityController =
      TextEditingController();

  final TextEditingController minimumStockController = TextEditingController();

  String? selectedCategory;

  List<String> categories = ["Electronic", "Clothes", "Hardware", "Other"];

  void onCategoryChanged(String? value) {
    setState(() {
      selectedCategory = value ?? "";
    });
  }

  void onCancel() {}

  void onAddProduct() {}

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1.25,
          child: AddProductBottomSheetBody(
            productNameController: productNameController,
            initialQuantityController: initialQuantityController,
            minimumStockController: minimumStockController,
            selectedCategory: selectedCategory,
            categories: categories,
            onCategoryChanged: onCategoryChanged,
            onCancel: onCancel,
            onAddProduct: onAddProduct,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      floatingActionButton: ProductAddButton(
        ontap: () => showBottomSheet(context),
      ),
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
                      child: Center(
                        child: EmptyProductView(
                          onTap: () => showBottomSheet(context),
                        ),
                      ),
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
