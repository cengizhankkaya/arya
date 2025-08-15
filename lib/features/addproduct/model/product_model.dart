class ProductModel {
  final String barcode;
  final String name;
  final String brands;
  final String categories;
  final String quantity;
  final String ingredients;
  final String imageUrl;
  final String sodium;
  final String fiber;
  final String sugar;
  final String allergens;
  final String description;
  final String tags;

  ProductModel({
    required this.barcode,
    required this.name,
    required this.brands,
    required this.categories,
    required this.quantity,
    required this.ingredients,
    required this.imageUrl,
    required this.sodium,
    required this.fiber,
    required this.sugar,
    required this.allergens,
    required this.description,
    required this.tags,
  });

  Map<String, String> toMap({
    required String username,
    required String password,
  }) {
    return {
      'code': barcode,
      'product_name': name,
      'brands': brands,
      'categories': categories,
      'quantity': quantity,
      'ingredients_text': ingredients,
      'image_url': imageUrl,
      'nutriment_sodium': sodium,
      'nutriment_fiber': fiber,
      'nutriment_sugars': sugar,
      'allergens_tags': allergens,
      'generic_name': description,
      'labels_tags': tags,
      'user_id': username,
      'password': password,
      'action': 'process',
      'json': '1',
      'type': 'product',
    };
  }
}
