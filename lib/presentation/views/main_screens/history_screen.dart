import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_status_provider.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_filter_chip.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_search_field.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/empty_history_view.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/history_filter_bottom_sheet_body.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/stock_card.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? selectedFilterTransactionType;
  String? selectedFilterProduct;
  String? selectedFilterDateRange;

  final List<String> transactionTypeOptions = ["All", "Stock In", "Stock Out"];
  final List<String> dateRangeOptions = [
    "All Items",
    "Today",
    "Last 7 Days",
    "Last 30 Days",
  ];
  List<String> productOptions = ["All"];

  void onFilterTransactionTypeChanged(String? value) {
    setState(() {
      selectedFilterTransactionType = value;
    });
  }

  void onFilterProductChanged(String? value) {
    setState(() {
      selectedFilterProduct = value;
    });
  }

  void onFilterDateRangeChanged(String? value) {
    setState(() {
      selectedFilterDateRange = value;
    });
  }

  void onApplyHistoryFilter() {
    // TODO: Implement filter logic
    Navigator.pop(context);
  }

  void showHistoryFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => HistoryFilterBottomSheetBody(
        selectedTransactionType: selectedFilterTransactionType,
        selectedProduct: selectedFilterProduct,
        selectedDateRange: selectedFilterDateRange,
        transactionTypeOptions: transactionTypeOptions,
        productOptions: productOptions,
        dateRangeOptions: dateRangeOptions,
        onTransactionTypeChanged: onFilterTransactionTypeChanged,
        onProductChanged: onFilterProductChanged,
        onDateRangeChanged: onFilterDateRangeChanged,
        onCancel: () => Navigator.pop(context),
        onApplyFilter: onApplyHistoryFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productStatusProvider = context.watch<ProductStatusProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
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
                    'History',
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
                    CustomFilterChip(
                      label: 'Filter',
                      onTap: () => showHistoryFilterBottomSheet(context),
                    ),
                    // StockCard(
                    //   title: "Title",
                    //   subtitle: "Subtitle",
                    //   dateTime: "2026/03/23",
                    //   quantity: 96,
                    //   status: false,
                    // ),
                    productStatusProvider.productStatuses.isEmpty
                        ? Expanded(child: Center(child: EmptyHistoryView()))
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  productStatusProvider.productStatuses.length,
                              itemBuilder: (context, index) {
                                final status = productStatusProvider
                                    .productStatuses[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: StockCard(
                                    title: status.productName,
                                    subtitle: status.status
                                        ? "Stock Out"
                                        : "Stock In",
                                    dateTime: status.timestamp.toString(),
                                    quantity: status.value,
                                    status: status.status,
                                  ),
                                );
                              },
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
