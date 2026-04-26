import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/stock_bottomsheet.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/update_product_bottom_sheet.dart';

class ProductWidget extends StatefulWidget {
  final int productId;
  final String productName;
  final String category;
  final int initialStock;
  final int minStock;
  final TextEditingController stockController;
  final Future<int> Function(int qty) onStockIn;
  final Future<int> Function(int qty) onStockOut;
  final Future<void> Function(int productId) onDelete;
  final Future<void> Function(Product product) onUpdate;

  const ProductWidget({
    super.key,
    required this.productId,
    required this.productName,
    required this.category,
    required this.initialStock,
    required this.minStock,
    required this.stockController,
    required this.onStockIn,
    required this.onStockOut,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ValueNotifier<int> stockNotifier;
  late TextEditingController productNameController;
  late TextEditingController initialQuantityController;
  late TextEditingController minimumStockController;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    stockNotifier = ValueNotifier<int>(widget.initialStock);
    productNameController = TextEditingController(text: widget.productName);
    initialQuantityController = TextEditingController(
      text: widget.initialStock.toString(),
    );
    minimumStockController = TextEditingController(
      text: widget.minStock.toString(),
    );
    selectedCategory = widget.category;
  }

  @override
  void didUpdateWidget(covariant ProductWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStock != widget.initialStock) {
      stockNotifier.value = widget.initialStock;
    }
  }

  @override
  void dispose() {
    stockNotifier.dispose();
    productNameController.dispose();
    initialQuantityController.dispose();
    minimumStockController.dispose();
    super.dispose();
  }

  void showBottomSheet(BuildContext context, bool isStockIn) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: StockBottomSheet(
            isStockIn: isStockIn,
            productName: widget.productName,
            currentStock: stockNotifier.value,
            stockController: widget.stockController,
            onStockIn: (qty) async {
              final updatedStock = await widget.onStockIn(qty);
              stockNotifier.value = updatedStock;
              return updatedStock;
            },
            onStockOut: (qty) async {
              final updatedStock = await widget.onStockOut(qty);
              stockNotifier.value = updatedStock;
              return updatedStock;
            },
          ),
        );
      },
    );
  }

  void showProductUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return UpdateProductBottomSheetBody(
          productNameController: productNameController,
          initialQuantityController: initialQuantityController,
          minimumStockController: minimumStockController,
          selectedCategory: widget.category,
          categories: const ["Electronic", "Clothes", "Hardware", "Other"],
          onCategoryChanged: (newCategory) {
            setState(() {
              selectedCategory = newCategory ?? widget.category;
            });
          },
          onDelete: () async {
            await widget.onDelete(widget.productId);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          onUpdateProduct: () async {
            final updatedProduct = Product(
              id: widget.productId,
              name: productNameController.text.trim(),
              quatity: int.parse(initialQuantityController.text.trim()),
              category: selectedCategory,
              minStock: int.parse(minimumStockController.text.trim()),
            );
            await widget.onUpdate(updatedProduct);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showProductUpdateBottomSheet(context),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Product Name and Stock Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(widget.category),
                  ],
                ),
                ValueListenableBuilder<int>(
                  valueListenable: stockNotifier,
                  builder: (context, stock, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: stock > 0 ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        stock > 0 ? "In Stock" : "Out of Stock",
                        style: TextStyle(
                          color: stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Second Row: Category and Add/Remove Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 2), // Spacer
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_downward_sharp),
                      onPressed: () {
                        showBottomSheet(context, false);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_upward_sharp),
                      onPressed: () {
                        showBottomSheet(context, true);
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Stock Quantity and Minimum Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: stockNotifier,
                  builder: (context, stock, child) {
                    return Text(
                      'Quantity: $stock',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(width: 20),
                Text('Min: ${widget.minStock}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
