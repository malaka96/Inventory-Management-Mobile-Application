import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_dropdown_field.dart';

class HistoryFilterBottomSheetBody extends StatelessWidget {
  final String? selectedTransactionType;
  final String? selectedProduct;
  final String? selectedDateRange;
  final List<String> transactionTypeOptions;
  final List<String> productOptions;
  final List<String> dateRangeOptions;
  final ValueChanged<String?> onTransactionTypeChanged;
  final ValueChanged<String?> onProductChanged;
  final ValueChanged<String?> onDateRangeChanged;
  final VoidCallback onCancel;
  final VoidCallback onApplyFilter;
  final VoidCallback? onClose;

  const HistoryFilterBottomSheetBody({
    super.key,
    required this.selectedTransactionType,
    required this.selectedProduct,
    required this.selectedDateRange,
    required this.transactionTypeOptions,
    required this.productOptions,
    required this.dateRangeOptions,
    required this.onTransactionTypeChanged,
    required this.onProductChanged,
    required this.onDateRangeChanged,
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
                      'Filter History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onClose ?? () {
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

              _FieldLabel(label: 'Transaction Type'),
              const SizedBox(height: 8),
              CustomDropdownField(
                value: selectedTransactionType,
                hintText: 'Select transaction type',
                items: transactionTypeOptions,
                onChanged: onTransactionTypeChanged,
              ),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Product'),
              const SizedBox(height: 8),
              CustomDropdownField(
                value: selectedProduct,
                hintText: 'Select product',
                items: productOptions,
                onChanged: onProductChanged,
              ),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Date Range'),
              const SizedBox(height: 8),
              CustomDropdownField(
                value: selectedDateRange,
                hintText: 'Select date range',
                items: dateRangeOptions,
                onChanged: onDateRangeChanged,
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
