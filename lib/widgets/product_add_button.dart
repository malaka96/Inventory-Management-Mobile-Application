import 'package:flutter/material.dart';

class ProductAddButton extends StatelessWidget {
  const ProductAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color(0xFF5E7BF9),
      elevation: 2,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
