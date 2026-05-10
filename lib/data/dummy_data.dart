import '../models/models.dart';

class DummyData {
  static final List<Category> categories = [
    Category(id: '1', name: 'Burger', iconPath: 'images/burgar.png'),
    Category(id: '2', name: 'Pizza', iconPath: 'images/pizza.png'),
    Category(id: '3', name: 'Snacks', iconPath: 'images/snacks.png'),
    Category(id: '4', name: 'Drinks', iconPath: 'images/drinks.png'),
    Category(id: '5', name: 'Pasta', iconPath: 'images/pasta.png'),
    Category(id: '6', name: 'Kebab', iconPath: 'images/kepap.png'),
  ];

  static final List<Food> allFoods = [
    // --- Burgers ---
    Food(
      id: 'f1',
      name: 'Double Cheese Burger',
      description: 'Juicy double beef patty with extra melting cheese and our secret sauce.',
      price: 12.99,
      imageUrl: 'images/Juicy beef burger with cheese.webp',
      categoryId: '1',
      rating: 4.8,
      reviews: 1240,
      addons: ['Extra Cheese', 'Bacon', 'Fries'],
      calories: 750,
      prepTime: '12 min',
    ),
    Food(
      id: 'f2',
      name: 'Crispy Chicken Burger',
      description: 'Crispy fried chicken fillet with fresh lettuce, tomato and mayo.',
      price: 10.49,
      imageUrl: 'images/Crispy fried chicken bucket.jpeg',
      categoryId: '1',
      rating: 4.6,
      reviews: 870,
      addons: ['Extra Sauce', 'Coleslaw', 'Pickles'],
      calories: 620,
      prepTime: '10 min',
    ),

    // --- Pizzas ---
    Food(
      id: 'f3',
      name: 'Pepperoni Pizza',
      description: 'Classic pizza with rich tomato sauce, mozzarella, and spicy pepperoni.',
      price: 15.99,
      imageUrl: 'images/Pepperoni pizza slice.jpg',
      categoryId: '2',
      rating: 4.7,
      reviews: 3200,
      addons: ['Extra Pepperoni', 'Mushrooms', 'Olives'],
      calories: 900,
      prepTime: '20 min',
    ),

    // --- Kebabs / Shawarma ---
    Food(
      id: 'f4',
      name: 'Syrian Shawarma',
      description: 'Authentic chicken shawarma with garlic sauce and pickles in toasted bread.',
      price: 8.50,
      imageUrl: 'images/Mexican street tacos.png',
      categoryId: '6',
      rating: 4.9,
      reviews: 5120,
      addons: ['Extra Garlic', 'Fries', 'Hot Sauce'],
      calories: 480,
      prepTime: '8 min',
    ),
    Food(
      id: 'f5',
      name: 'Mixed Grill Kebab',
      description: 'A generous platter of grilled beef and chicken kebabs with rice and salad.',
      price: 18.99,
      imageUrl: 'images/Beef steak medium rare.jpg',
      categoryId: '6',
      rating: 4.8,
      reviews: 412,
      addons: ['Extra Bread', 'Hummus', 'Tahini'],
      calories: 850,
      prepTime: '25 min',
    ),

    // --- Pasta ---
    Food(
      id: 'f6',
      name: 'Classic Spaghetti',
      description: 'Italian spaghetti with rich tomato basil sauce and Parmesan cheese.',
      price: 13.50,
      imageUrl: 'images/Italian pasta dish tomato sauce.jpg',
      categoryId: '5',
      rating: 4.5,
      reviews: 760,
      addons: ['Extra Parmesan', 'Garlic Bread', 'Meatballs'],
      calories: 650,
      prepTime: '18 min',
    ),

    // --- Snacks ---
    Food(
      id: 'f7',
      name: 'Loaded French Fries',
      description: 'Crispy golden fries loaded with cheese sauce, bacon bits and jalapeños.',
      price: 7.99,
      imageUrl: 'images/French fries basket.webp',
      categoryId: '3',
      rating: 4.6,
      reviews: 2100,
      addons: ['Extra Cheese', 'Ketchup', 'Ranch'],
      calories: 450,
      prepTime: '8 min',
    ),
    Food(
      id: 'f8',
      name: 'Hot Dog Special',
      description: 'Juicy beef hot dog in a toasted bun with mustard, ketchup, and onions.',
      price: 6.99,
      imageUrl: 'images/Hot dog with mustard and ketchup.avif',
      categoryId: '3',
      rating: 4.3,
      reviews: 930,
      addons: ['Extra Onions', 'Chili', 'Mustard'],
      calories: 380,
      prepTime: '5 min',
    ),

    // --- Drinks ---
    Food(
      id: 'f9',
      name: 'Fresh Orange Juice',
      description: 'Freshly squeezed orange juice, 100% natural with no added sugar.',
      price: 4.50,
      imageUrl: 'images/Fresh orange juice glass.avif',
      categoryId: '4',
      rating: 4.7,
      reviews: 1540,
      calories: 120,
      prepTime: '3 min',
    ),
    Food(
      id: 'f10',
      name: 'Iced Caramel Latte',
      description: 'Smooth espresso with caramel syrup poured over ice and creamy milk.',
      price: 5.99,
      imageUrl: 'images/Iced latte coffee.jpg',
      categoryId: '4',
      rating: 4.8,
      reviews: 2800,
      addons: ['Extra Shot', 'Oat Milk', 'Vanilla'],
      calories: 210,
      prepTime: '5 min',
    ),
    Food(
      id: 'f11',
      name: 'Mango Smoothie',
      description: 'Thick and creamy mango smoothie with a hint of ginger and lime.',
      price: 5.50,
      imageUrl: 'images/Fruit smoothie jar.jpg',
      categoryId: '4',
      rating: 4.6,
      reviews: 890,
      calories: 180,
      prepTime: '4 min',
    ),

    // --- Healthy ---
    Food(
      id: 'f12',
      name: 'Vegan Poke Bowl',
      description: 'Fresh poke bowl with brown rice, edamame, avocado and mango salsa.',
      price: 14.99,
      imageUrl: 'images/Vegan poke bowl.jpg',
      categoryId: '3',
      rating: 4.7,
      reviews: 1100,
      addons: ['Extra Avocado', 'Seaweed', 'Sesame'],
      calories: 420,
      prepTime: '10 min',
    ),
    Food(
      id: 'f13',
      name: 'Grilled Chicken Salad',
      description: 'Tender grilled chicken breast on a bed of fresh greens with vinaigrette.',
      price: 12.50,
      imageUrl: 'images/Fresh green salad bowl.avif',
      categoryId: '3',
      rating: 4.5,
      reviews: 670,
      addons: ['Croutons', 'Feta Cheese', 'Caesar Dressing'],
      calories: 380,
      prepTime: '12 min',
    ),

    // --- Desserts ---
    Food(
      id: 'f14',
      name: 'Chocolate Brownie',
      description: 'Warm fudgy brownie with a scoop of vanilla ice cream and chocolate drizzle.',
      price: 7.50,
      imageUrl: 'images/Chocolate brownie with vanilla ice cream.jpg',
      categoryId: '3',
      rating: 4.9,
      reviews: 2340,
      addons: ['Extra Ice Cream', 'Caramel Sauce', 'Nuts'],
      calories: 520,
      prepTime: '5 min',
    ),
    Food(
      id: 'f15',
      name: 'Strawberry Cheesecake',
      description: 'Classic New York cheesecake topped with fresh strawberry compote.',
      price: 8.99,
      imageUrl: 'images/Strawberry cheesecake slice.jpg',
      categoryId: '3',
      rating: 4.8,
      reviews: 1870,
      addons: ['Extra Strawberry', 'Whipped Cream'],
      calories: 480,
      prepTime: '0 min',
    ),

    // --- Sushi ---
    Food(
      id: 'f16',
      name: 'Sushi Platter (12 pcs)',
      description: 'An assortment of fresh salmon, tuna, and avocado maki rolls.',
      price: 22.99,
      imageUrl: 'images/Sushi roll platter.webp',
      categoryId: '3',
      rating: 4.9,
      reviews: 3400,
      addons: ['Extra Ginger', 'Wasabi', 'Soy Sauce'],
      calories: 580,
      prepTime: '15 min',
    ),

    // --- International ---
    Food(
      id: 'f17',
      name: 'Chicken Tikka Masala',
      description: 'Aromatic Indian curry with tender chicken in creamy tomato sauce and naan.',
      price: 16.99,
      imageUrl: 'images/Indian chicken tikka masala with naan.png',
      categoryId: '6',
      rating: 4.8,
      reviews: 2100,
      addons: ['Extra Naan', 'Raita', 'Basmati Rice'],
      calories: 720,
      prepTime: '22 min',
    ),
    Food(
      id: 'f18',
      name: 'Pancake Stack',
      description: 'Fluffy buttermilk pancakes stacked high with maple syrup and butter.',
      price: 9.99,
      imageUrl: 'images/Stack of pancakes with maple syrup.jpg',
      categoryId: '3',
      rating: 4.7,
      reviews: 1560,
      addons: ['Blueberries', 'Whipped Cream', 'Extra Syrup'],
      calories: 610,
      prepTime: '12 min',
    ),
    Food(
      id: 'f19',
      name: 'Avocado Toast',
      description: 'Sourdough toast topped with smashed avocado, poached egg and chili flakes.',
      price: 10.99,
      imageUrl: 'images/Avocado toast plate.jpg',
      categoryId: '3',
      rating: 4.6,
      reviews: 980,
      addons: ['Extra Egg', 'Feta Cheese', 'Smoked Salmon'],
      calories: 340,
      prepTime: '8 min',
    ),
    Food(
      id: 'f20',
      name: 'Ramen Noodle Bowl',
      description: 'Rich tonkotsu broth with soft ramen noodles, chashu pork and a soft egg.',
      price: 14.50,
      imageUrl: 'images/Ramen noodle soup bowl.jpg',
      categoryId: '5',
      rating: 4.9,
      reviews: 4200,
      addons: ['Extra Egg', 'Nori', 'Extra Chashu'],
      calories: 680,
      prepTime: '20 min',
    ),
  ];

