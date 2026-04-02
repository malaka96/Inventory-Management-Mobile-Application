import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool isSelected;

  const CustomFilterChip({
    super.key,
    this.label = "Filter",
    this.onTap,
    this.icon = Icons.tune,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8ECFF) // selected background
              : const Color(0xFFF3F4F6), // normal background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C83F7)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? const Color(0xFF6C83F7)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF6C83F7)
                    : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}