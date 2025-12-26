import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final client = Supabase.instance.client;
  
  // Get menu items
  static Future<List<Map<String, dynamic>>> getMenu() async {
    try {
      final response = await client
          .from('menu')
          .select()
          .order('category')
          .order('name');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load menu: $e');
    }
  }
  
  // Create order
  static Future<Map<String, dynamic>> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    try {
      final response = await client
          .from('orders')
          .insert({
            'user_id': userId,
            'items': items,
            'total_amount': total,
            'delivery_address': {
              'address': '123 Main St',
              'city': 'City',
              'zip': '12345',
            },
            'status': 'pending',
          })
          .select()
          .single();
      
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
  
  // Get user orders
  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final response = await client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }
}
