import 'package:flutter/material.dart';

class EmptyProductView extends StatelessWidget {
  final VoidCallback onTap;
  const EmptyProductView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFEFF2FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: Color(0xFF7E8695),
            size: 30,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'No Products Yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Start by adding your first product to\ninventory',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Color(0xFF6B7280), height: 1.5),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E7BF9),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Add Product',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
