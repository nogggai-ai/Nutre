import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../constants/app_constants.dart';

class ProductService {
  static const String _baseUrl = '${AppConstants.baseUrl}${AppConstants.apiVersion}';

  // Получение списка товаров
  static Future<List<Product>> getProducts({
    String? category,
    String? search,
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? sortBy,
    bool? isOrganic,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (isOrganic != null) queryParams['isOrganic'] = isOrganic.toString();

      final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: queryParams);
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Ошибка получения товаров: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Получение товара по ID
  static Future<Product> getProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$productId'),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Ошибка получения товара: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Создание товара (для продавцов)
  static Future<Product> createProduct({
    required String token,
    required String sellerId,
    required String name,
    required String description,
    required double price,
    required String category,
    required List<String> images,
    required int stock,
    required String unit,
    bool isOrganic = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'sellerId': sellerId,
          'name': name,
          'description': description,
          'price': price,
          'category': category,
          'images': images,
          'stock': stock,
          'unit': unit,
          'isOrganic': isOrganic,
        }),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Ошибка создания товара: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Обновление товара (для продавцов)
  static Future<Product> updateProduct({
    required String token,
    required String productId,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    int? stock,
    String? unit,
    bool? isOrganic,
    bool? isActive,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (price != null) body['price'] = price;
      if (category != null) body['category'] = category;
      if (images != null) body['images'] = images;
      if (stock != null) body['stock'] = stock;
      if (unit != null) body['unit'] = unit;
      if (isOrganic != null) body['isOrganic'] = isOrganic;
      if (isActive != null) body['isActive'] = isActive;

      final response = await http.put(
        Uri.parse('$_baseUrl/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Ошибка обновления товара: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Удаление товара (для продавцов)
  static Future<void> deleteProduct({
    required String token,
    required String productId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Ошибка удаления товара: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Получение товаров продавца
  static Future<List<Product>> getSellerProducts({
    required String token,
    required String sellerId,
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$_baseUrl/sellers/$sellerId/products')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Ошибка получения товаров продавца: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }
}
