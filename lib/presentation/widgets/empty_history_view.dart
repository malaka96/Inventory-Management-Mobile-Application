import 'package:flutter/material.dart';

class EmptyHistoryView extends StatelessWidget {
  const EmptyHistoryView({super.key});

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
            Icons.history,
            color: Color(0xFF7E8695),
            size: 30,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'No Transactions Yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your transaction history will appear here',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Color(0xFF6B7280), height: 1.5),
        ),

      ],
    );
  }
}
