import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_status_provider.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_filter_chip.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_search_field.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/empty_history_view.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/stock_card.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                    CustomFilterChip(label: 'Filter', onTap: () {}),
                    // StockCard(
                    //   title: "Title",
                    //   subtitle: "Subtitle",
                    //   dateTime: "2026/03/23",
                    //   quantity: 96,
                    //   status: false,
                    // ),
                    productStatusProvider.productStatuses.isEmpty ? Expanded(
                      child: Center(child: EmptyHistoryView()),
                    ): Expanded(
                      child: ListView.builder(
                        itemCount: productStatusProvider.productStatuses.length,
                        itemBuilder: (context, index) {
                          final status = productStatusProvider.productStatuses[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: StockCard(
                              title: status.productName,
                              subtitle: status.status ? "Stock Out" : "Stock In",
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
