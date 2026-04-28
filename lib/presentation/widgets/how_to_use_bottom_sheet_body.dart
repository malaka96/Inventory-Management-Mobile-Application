import 'package:flutter/material.dart';

class HowToUseBottomSheetBody extends StatelessWidget {
  final VoidCallback? onClose;

  const HowToUseBottomSheetBody({super.key, this.onClose});

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
                      'How to Use',
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

              const _SectionTitle('Quick Start'),
              const SizedBox(height: 10),
              const _BodyText(
                'This app helps you track products and stock changes offline. '
                'Start by adding your products, then use Stock In/Out to record every movement.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Add Products'),
              const SizedBox(height: 10),
              const _BodyText(
                'Go to Products and tap the + button. Fill in the product name, category, '
                'initial quantity, and minimum stock level. Minimum stock is the line that decides '
                'when something counts as low stock.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Search and Filter'),
              const SizedBox(height: 10),
              const _BodyText(
                'Use the search box to quickly find a product by name. Tap Filter to narrow the list '
                'by category or stock status (In Stock, Low Stock, Out of Stock).',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Update or Delete a Product'),
              const SizedBox(height: 10),
              const _BodyText(
                'Open a product and choose Update to edit details like name, category, or stock thresholds. '
                'Use Delete to remove a product completely.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Stock In and Stock Out'),
              const SizedBox(height: 10),
              const _BodyText(
                'When you receive new items, use Stock In and enter the quantity added. '
                'When you sell or remove items, use Stock Out and enter the quantity removed. '
                'The app prevents you from stocking out more than you currently have.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('History (Recent Activity)'),
              const SizedBox(height: 10),
              const _BodyText(
                'Every Stock In/Out creates a history entry. You can browse History and use Filter to '
                'limit by transaction type, product, or date range (Today, Last 7 Days, Last 30 Days).',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Dashboard Alerts'),
              const SizedBox(height: 10),
              const _BodyText(
                'The Dashboard shows your total products, low stock count, and an out-of-stock summary. '
                'Low stock means the quantity is below the minimum stock level.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Backup (Export)'),
              const SizedBox(height: 10),
              const _BodyText(
                'In Settings → Export Data, you can create a backup file containing your products and history. '
                'On Android, the backup is saved in a format that is easy to open in common file managers, '
                'but it still contains standard JSON content.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Restore (Import)'),
              const SizedBox(height: 10),
              const _BodyText(
                'In Settings → Import Data, select a backup you previously exported. '
                'Import will overwrite your current products and history, then replace them with the backup.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Clear Data'),
              const SizedBox(height: 10),
              const _BodyText(
                'Clear All Data removes all products and history. Clear History removes only the history '
                'and keeps your products. Both actions cannot be undone.',
              ),

              const SizedBox(height: 18),
              const _SectionTitle('Tip'),
              const SizedBox(height: 10),
              const _BodyText(
                'If you are using this on multiple devices, export a backup regularly so you always have a recent copy.',
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.45,
        color: Color(0xFF475569),
      ),
    );
  }
}

