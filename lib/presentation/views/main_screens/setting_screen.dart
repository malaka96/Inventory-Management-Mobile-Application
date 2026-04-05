import 'package:flutter/material.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/app_info_card.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_action_button.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_setting_tile.dart';


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF5E7BF9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(title: 'Backup & Restore'),
                    const SizedBox(height: 14),

                    CustomActionCard(
                      icon: Icons.download_rounded,
                      iconColor: const Color(0xFF5E7BF9),
                      iconBackgroundColor: const Color(0xFFEFF2FF),
                      title: 'Export Data',
                      description:
                          'Download all your inventory data as a JSON file',
                      buttonText: 'Export Backup',
                      buttonColor: const Color(0xFF5E7BF9),
                      buttonTextColor: Colors.white,
                      borderColor: const Color(0xFFE5E7EB),
                      onButtonPressed: () {},
                    ),

                    const SizedBox(height: 14),

                    CustomActionCard(
                      icon: Icons.upload_rounded,
                      iconColor: const Color(0xFF10B981),
                      iconBackgroundColor: const Color(0xFFEAFBF3),
                      title: 'Import Data',
                      description:
                          'Restore your inventory from a backup file',
                      buttonText: 'Import Backup',
                      buttonColor: const Color(0xFFF1F5F9),
                      buttonTextColor: const Color(0xFF0F172A),
                      borderColor: const Color(0xFFE5E7EB),
                      onButtonPressed: () {},
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Data Management'),
                    const SizedBox(height: 14),

                    CustomActionCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFFF4D4F),
                      iconBackgroundColor: const Color(0xFFFFF1F2),
                      title: 'Clear All Data',
                      description:
                          'Remove all products and transaction history. This cannot be undone.',
                      buttonText: 'Clear Data',
                      buttonColor: const Color(0xFFFF4D4F),
                      buttonTextColor: Colors.white,
                      borderColor: const Color(0xFFFECACA),
                      isDanger: true,
                      onButtonPressed: () {},
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'About'),
                    const SizedBox(height: 14),

                    AppInfoCard(
                      appName: 'Smart Inventory Manager',
                      version: '1.0.0',
                      description:
                          'An offline-first inventory management application designed for small business owners to easily track and manage their product inventory.',
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Help & Support'),
                    const SizedBox(height: 14),

                    CustomSettingsTile(
                      title: 'How to Use',
                      leadingIcon: Icons.info_outline,
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),

                    CustomSettingsTile(
                      title: 'Contact Support',
                      leadingIcon: Icons.info_outline,
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }
}