import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  AuthProvider() {
    checkCurrentUser();
  }
  
  // Make this public instead of private
  Future<void> checkCurrentUser() async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      notifyListeners();
    }
  }
  
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      
      _user = Supabase.instance.client.auth.currentUser;
      _error = null;
      
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signUp(String email, String password, String fullName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await Supabase.instance.client.auth
          .signUp(email: email, password: password, data: {
            'full_name': fullName,
          });
      
      _user = Supabase.instance.client.auth.currentUser;
      _error = null;
      
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    _user = null;
    notifyListeners();
  }
}
