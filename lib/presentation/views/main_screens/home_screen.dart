import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/recent_activity.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/summary_card.dart';

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
                    child: Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: "Total\nProducts",
                            value: "0",
                            icon: Icons.inventory_2_outlined,
                            iconBgColor: const Color(0xFFE8ECFF),
                            iconColor: const Color(0xFF6C83F7),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SummaryCard(
                            title: "Low\nStock",
                            value: "0",
                            icon: Icons.warning_amber_rounded,
                            iconBgColor: const Color(0xFFFFF1DD),
                            iconColor: const Color(0xFFFFA000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
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
              RecentActivity(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

}