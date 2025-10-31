import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      _token = response['token'];
      _user = User.fromJson(response['user']);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType type,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await AuthService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        type: type,
      );

      _token = response['token'];
      _user = User.fromJson(response['user']);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    if (_token != null) {
      await AuthService.logout(_token!);
    }
    
    _user = null;
    _token = null;
    _error = null;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    if (_user == null || _token == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      final updatedUser = await AuthService.updateProfile(
        token: _token!,
        userId: _user!.id,
        name: name,
        phone: phone,
        avatar: avatar,
      );

      _user = updatedUser;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      await AuthService.resetPassword(email);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }

  // Метод для восстановления сессии из локального хранилища
  void setUser(User user, String token) {
    _user = user;
    _token = token;
    notifyListeners();
  }
}
