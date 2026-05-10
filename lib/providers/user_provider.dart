import 'package:flutter/material.dart';

// ── Models ────────────────────────────────────────────────

class UserAddress {
  final String id;
  String label;
  String street;
  String city;
  String zipCode;
  bool isDefault;
  double? lat;   // map coordinates
  double? lng;

  UserAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.zipCode,
    this.isDefault = false,
    this.lat,
    this.lng,
  });
}

class PaymentCard {
  final String id;
  String cardHolder;
  String last4;
  String expiry;
  String type;   // Visa / Mastercard / Cash
  bool isDefault;

  PaymentCard({
    required this.id,
    required this.cardHolder,
    required this.last4,
    required this.expiry,
    required this.type,
    this.isDefault = false,
  });
}

class PastOrderItem {
  final String foodName;
  final int quantity;
  final double price;

  const PastOrderItem({
    required this.foodName,
    required this.quantity,
    required this.price,
  });
}

class PastOrder {
  final String id;
  final String restaurantName;
  final List<PastOrderItem> items;
  final double total;
  final DateTime date;
  final String status; // Delivered / Cancelled / Pending

  const PastOrder({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });
}

class NotificationSettings {
  bool orderUpdates;
  bool promotions;
  bool newRestaurants;
  bool newsletter;
  bool smsAlerts;

  NotificationSettings({
    this.orderUpdates = true,
    this.promotions = true,
    this.newRestaurants = false,
    this.newsletter = false,
    this.smsAlerts = true,
  });
}

// ── Provider ──────────────────────────────────────────────

class UserProvider with ChangeNotifier {
  // Profile
  String _name = 'Ammar Hasan';
  String _email = 'ammar@example.com';
  String _phone = '+966 50 123 4567';
  int _avatarColorIndex = 0; // index into avatarColors

