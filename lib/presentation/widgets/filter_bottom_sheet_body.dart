import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_dropdown_field.dart';

class FilterBottomSheetBody extends StatelessWidget {
  final String? selectedStockStatus;
  final String? selectedCategory;
  final List<String> stockStatusOptions;
  final List<String> categories;
  final ValueChanged<String?> onStockStatusChanged;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onCancel;
  final VoidCallback onApplyFilter;
  final VoidCallback? onClose;

  const FilterBottomSheetBody({
    super.key,
    required this.selectedStockStatus,
    required this.selectedCategory,
    required this.stockStatusOptions,
    required this.categories,
    required this.onStockStatusChanged,
    required this.onCategoryChanged,
    required this.onCancel,
    required this.onApplyFilter,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter Products',
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

              _FieldLabel(label: 'Stock Status'),
              const SizedBox(height: 8),
              CustomDropdownField(
                value: selectedStockStatus,
                hintText: 'Select stock status',
                items: stockStatusOptions,
                onChanged: onStockStatusChanged,
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
                      onPressed: onApplyFilter,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: const Color(0xFF5E7BF9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Apply Filter',
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
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
    );
  }
}
