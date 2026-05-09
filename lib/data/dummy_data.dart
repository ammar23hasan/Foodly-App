import '../models/models.dart';

class DummyData {
  static final List<Category> categories = [
    Category(id: '1', name: 'Burger', iconPath: 'images/14.jpg'),
    Category(id: '2', name: 'Pizza', iconPath: 'images/423.jpg'),
    Category(id: '3', name: 'Snacks', iconPath: 'images/32.jpg'),
    Category(id: '4', name: 'Drinks', iconPath: 'images/435.jpg'),
    Category(id: '5', name: 'Pasta', iconPath: 'images/12.jpg'),
    Category(id: '6', name: 'Kebab', iconPath: 'images/13.jpg'),
  ];

  static final List<Food> popularFoods = [
    Food(
      id: 'f1',
      name: 'Double Cheese Burger',
      description: 'Juicy double beef patty with extra melting cheese and our secret sauce.',
      price: 12.99,
      imageUrl: 'images/14.jpg',
      categoryId: '1',
      rating: 4.8,
      reviews: 124,
      addons: ['Extra Cheese', 'Bacon', 'Fries'],
    ),
    Food(
      id: 'f2',
      name: 'Pepperoni Pizza',
      description: 'Classic pizza with rich tomato sauce, mozzarella, and spicy pepperoni.',
      price: 15.99,
      imageUrl: 'images/423.jpg',
      categoryId: '2',
      rating: 4.7,
      reviews: 320,
      addons: ['Extra Pepperoni', 'Mushrooms', 'Olives'],
    ),
    Food(
      id: 'f3',
      name: 'Syrian Shawarma',
      description: 'Authentic chicken shawarma with garlic sauce and pickles in toasted bread.',
      price: 8.50,
      imageUrl: 'images/15.jpg',
      categoryId: '6',
      rating: 4.9,
      reviews: 512,
    ),
  ];

  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Burger King',
      imageUrl: 'images/kerfin7_nea_3142.jpg',
      rating: 4.5,
      reviews: 1024,
      deliveryTime: '15-25 min',
      deliveryFee: 2.50,
      tags: ['Burger', 'Fast Food', 'American'],
      menu: popularFoods,
    ),
    Restaurant(
      id: 'r2',
      name: 'Pizza Hut',
      imageUrl: 'images/32.jpg',
      rating: 4.2,
      reviews: 840,
      deliveryTime: '30-40 min',
      deliveryFee: 3.00,
      tags: ['Pizza', 'Italian'],
      menu: [popularFoods[1]],
    ),
  ];
}
