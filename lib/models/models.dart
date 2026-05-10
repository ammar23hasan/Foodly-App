class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final double rating;
  final int reviews;
  final List<String> addons;
  final int calories;
  final String prepTime;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.rating = 0.0,
    this.reviews = 0,
    this.addons = const [],
    this.calories = 0,
    this.prepTime = '15 min',
  });
}

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String deliveryTime;
  final double deliveryFee;
  final List<String> tags;
  final List<Food> menu;
  final bool isOpen;
  final double minimumOrder;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviews = 0,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.tags,
    this.menu = const [],
    this.isOpen = true,
    this.minimumOrder = 5.0,
  });
}

class Category {
  final String id;
  final String name;
  final String iconPath;

  Category({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}
