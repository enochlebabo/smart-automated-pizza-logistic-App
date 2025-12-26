import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  int quantity;
  
  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image_url': imageUrl,
    'quantity': quantity,
  };
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  
  Map<String, CartItem> get items => Map.from(_items);
  
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.values
      .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  
  double get deliveryFee => subtotal > 0 ? 2.99 : 0.0;
  
  double get tax => subtotal * 0.13;
  
  double get total => subtotal + deliveryFee + tax;
  
  List<Map<String, dynamic>> get cartItemsJson => _items.values
      .map((item) => item.toJson())
      .toList();
  
  void addItem(String id, String name, double price) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
    } else {
      _items[id] = CartItem(
        id: id,
        name: name,
        description: '', // Add empty description for now
        price: price,
      );
    }
    notifyListeners();
  }
  
  void removeItem(String id) {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity > 1) {
        _items[id]!.quantity--;
      } else {
        _items.remove(id);
      }
      notifyListeners();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
