import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои товары'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран товаров продавца'),
      ),
    );
  }
}

class SellerOrdersScreen extends StatelessWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран заказов продавца'),
      ),
    );
  }
}

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль продавца'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Профиль продавца'),
      ),
    );
  }
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить товар'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран добавления товара'),
      ),
    );
  }
}
