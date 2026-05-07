class Product {
  final String name;
  final double price;
  final String image;
  final String brand;
  final String weight;

  Product({
    required this.name,
    required this.price,
    required this.image,
    this.brand = '',
    this.weight = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
