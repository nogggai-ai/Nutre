import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../constants/app_constants.dart';
import '../../utils/format_utils.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.items.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    cartProvider.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Корзина очищена'),
                      ),
                    );
                  },
                  child: const Text(
                    'Очистить',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const EmptyCartWidget();
          }

          return Column(
            children: [
              // Список товаров
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.paddingLarge),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return CartItemCard(item: item);
                  },
                ),
              ),
              
              // Итого и кнопка оформления
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Итого
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итого:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          FormatUtils.formatPrice(cartProvider.totalAmount),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSizes.paddingMedium),
                    
                    // Кнопка оформления заказа
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppColors.primaryColor),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                          ),
                        ),
                        child: const Text(
                          'Оформить заказ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Row(
          children: [
            // Изображение товара
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                color: Color(AppColors.backgroundColor),
              ),
              child: item.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      child: Image.network(
                        item.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
            ),
            
            const SizedBox(width: AppSizes.paddingMedium),
            
            // Информация о товаре
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    FormatUtils.formatPrice(item.price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.primaryColor),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Управление количеством
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(AppColors.primaryColor)),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context, listen: false)
                                    .updateQuantity(item.productId, item.quantity - 1);
                              },
                              icon: const Icon(Icons.remove, size: 16),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context, listen: false)
                                    .updateQuantity(item.productId, item.quantity + 1);
                              },
                              icon: const Icon(Icons.add, size: 16),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: AppSizes.paddingSmall),
                      
                      Text(
                        item.unit,
                        style: TextStyle(
                          color: Color(AppColors.textSecondaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Кнопка удаления
            IconButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeFromCart(item.productId);
              },
              icon: const Icon(Icons.delete_outline),
              color: Color(AppColors.errorColor),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Color(AppColors.textSecondaryColor),
          ),
          
          const SizedBox(height: AppSizes.paddingLarge),
          
          Text(
            'Корзина пуста',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Color(AppColors.textSecondaryColor),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingMedium),
          
          Text(
            'Добавьте товары в корзину,\nчтобы оформить заказ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(AppColors.textSecondaryColor),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingXLarge),
          
          ElevatedButton(
            onPressed: () {
              // Возврат на главную страницу
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(AppColors.primaryColor),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
              ),
            ),
            child: const Text('Перейти к покупкам'),
          ),
        ],
      ),
    );
  }
}