  // Popular foods shortcut (top-rated)
  static List<Food> get popularFoods => allFoods
      .where((f) => f.rating >= 4.7)
      .toList()
    ..sort((a, b) => b.rating.compareTo(a.rating));

  static List<Food> getFoodsByCategory(String categoryId) =>
      allFoods.where((f) => f.categoryId == categoryId).toList();

  static Food? getFoodById(String id) {
    try {
      return allFoods.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Burger Palace',
      imageUrl: 'images/Juicy beef burger with cheese.webp',
      rating: 4.8,
      reviews: 2048,
      deliveryTime: '15–25 min',
      deliveryFee: 1.99,
      tags: ['Burger', 'Fast Food', 'American'],
      menu: allFoods.where((f) => f.categoryId == '1').toList(),
      isOpen: true,
      minimumOrder: 8.0,
    ),
    Restaurant(
      id: 'r2',
      name: 'Pizza Roma',
      imageUrl: 'images/Pepperoni pizza slice.jpg',
      rating: 4.6,
      reviews: 1540,
      deliveryTime: '25–35 min',
      deliveryFee: 2.49,
      tags: ['Pizza', 'Italian'],
      menu: allFoods.where((f) => f.categoryId == '2' || f.categoryId == '5').toList(),
      isOpen: true,
      minimumOrder: 12.0,
    ),
    Restaurant(
      id: 'r3',
      name: 'Shawarma House',
      imageUrl: 'images/Mexican street tacos.png',
      rating: 4.9,
      reviews: 3210,
      deliveryTime: '10–20 min',
      deliveryFee: 0.99,
      tags: ['Kebab', 'Middle Eastern', 'Shawarma'],
      menu: allFoods.where((f) => f.categoryId == '6').toList(),
      isOpen: true,
      minimumOrder: 6.0,
    ),
    Restaurant(
      id: 'r4',
      name: 'Sushi World',
      imageUrl: 'images/Sushi roll platter.webp',
      rating: 4.8,
      reviews: 1890,
      deliveryTime: '30–45 min',
      deliveryFee: 3.99,
      tags: ['Japanese', 'Sushi', 'Healthy'],
      menu: [allFoods.firstWhere((f) => f.id == 'f16')],
      isOpen: true,
      minimumOrder: 20.0,
    ),
    Restaurant(
      id: 'r5',
      name: 'The Healthy Bowl',
      imageUrl: 'images/Vegan poke bowl.jpg',
      rating: 4.7,
      reviews: 1100,
      deliveryTime: '15–25 min',
      deliveryFee: 1.49,
      tags: ['Healthy', 'Vegan', 'Salads'],
      menu: allFoods.where((f) => ['f12', 'f13', 'f19'].contains(f.id)).toList(),
      isOpen: true,
      minimumOrder: 10.0,
    ),
    Restaurant(
      id: 'r6',
      name: 'Sweet Treats',
      imageUrl: 'images/Assorted colorful macarons.jpg',
      rating: 4.7,
      reviews: 880,
      deliveryTime: '20–30 min',
      deliveryFee: 2.00,
      tags: ['Desserts', 'Bakery', 'Coffee'],
      menu: allFoods.where((f) => ['f14', 'f15', 'f18', 'f9', 'f10', 'f11'].contains(f.id)).toList(),
      isOpen: false,
      minimumOrder: 8.0,
    ),
    Restaurant(
      id: 'r7',
      name: 'Indian Spice',
      imageUrl: 'images/Indian chicken tikka masala with naan.png',
      rating: 4.8,
      reviews: 2100,
      deliveryTime: '30–45 min',
      deliveryFee: 2.99,
      tags: ['Indian', 'Curry', 'Spicy'],
      menu: [allFoods.firstWhere((f) => f.id == 'f17')],
      isOpen: true,
      minimumOrder: 15.0,
    ),
  ];

  static Restaurant? getRestaurantById(String id) {
    try {
      return restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
