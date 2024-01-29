class Product {
  final String name;
  final int id;
  final double cost;
  final bool availability;
  final String details;
  final String category;
  int quantity;

  Product({
    required this.name,
    required this.id,
    required this.cost,
    required this.availability,
    required this.details,
    required this.category,
    this.quantity = 0,
  });
}