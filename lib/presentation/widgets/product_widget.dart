import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final String productName;
  final String category;
  final int initialStock;
  final int minStock;

  const ProductWidget({
    super.key,
    required this.productName,
    required this.category,
    required this.initialStock,
    required this.minStock,
  });

  @override
  Widget build(BuildContext context) {
    // Using a ValueNotifier to track the stock value
    ValueNotifier<int> stockNotifier = ValueNotifier<int>(initialStock);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Product Name and Stock Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(category),
                  ],
                ),
                ValueListenableBuilder<int>(
                  valueListenable: stockNotifier,
                  builder: (context, stock, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: stock > 0 ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        stock > 0 ? "In Stock" : "Out of Stock",
                        style: TextStyle(
                          color: stock > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Second Row: Category and Add/Remove Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 2), // Spacer
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_downward_sharp),
                      onPressed: () {
                        if (stockNotifier.value > minStock) {
                          stockNotifier.value--;
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_upward_sharp),
                      onPressed: () {
                        stockNotifier.value++;
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Stock Quantity and Minimum Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: stockNotifier,
                  builder: (context, stock, child) {
                    return Text(
                      'Quantity: $stock',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
                SizedBox(width: 20),
                Text('Min: $minStock'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
