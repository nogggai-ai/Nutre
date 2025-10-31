import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../constants/app_constants.dart';

class AuthService {
  static const String _baseUrl = '${AppConstants.baseUrl}${AppConstants.apiVersion}';

  // Регистрация пользователя
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
          'type': type.toString().split('.').last,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка регистрации: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Вход в систему
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка входа: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Выход из системы
  static Future<void> logout(String token) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      // Игнорируем ошибки при выходе
    }
  }

  // Обновление профиля
  static Future<User> updateProfile({
    required String token,
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
        }),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Ошибка обновления профиля: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Получение информации о пользователе
  static Future<User> getUser(String token, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Ошибка получения пользователя: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Восстановление пароля
  static Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка восстановления пароля: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }
}
