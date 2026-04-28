import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_text_field.dart';

class StockBottomSheet extends StatefulWidget {
  final bool isStockIn;
  final String productName;
  final int currentStock;
  final TextEditingController stockController;
  final Future<int> Function(int qty) onStockIn;
  final Future<int> Function(int qty) onStockOut;

  const StockBottomSheet({
    super.key,
    required this.isStockIn,
    required this.productName,
    required this.currentStock,
    required this.stockController,
    required this.onStockIn,
    required this.onStockOut,
  });

  @override
  State<StockBottomSheet> createState() => _StockBottomSheetState();
}

class _StockBottomSheetState extends State<StockBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    final qty = int.tryParse(value.trim());
    if (qty == null || qty <= 0) {
      return 'Please enter a valid quantity';
    }
    // For Stock Out, validate that we don't remove more than current stock
    if (!widget.isStockIn && qty > widget.currentStock) {
      return 'Cannot remove more than current stock (${widget.currentStock})';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isStockIn ? 'Stock In' : 'Stock Out',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 18),
                const Text(
                  'Product',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Current Stock',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.currentStock.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quantity *',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter quantity',
                  controller: widget.stockController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateQuantity,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final qty = int.parse(
                              widget.stockController.text.trim(),
                            );
                            if (widget.isStockIn) {
                              await widget.onStockIn(qty);
                            } else {
                              await widget.onStockOut(qty);
                            }
                            if (context.mounted) {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor:
                              widget.isStockIn
                                  ? const Color(0xFF10B981)
                                  : Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          widget.isStockIn ? 'Add Stock' : 'Remove Stock',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
