import 'package:flutter/material.dart';
import '../services/database_service.dart';

class OrderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> get orders => List.from(_orders);
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Future<void> fetchUserOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _orders = await DatabaseService.getUserOrders(userId);
    } catch (e) {
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<Map<String, dynamic>> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final order = await DatabaseService.createOrder(
        userId: userId,
        items: items,
        total: total,
      );
      
      _orders.insert(0, order);
      notifyListeners();
      return order;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
