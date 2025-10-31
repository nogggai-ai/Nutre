import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../services/product_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void addToCart(Product product, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity: quantity,
        unit: product.unit,
        image: product.images.isNotEmpty ? product.images.first : null,
      ));
    }
    
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  int getProductQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        productId: '',
        productName: '',
        price: 0,
        quantity: 0,
        unit: '',
      ),
    );
    return item.quantity;
  }

  List<OrderItem> getOrderItems() {
    return _items.map((item) => OrderItem(
      productId: item.productId,
      productName: item.productName,
      price: item.price,
      quantity: item.quantity,
      unit: item.unit,
    )).toList();
  }
}

class CartItem {
  final String productId;
  final String productName;
  final double price;
  int quantity;
  final String unit;
  final String? image;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.unit,
    this.image,
  });
}
