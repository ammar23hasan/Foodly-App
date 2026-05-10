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

  static final List<Food> popularFoods = [
    Food(
      id: 'f1',
      name: 'Double Cheese Burger',
      description: 'Juicy double beef patty with extra melting cheese and our secret sauce.',
      price: 12.99,
      imageUrl: 'images/Juicy beef burger with cheese.webp',
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
      imageUrl: 'images/Pepperoni pizza slice.jpg',
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
      imageUrl: 'images/Crispy fried chicken bucket.jpeg',
      categoryId: '6',
      rating: 4.9,
      reviews: 512,
    ),
  ];

  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Burger King',
      imageUrl: 'images/Chef cooking in commercial kitchen.jpg',
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
      imageUrl: 'images/Top view full table of food.jpg',
      rating: 4.2,
      reviews: 840,
      deliveryTime: '30-40 min',
      deliveryFee: 3.00,
      tags: ['Pizza', 'Italian'],
      menu: [popularFoods[1]],
    ),
  ];
}
