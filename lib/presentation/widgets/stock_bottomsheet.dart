import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_text_field.dart';

class StockBottomSheet extends StatelessWidget {
  final bool isStockIn;
  final String productName;
  final int currentStock;
  final TextEditingController stockController;
  final Future<int> Function(int qty) onStockIn;
  final Future<int> Function(int qty) onStockOut;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  StockBottomSheet({
    super.key,
    required this.isStockIn,
    required this.productName,
    required this.currentStock,
    required this.stockController,
    required this.onStockIn,
    required this.onStockOut,
  });

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    final qty = int.tryParse(value.trim());
    if (qty == null || qty <= 0) {
      return 'Please enter a valid quantity';
    }
    // For Stock Out, validate that we don't remove more than current stock
    if (!isStockIn && qty > currentStock) {
      return 'Cannot remove more than current stock ($currentStock)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isStockIn ? 'Stock In' : 'Stock Out',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              const Divider(),
              SizedBox(height: 10),
              Text(
                'Product',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                productName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Current Stock',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                currentStock.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Quantity *',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              CustomTextField(
                hintText: 'Enter quantity',
                controller: stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateQuantity,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Action Button (Add Stock / Remove Stock)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final qty = int.parse(stockController.text.trim());
                          if (isStockIn) {
                            await onStockIn(qty);
                          } else {
                            await onStockOut(qty);
                          }
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isStockIn ? Colors.blue : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isStockIn
                          ? Text(
                              'Add Stock',
                              style: TextStyle(color: Colors.white),
                            )
                          : Text(
                              'Remove Stock',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
