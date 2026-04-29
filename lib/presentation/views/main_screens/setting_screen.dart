import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inventory_management_mobile_app/core/services/export/export_file_saver.dart';
import 'package:inventory_management_mobile_app/core/services/export/inventory_export_service.dart';
import 'package:inventory_management_mobile_app/core/services/import/inventory_import_service.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_provider.dart';
import 'package:inventory_management_mobile_app/presentation/provider/product_status_provider.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/how_to_use_bottom_sheet_body.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/contact_support_bottom_sheet_body.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/app_info_card.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_action_button.dart';
import 'package:inventory_management_mobile_app/presentation/widgets/custom_setting_tile.dart';
import 'package:provider/provider.dart';

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
                      onButtonPressed: () => _exportAllData(context),
                    ),

                    const SizedBox(height: 14),

                    CustomActionCard(
                      icon: Icons.upload_rounded,
                      iconColor: const Color(0xFF10B981),
                      iconBackgroundColor: const Color(0xFFEAFBF3),
                      title: 'Import Data',
                      description: 'Restore your inventory from a backup file',
                      buttonText: 'Import Backup',
                      buttonColor: const Color(0xFFF1F5F9),
                      buttonTextColor: const Color(0xFF0F172A),
                      borderColor: const Color(0xFFE5E7EB),
                      onButtonPressed: () => _importAllData(context),
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
                      onButtonPressed: () {
                        _showClearAllDataDialog(context);
                      },
                    ),

                    const SizedBox(height: 24),

                    CustomActionCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFFF4D4F),
                      iconBackgroundColor: const Color(0xFFFFF1F2),
                      title: 'Clear History',
                      description:
                          'Remove all transaction history while keeping your product data intact.',
                      buttonText: 'Clear History',
                      buttonColor: const Color(0xFFFF4D4F),
                      buttonTextColor: Colors.white,
                      borderColor: const Color(0xFFFECACA),
                      isDanger: true,
                      onButtonPressed: () {
                        _showClearHistoryDialog(context);
                      },
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
                      onTap: () => _showHowToUseBottomSheet(context),
                    ),

                    const SizedBox(height: 12),

                    CustomSettingsTile(
                      title: 'Contact Support',
                      leadingIcon: Icons.info_outline,
                      onTap: () => _showContactSupportBottomSheet(context),
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

  void _showClearAllDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear All Data?'),
          content: const Text(
            'This will permanently delete all products and transaction history. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                // Clear all products and transaction history
                final productProvider = context.read<ProductProvider>();
                final productStatusProvider = context
                    .read<ProductStatusProvider>();

                await productProvider.clearAllProducts();
                await productStatusProvider.clearAllProductStatuses();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data cleared successfully'),
                      backgroundColor: Color(0xFFFF4D4F),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF4D4F),
              ),
              child: const Text('Clear All Data'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportAllData(BuildContext context) async {
    final saver = createExportFileSaver();
    final exportService = InventoryExportService();

    final now = DateTime.now();
    final suggestedName = 'inventory_backup_${_fileSafeTimestamp(now)}.json';

    final products = context.read<ProductProvider>().products;
    final statuses = context.read<ProductStatusProvider>().productStatuses;
    final json = exportService.buildExportJson(
      products: products,
      productStatuses: statuses,
      exportedAt: now,
    );

    _showBlockingLoader(context, message: 'Exporting...');
    try {
      // Mobile-friendly path: SAF-backed save flow (Android/iOS).
      try {
        await saver.saveStringWithPicker(
          suggestedFileName: suggestedName,
          contents: json,
        );
      } on UnsupportedError {
        String? path;
        try {
          path = await saver.pickSavePath(suggestedFileName: suggestedName);
        } catch (e) {
          throw Exception('Could not open file picker: $e');
        }
        if (path == null) {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          return;
        }
        await saver.writeString(path: path, contents: json);
      }
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup exported successfully'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export failed'),
            backgroundColor: Color(0xFFFF4D4F),
          ),
        );
      }
    }
  }

  void _showHowToUseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.84,
        child: HowToUseBottomSheetBody(
          onClose: () => Navigator.pop(context),
        ),
      ),
    ).whenComplete(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void _showContactSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.72,
        child: ContactSupportBottomSheetBody(
          supportEmail: 'madhubhashana655@gmail.com',
          linkedInUrl: 'https://www.linkedin.com/in/malaka-madhubhashana/',
          onClose: () => Navigator.pop(context),
        ),
      ),
    ).whenComplete(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  Future<void> _importAllData(BuildContext context) async {
    final confirmed = await _confirmOverwriteImport(context);
    if (confirmed != true) return;

    FilePickerResult? result;
    try {
      result = await FilePicker.pickFiles(
        dialogTitle: 'Select backup file',
        type: FileType.custom,
        allowedExtensions: const ['json', 'txt'],
        withData: true,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file picker: $e')),
        );
      }
      return;
    }

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    final path = file.path;

    String contents;
    try {
      if (bytes != null) {
        contents = utf8.decode(bytes);
      } else if (path != null) {
        contents = await _readFileAsString(path);
      } else {
        throw Exception('Could not read selected file');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not read backup file: $e')),
        );
      }
      return;
    }

    final importService = InventoryImportService();

    _showBlockingLoader(context, message: 'Importing...');
    try {
      final data = importService.parseExportedJson(contents);
      await context.read<ProductProvider>().replaceAllProducts(data.products);
      await context
          .read<ProductStatusProvider>()
          .replaceAllProductStatuses(data.productStatuses);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup imported successfully'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: const Color(0xFFFF4D4F),
          ),
        );
      }
    }
  }

  Future<bool?> _confirmOverwriteImport(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import Backup?'),
        content: const Text(
          'This will override your existing products and transaction history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  Future<String> _readFileAsString(String path) async {
    // Avoid adding new dependencies; rely on dart:io via conditional saver file already used elsewhere.
    // This method will only be used on platforms where file paths are readable.
    return await File(path).readAsString();
  }

  static String _fileSafeTimestamp(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}${two(dt.month)}${two(dt.day)}_${two(dt.hour)}${two(dt.minute)}${two(dt.second)}';
  }

  void _showBlockingLoader(BuildContext context, {required String message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear Transaction History?'),
          content: const Text(
            'This will permanently delete all transaction history. Your product data will remain intact. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final productStatusProvider = context
                    .read<ProductStatusProvider>();

                await productStatusProvider.clearAllProductStatuses();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction history cleared successfully'),
                      backgroundColor: Color(0xFFFF4D4F),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF4D4F),
              ),
              child: const Text('Clear History'),
            ),
          ],
        );
      },
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
