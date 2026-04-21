import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/stock_bottomsheet.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/update_product_bottom_sheet.dart';

class ProductWidget extends StatefulWidget {
  final String productName;
  final String category;
  final int initialStock;
  final int minStock;
  final TextEditingController stockController;
  final Future<int> Function(int qty) onStockIn;
  final Future<int> Function(int qty) onStockOut;

  const ProductWidget({
    super.key,
    required this.productName,
    required this.category,
    required this.initialStock,
    required this.minStock,
    required this.stockController,
    required this.onStockIn,
    required this.onStockOut,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ValueNotifier<int> stockNotifier;
  late TextEditingController productNameController;
  late TextEditingController initialQuantityController;
  late TextEditingController minimumStockController;

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
          categories: const [
            "Electronic", "Clothes", "Hardware", "Other"
          ],
          onCategoryChanged: (newCategory) {
            // Handle category change
          },
          onDelete: () {
            Navigator.pop(context);
            // Add delete functionality here
          },
          onAddProduct: () {
            Navigator.pop(context);
            // Add update functionality here
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
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
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
                        style: TextStyle(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: stock > 0
                              ? Colors.green[100]
                              : Colors.red[100],
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
                  SizedBox(width: 2), // Spacer
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_downward_sharp),
                        onPressed: () {
                          showBottomSheet(context, false);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_upward_sharp),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  SizedBox(width: 20),
                  Text('Min: ${widget.minStock}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
