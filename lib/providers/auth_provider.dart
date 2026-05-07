import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;
  String? _phoneNumber;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get phoneNumber => _phoneNumber;

  // Demo users storage (in real app, this would be a backend)
  final Map<String, Map<String, String>> _users = {};

  Future<bool> signIn(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Demo authentication
    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = _users[email]!['name'];
      _phoneNumber = _users[email]!['phone'];
      notifyListeners();
      return true;
    }
    
    // Demo: auto-create first user for testing
    if (email == 'demo@gasly.com' && password == 'password123') {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = 'Demo User';
      _phoneNumber = '0712345678';
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> signUp(String name, String email, String phone, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_users.containsKey(email)) {
      return false; // User already exists
    }
    
    _users[email] = {
      'name': name,
      'phone': phone,
      'password': password,
    };
    
    _isAuthenticated = true;
    _userEmail = email;
    _userName = name;
    _phoneNumber = phone;
    notifyListeners();
    return true;
  }

  void signOut() {
    _isAuthenticated = false;
    _userEmail = null;
    _userName = null;
    _phoneNumber = null;
    notifyListeners();
  }

  void updateProfile({String? name, String? phone}) {
    if (name != null) _userName = name;
    if (phone != null) _phoneNumber = phone;
    notifyListeners();
  }
}
