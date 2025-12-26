import 'package:flutter/material.dart';
import '../services/database_service.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  
  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
  });
  
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      imageUrl: json['image_url'],
    );
  }
}

class MenuProvider with ChangeNotifier {
  List<MenuItem> _menuItems = [];
  List<MenuItem> get menuItems => List.from(_menuItems);
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  Future<void> fetchMenu() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final data = await DatabaseService.getMenu();
      _menuItems = data.map((item) => MenuItem.fromJson(item)).toList();
      
    } catch (e) {
      _error = 'Failed to load menu';
      _menuItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  List<String> get categories {
    return _menuItems
        .map((item) => item.category)
        .toSet()
        .toList();
  }
  
  List<MenuItem> getByCategory(String category) {
    return _menuItems.where((item) => item.category == category).toList();
  }
}
