import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_provider.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_status_provider.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/low_stock_card.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/out_of_stock_summary_card.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/recent_activity.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/summary_card.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/stock_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top section with blue header and stats cards
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 90),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C83F7),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Overview of your inventory",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: -40,
                    child: Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        final totalProducts = productProvider.products.length;
                        final lowStockCount =
                            productProvider.lowStockProducts.length;

                        return Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: "Total\nProducts",
                                value: totalProducts.toString(),
                                icon: Icons.inventory_2_outlined,
                                iconBgColor: const Color(0xFFE8ECFF),
                                iconColor: const Color(0xFF6C83F7),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: SummaryCard(
                                title: "Low\nStock",
                                value: lowStockCount.toString(),
                                icon: Icons.warning_amber_rounded,
                                iconBgColor: const Color(0xFFFFF1DD),
                                iconColor: const Color(0xFFFFA000),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final outOfStockCount = productProvider.outOfStockCount;
                  if (outOfStockCount <= 0) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutOfStockSummaryCard(
                        value: outOfStockCount.toString(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Low Stock Items title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Low Stock Items",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final lowStock = productProvider.lowStockProducts;

                  if (productProvider.isLoading && lowStock.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (lowStock.isEmpty) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFFFF1DD),
                            child: Icon(
                              Icons.warning_amber_rounded,
                              size: 18,
                              color: Color(0xFFFFA000),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "No low stock items",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F1B4C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final maxHeight =
                      (MediaQuery.sizeOf(context).height * 0.36).clamp(220, 360);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxHeight.toDouble()),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: lowStock.length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final product = lowStock[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: LowStockCard(
                              title: product.name,
                              subtitle: product.category,
                              quantity: product.quatity,
                              minStock: product.minStock,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Recent Activity title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Activity card
              Consumer<ProductStatusProvider>(
                builder: (context, productStatusProvider, child) {
                  final statuses = productStatusProvider.productStatuses;
                  if (statuses.isEmpty) {
                    return const RecentActivity();
                  }

                  final latestTen = statuses.length > 5
                      ? statuses.sublist(0, 5)
                      : statuses;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        for (final status in latestTen)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: StockCard(
                              title: status.productName,
                              subtitle: status.status ? "Stock Out" : "Stock In",
                              dateTime: status.timestamp.toString(),
                              quantity: status.value,
                              status: status.status,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

}
