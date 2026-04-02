import 'package:flutter/material.dart';

class ProductAddButton extends StatelessWidget {
  final VoidCallback ontap;
  const ProductAddButton({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: ontap,
      backgroundColor: const Color(0xFF5E7BF9),
      elevation: 2,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
