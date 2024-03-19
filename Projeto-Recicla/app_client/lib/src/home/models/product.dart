class Product {
  Product({
    required this.id,
    required this.title,
    this.isExpanded = false,
  });

  int id;
  String title;
  bool isExpanded;

  static List<Product> generateItems(int numberOfItems) {
    return List<Product>.generate(numberOfItems, (int index) {
      return Product(
        id: index + 1,
        title: 'Pergunta frequente ${index + 1}',
      );
    });
  }
}
