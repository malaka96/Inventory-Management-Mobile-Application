import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_provider.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_status_provider.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/add_product_botton_sheet_body.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_filter_chip.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_search_field.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/empty_product_view.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/filter_bottom_sheet_body.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/product_add_button.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/product_widget.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final TextEditingController initialQuantityController =
      TextEditingController();

  final TextEditingController minimumStockController = TextEditingController();

  final TextEditingController stockController = TextEditingController();

  String? selectedCategory;

  String? selectedFilterStatus;
  String? selectedFilterCategory;
  String _searchQuery = '';

  List<String> categories = ["Electronic", "Clothes", "Hardware", "Other"];
  List<String> stockStatusOptions = [
    "All",
    "In Stock",
    "Low Stock",
    "Out of Stock",
  ];
  List<String> filterCategories = [
    "All",
    "Electronic",
    "Clothes",
    "Hardware",
    "Other",
  ];

  void onCategoryChanged(String? value) {
    setState(() {
      selectedCategory = value ?? "";
    });
  }

  void onCancel() {}

  void onFilterStatusChanged(String? value) {
    setState(() {
      selectedFilterStatus = value;
    });
  }

  void onFilterCategoryChanged(String? value) {
    setState(() {
      selectedFilterCategory = value;
    });
  }

  List<Product> getFilteredProducts(List<Product> allProducts) {
    return allProducts.where((product) {
      final q = _searchQuery.trim().toLowerCase();
      if (q.isNotEmpty && !product.name.toLowerCase().contains(q)) {
        return false;
      }

      if (selectedFilterCategory != null &&
          selectedFilterCategory != "All" &&
          selectedFilterCategory!.isNotEmpty) {
        if (product.category != selectedFilterCategory) {
          return false;
        }
      }

      // Filter by stock status
      if (selectedFilterStatus != null && selectedFilterStatus != "All") {
        bool isInStock =
            product.quatity > 0 && product.quatity >= product.minStock;
        bool isLowStock =
            product.quatity > 0 && product.quatity < product.minStock;
        bool isOutOfStock = product.quatity <= 0;

        switch (selectedFilterStatus) {
          case "In Stock":
            if (!isInStock) return false;
            break;
          case "Low Stock":
            if (!isLowStock) return false;
            break;
          case "Out of Stock":
            if (!isOutOfStock) return false;
            break;
        }
      }

      return true;
    }).toList();
  }

  void onApplyFilter() {
    Navigator.pop(context);
    setState(() {});
  }

  void showFilterBottomSheet(BuildContext context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetBody(
        selectedStockStatus: selectedFilterStatus,
        selectedCategory: selectedFilterCategory,
        stockStatusOptions: stockStatusOptions,
        categories: filterCategories,
        onStockStatusChanged: onFilterStatusChanged,
        onCategoryChanged: onFilterCategoryChanged,
        onCancel: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        onApplyFilter: onApplyFilter,
        onClose: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
      ),
    ).whenComplete(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void dispose() {
    productNameController.dispose();
    searchController.dispose();
    initialQuantityController.dispose();
    minimumStockController.dispose();
    super.dispose();
  }

  void onAddProduct() {
    if (productNameController.text.isEmpty ||
        initialQuantityController.text.isEmpty ||
        minimumStockController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final productProvider = context.read<ProductProvider>();

    // Generate a unique ID (using timestamp for simplicity)
    final id = (DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF).toInt();

    final product = Product(
      id: id,
      name: productNameController.text.trim(),
      quatity: int.parse(initialQuantityController.text.trim()),
      category: selectedCategory!,
      minStock: int.parse(minimumStockController.text.trim()),
    );

    productProvider.addProduct(product);

    // Clear form
    productNameController.clear();
    initialQuantityController.clear();
    minimumStockController.clear();
    setState(() {
      selectedCategory = null;
    });

    // Close bottom sheet
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added successfully')));
  }

  Future<int> onStockIn(Product product, int qty) async {
    final updatedProduct = Product(
      id: product.id,
      name: product.name,
      quatity: product.quatity + qty,
      category: product.category,
      minStock: product.minStock,
    );
    final productProvider = context.read<ProductProvider>();
    final productStatusProvider = context.read<ProductStatusProvider>();

    await productProvider.updateProduct(updatedProduct);

    // Save product status with status = false for stockIn
    final productStatus = ProductStatus(
      productName: product.name,
      status: false,
      timestamp: DateTime.now(),
      value: qty,
    );
    // await productStatusRepositoryImpl.addProductStatus(productStatus);
    await productStatusProvider.addProductStatus(productStatus);

    stockController.clear();
    if (!mounted) return updatedProduct.quatity;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Stock updated successfully')));

    return updatedProduct.quatity;
  }

  Future<int> onStockOut(Product product, int qty) async {
    final updatedProduct = Product(
      id: product.id,
      name: product.name,
      quatity: product.quatity - qty,
      category: product.category,
      minStock: product.minStock,
    );

    final productProvider = context.read<ProductProvider>();
    final productStatusProvider = context.read<ProductStatusProvider>();

    await productProvider.updateProduct(updatedProduct);

    // Save product status with status = true for stockOut
    final productStatus = ProductStatus(
      productName: product.name,
      status: true,
      timestamp: DateTime.now(),
      value: qty,
    );
    // await productStatusRepositoryImpl.addProductStatus(productStatus);

    await productStatusProvider.addProductStatus(productStatus);

    stockController.clear();
    if (!mounted) return updatedProduct.quatity;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Stock updated successfully')));
    return updatedProduct.quatity;
  }

  Future<void> onDelete(dynamic productId) async {
    final productProvider = context.read<ProductProvider>();
    try {
      await productProvider.deleteProduct(productId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting product: $e')));
    }
  }

  Future<void> onUpdate(Product product) async {
    final productProvider = context.read<ProductProvider>();
    try {
      await productProvider.updateProduct(product);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating product: $e')));
    }
  }

  void showBottomSheet(BuildContext context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Keep the sheet widget stable while the keyboard animates by using
        // `AnimatedPadding` with a `child` that doesn't depend on viewInsets.
        final sheet = FractionallySizedBox(
          heightFactor: 0.84,
          child: AddProductBottomSheetBody(
            productNameController: productNameController,
            initialQuantityController: initialQuantityController,
            minimumStockController: minimumStockController,
            selectedCategory: selectedCategory,
            categories: categories,
            onCategoryChanged: onCategoryChanged,
            onCancel: onCancel,
            onAddProduct: onAddProduct,
            onClose: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
          ),
        );

        return AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: sheet,
        );
      },
    ).whenComplete(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final filteredProducts = getFilteredProducts(productProvider.products);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomSearchField(
                    controller: searchController,
                    hintText: 'Search products...',
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFilterChip(
                      label: 'Filter',
                      onTap: () => showFilterBottomSheet(context),
                    ),
                    Expanded(
                      child: Center(
                        child: filteredProducts.isEmpty
                            ? EmptyProductView(
                                onTap: () => showBottomSheet(context),
                              )
                            : ListView.separated(
                                itemCount: filteredProducts.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  return ProductWidget(
                                    productId: product.id,
                                    productName: product.name,
                                    category: product.category,
                                    initialStock: product.quatity,
                                    minStock: product.minStock,
                                    stockController: stockController,
                                    onStockIn: (qty) => onStockIn(product, qty),
                                    onStockOut: (qty) =>
                                        onStockOut(product, qty),
                                    onDelete: (productId) =>
                                        onDelete(productId),
                                    onUpdate: (product) => onUpdate(product),
                                  );
                                },
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
