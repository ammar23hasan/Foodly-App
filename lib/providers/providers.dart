import 'package:flutter/material.dart';
import '../models/models.dart';

class CartItem {
  final Food food;
  int quantity;
  final List<String> selectedAddons;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.selectedAddons = const [],
  });

  double get totalPrice {
    return food.price * quantity;
  }
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get subTotalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(Food food, int quantity, List<String> addons) {
    if (_items.containsKey(food.id)) {
      _items.update(
        food.id,
        (existingItem) => CartItem(
          food: existingItem.food,
          quantity: existingItem.quantity + quantity,
          selectedAddons: addons,
        ),
      );
    } else {
      _items.putIfAbsent(
        food.id,
        () => CartItem(
          food: food,
          quantity: quantity,
          selectedAddons: addons,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String foodId) {
    _items.remove(foodId);
    notifyListeners();
  }

  void updateQuantity(String foodId, int quantity) {
    if (_items.containsKey(foodId)) {
      if (quantity <= 0) {
        removeItem(foodId);
      } else {
        _items.update(
          foodId,
          (existingItem) => CartItem(
            food: existingItem.food,
            quantity: quantity,
            selectedAddons: existingItem.selectedAddons,
          ),
        );
        notifyListeners();
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class FavoritesProvider with ChangeNotifier {
  final List<String> _favoriteFoodIds = [];

  List<String> get favoriteFoodIds => [..._favoriteFoodIds];

  bool isFavorite(String foodId) {
    return _favoriteFoodIds.contains(foodId);
  }

  void toggleFavorite(String foodId) {
    if (_favoriteFoodIds.contains(foodId)) {
      _favoriteFoodIds.remove(foodId);
    } else {
      _favoriteFoodIds.add(foodId);
    }
    notifyListeners();
  }
}
