class Food {
  final String imageUrl;
  final String name;
  final double price;
  int quantity;

  Food({
    required this.imageUrl,
    required this.name,
    this.quantity = 0,
    required this.price,
  });
}
