class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image; // <--
  final String fullImageUrl;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.image,
      required this.fullImageUrl // <-- ✅ Also here
      });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: double.parse(json['price'].toString()),
        image: json['image'] ?? '',
        fullImageUrl:
            json['full_image_url'] // <-- ✅ Handle missing image gracefully
        );
  }
}