  static const List<Color> avatarColors = [
    Color(0xFFF95B3D),
    Color(0xFF6C63FF),
    Color(0xFF00BFA5),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF2196F3),
  ];

  // Addresses
  final List<UserAddress> _addresses = [
    UserAddress(
      id: 'a1',
      label: 'Home',
      street: '123 King Fahd Road',
      city: 'Riyadh',
      zipCode: '11564',
      isDefault: true,
      lat: 24.6907,
      lng: 46.6839,
    ),
    UserAddress(
      id: 'a2',
      label: 'Work',
      street: '456 Olaya Street, Tower B',
      city: 'Riyadh',
      zipCode: '12213',
      isDefault: false,
      lat: 24.7010,
      lng: 46.6900,
    ),
  ];

  // Payment methods
  final List<PaymentCard> _cards = [
    PaymentCard(
      id: 'c1',
      cardHolder: 'Ammar Hasan',
      last4: '4242',
      expiry: '12/27',
      type: 'Visa',
      isDefault: true,
    ),
    PaymentCard(
      id: 'c2',
      cardHolder: 'Ammar Hasan',
      last4: '9876',
      expiry: '08/26',
      type: 'Mastercard',
      isDefault: false,
    ),
  ];

  // Order history
  final List<PastOrder> _orders = [
    PastOrder(
      id: 'YG-83921',
      restaurantName: 'Burger Palace',
      items: const [
        PastOrderItem(foodName: 'Double Cheese Burger', quantity: 2, price: 12.99),
        PastOrderItem(foodName: 'Loaded French Fries', quantity: 1, price: 7.99),
      ],
      total: 36.97,
      date: DateTime(2026, 5, 10),
      status: 'Delivered',
    ),
    PastOrder(
      id: 'YG-71203',
      restaurantName: 'Pizza Roma',
      items: const [
        PastOrderItem(foodName: 'Pepperoni Pizza', quantity: 1, price: 15.99),
      ],
      total: 19.98,
      date: DateTime(2026, 5, 7),
      status: 'Delivered',
    ),
    PastOrder(
      id: 'YG-64118',
      restaurantName: 'Sushi World',
      items: const [
        PastOrderItem(foodName: 'Sushi Platter (12 pcs)', quantity: 1, price: 22.99),
      ],
      total: 26.98,
      date: DateTime(2026, 5, 3),
      status: 'Delivered',
    ),
    PastOrder(
      id: 'YG-55490',
      restaurantName: 'Shawarma House',
      items: const [
        PastOrderItem(foodName: 'Syrian Shawarma', quantity: 3, price: 8.50),
      ],
      total: 27.49,
      date: DateTime(2026, 4, 28),
      status: 'Cancelled',
    ),
    PastOrder(
      id: 'YG-48231',
      restaurantName: 'The Healthy Bowl',
      items: const [
        PastOrderItem(foodName: 'Vegan Poke Bowl', quantity: 1, price: 14.99),
        PastOrderItem(foodName: 'Grilled Chicken Salad', quantity: 1, price: 12.50),
      ],
      total: 29.48,
      date: DateTime(2026, 4, 20),
      status: 'Delivered',
    ),
  ];

  // Notification settings
  NotificationSettings _notifSettings = NotificationSettings();

  // ── Getters ───────────────────────────────────────────
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  int get avatarColorIndex => _avatarColorIndex;
  Color get avatarColor => avatarColors[_avatarColorIndex];

  List<UserAddress> get addresses => List.unmodifiable(_addresses);
  UserAddress? get defaultAddress =>
      _addresses.where((a) => a.isDefault).firstOrNull;

  // ── Delivery address for current session ──────────────
  String? _deliveryAddressId;

  UserAddress? get deliveryAddress {
    if (_deliveryAddressId != null) {
      try {
        return _addresses.firstWhere((a) => a.id == _deliveryAddressId);
      } catch (_) {}
    }
    return defaultAddress;
  }

  void selectDeliveryAddress(String id) {
    _deliveryAddressId = id;
    notifyListeners();
  }

  List<PaymentCard> get cards => List.unmodifiable(_cards);
  PaymentCard? get defaultCard =>
      _cards.where((c) => c.isDefault).firstOrNull;

  List<PastOrder> get orders => List.unmodifiable(_orders);
  int get totalOrders => _orders.where((o) => o.status == 'Delivered').length;

  NotificationSettings get notifSettings => _notifSettings;

  // ── Profile Actions ───────────────────────────────────
  void updateProfile({String? name, String? email, String? phone}) {
    if (name != null && name.trim().isNotEmpty) _name = name.trim();
    if (email != null && email.trim().isNotEmpty) _email = email.trim();
    if (phone != null && phone.trim().isNotEmpty) _phone = phone.trim();
    notifyListeners();
  }

  void setAvatarColor(int index) {
    _avatarColorIndex = index;
    notifyListeners();
  }

  // ── Address Actions ────────────────────────────────────
  void addAddress(UserAddress address) {
    if (address.isDefault) {
      for (final a in _addresses) {
        a.isDefault = false;
      }
    }
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(String id) {
    final wasDefault = _addresses.any((a) => a.id == id && a.isDefault);
    _addresses.removeWhere((a) => a.id == id);
    if (wasDefault && _addresses.isNotEmpty) {
      _addresses.first.isDefault = true;
    }
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    for (final a in _addresses) {
      a.isDefault = a.id == id;
    }
    notifyListeners();
  }

  // ── Payment Actions ────────────────────────────────────
  void addCard(PaymentCard card) {
    if (card.isDefault) {
      for (final c in _cards) {
        c.isDefault = false;
      }
    }
    _cards.add(card);
    notifyListeners();
  }

  void removeCard(String id) {
    final wasDefault = _cards.any((c) => c.id == id && c.isDefault);
    _cards.removeWhere((c) => c.id == id);
    if (wasDefault && _cards.isNotEmpty) {
      _cards.first.isDefault = true;
    }
    notifyListeners();
  }

  void setDefaultCard(String id) {
    for (final c in _cards) {
      c.isDefault = c.id == id;
    }
    notifyListeners();
  }

  // ── Notification Actions ────────────────────────────────
  void updateNotification(String key, bool value) {
    switch (key) {
      case 'orderUpdates':
        _notifSettings.orderUpdates = value;
      case 'promotions':
        _notifSettings.promotions = value;
      case 'newRestaurants':
        _notifSettings.newRestaurants = value;
      case 'newsletter':
        _notifSettings.newsletter = value;
      case 'smsAlerts':
        _notifSettings.smsAlerts = value;
    }
    notifyListeners();
  }
}
