import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/widgets/custom_dropdown_field.dart';
import 'package:inventory_management_mobile_app/widgets/custom_search_field.dart';

class AddProductBottomSheetBody extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController initialQuantityController;
  final TextEditingController minimumStockController;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onCancel;
  final VoidCallback onAddProduct;
  final VoidCallback? onClose;

  const AddProductBottomSheetBody({
    super.key,
    required this.productNameController,
    required this.initialQuantityController,
    required this.minimumStockController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.onCancel,
    required this.onAddProduct,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onClose ?? () => Navigator.pop(context),
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
              CustomSearchField(
                controller: productNameController,
                hintText: 'Enter product name',
              ),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Category'),
              const SizedBox(height: 8),
              CustomDropdownField(
                value: selectedCategory,
                hintText: 'Select category',
                items: categories,
                onChanged: onCategoryChanged,
              ),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Initial Quantity'),
              const SizedBox(height: 8),
              CustomSearchField(
                controller: initialQuantityController,
                hintText: '0',
              ),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Minimum Stock Level'),
              const SizedBox(height: 8),
              CustomSearchField(
                controller: minimumStockController,
                hintText: '0',
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
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
                      onPressed: onAddProduct,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: const Color(0xFF5E7BF9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Add Product',
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

