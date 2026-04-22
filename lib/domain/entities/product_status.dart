class ProductStatus {
  final String productName;
  final bool status; // true for in stock, false for out of stock
  final DateTime timestamp;
  final int value; // quantity added or removed

  ProductStatus({
    required this.productName,
    required this.status,
    required this.timestamp,
    required this.value,

  });
}