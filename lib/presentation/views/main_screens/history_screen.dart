import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/domain/entities/product_status.dart';
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
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

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

  List<String> getProductNames(List<ProductStatus> statuses) {
    final names = <String>{"All"};
    for (var status in statuses) {
      names.add(status.productName);
    }
    return names.toList();
  }

  bool isWithinDateRange(DateTime timestamp, String? dateRange) {
    if (dateRange == null || dateRange == "All Items") {
      return true;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final statusDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    switch (dateRange) {
      case "Today":
        return statusDate == today;
      case "Last 7 Days":
        return statusDate.isAfter(today.subtract(const Duration(days: 7)));
      case "Last 30 Days":
        return statusDate.isAfter(today.subtract(const Duration(days: 30)));
      default:
        return true;
    }
  }

  List<ProductStatus> getFilteredStatuses(List<ProductStatus> allStatuses) {
    return allStatuses.where((status) {
      final q = _searchQuery.trim().toLowerCase();
      if (q.isNotEmpty && !status.productName.toLowerCase().contains(q)) {
        return false;
      }

      // Filter by transaction type (All, Stock In, Stock Out)
      if (selectedFilterTransactionType != null &&
          selectedFilterTransactionType != "All") {
        bool isStockIn = !status.status;
        bool isStockOut = status.status;

        switch (selectedFilterTransactionType) {
          case "Stock In":
            if (!isStockIn) return false;
            break;
          case "Stock Out":
            if (!isStockOut) return false;
            break;
        }
      }

      // Filter by product name
      if (selectedFilterProduct != null && selectedFilterProduct != "All") {
        if (status.productName != selectedFilterProduct) {
          return false;
        }
      }

      // Filter by date range
      if (!isWithinDateRange(status.timestamp, selectedFilterDateRange)) {
        return false;
      }

      return true;
    }).toList();
  }

  void onApplyHistoryFilter() {
    Navigator.pop(context);
    setState(() {});
  }

  void showHistoryFilterBottomSheet(BuildContext context) {
    final productStatusProvider = context.read<ProductStatusProvider>();
    final dynamicProductOptions = getProductNames(
      productStatusProvider.productStatuses,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => HistoryFilterBottomSheetBody(
        selectedTransactionType: selectedFilterTransactionType,
        selectedProduct: selectedFilterProduct,
        selectedDateRange: selectedFilterDateRange,
        transactionTypeOptions: transactionTypeOptions,
        productOptions: dynamicProductOptions,
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productStatusProvider = context.watch<ProductStatusProvider>();
    final filteredStatuses = getFilteredStatuses(
      productStatusProvider.productStatuses,
    );

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'History',
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
                        : filteredStatuses.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'No transactions found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredStatuses.length,
                              itemBuilder: (context, index) {
                                final status = filteredStatuses[index];
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
