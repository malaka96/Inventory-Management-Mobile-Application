import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_dropdown_field.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_text_field.dart';

class UpdateProductBottomSheetBody extends StatefulWidget {
  final TextEditingController productNameController;
  final TextEditingController initialQuantityController;
  final TextEditingController minimumStockController;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onDelete;
  final VoidCallback onUpdateProduct;
  final VoidCallback? onClose;

  const UpdateProductBottomSheetBody({
    super.key,
    required this.productNameController,
    required this.initialQuantityController,
    required this.minimumStockController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.onDelete,
    required this.onUpdateProduct,
    this.onClose,
  });

  @override
  State<UpdateProductBottomSheetBody> createState() =>
      _UpdateProductBottomSheetBodyState();
}

class _UpdateProductBottomSheetBodyState
    extends State<UpdateProductBottomSheetBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category is required';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Initial quantity is required';
    }
    final qty = int.tryParse(value.trim());
    if (qty == null || qty < 0) {
      return 'Please enter a valid quantity';
    }
    return null;
  }

  String? _validateMinimumStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Minimum stock level is required';
    }
    final stock = int.tryParse(value.trim());
    if (stock == null || stock < 0) {
      return 'Please enter a valid stock level';
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
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Update Product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onClose ?? () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          size: 22,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 18),

                _FieldLabel(label: 'Product Name'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: widget.productNameController,
                  hintText: 'Enter product name',
                  validator: _validateProductName,
                ),

                const SizedBox(height: 16),

                _FieldLabel(label: 'Category'),
                const SizedBox(height: 8),
                CustomDropdownField(
                  value: widget.selectedCategory,
                  hintText: 'Select category',
                  items: widget.categories,
                  onChanged: widget.onCategoryChanged,
                  validator: _validateCategory,
                ),

                const SizedBox(height: 16),

                _FieldLabel(label: 'Initial Quantity'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: widget.initialQuantityController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateQuantity,
                ),

                const SizedBox(height: 16),

                _FieldLabel(label: 'Minimum Stock Level'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: widget.minimumStockController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateMinimumStock,
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onDelete,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onUpdateProduct();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: const Color(0xFF5E7BF9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
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

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF4D4F),
          ),
        ),
      ],
    );
  }
}
