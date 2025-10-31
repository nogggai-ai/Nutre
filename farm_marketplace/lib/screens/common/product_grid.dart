import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../providers/cart_provider.dart';
import '../../constants/app_constants.dart';
import '../../utils/format_utils.dart';
import 'product_detail_screen.dart';

class ProductGrid extends StatelessWidget {
  final String? searchQuery;
  final String? category;
  final int? limit;

  const ProductGrid({
    super.key,
    this.searchQuery,
    this.category,
    this.limit,
  });

  @override
  Widget build(BuildContext context) {
    // В реальном приложении здесь будет загрузка данных из API
    final products = _getMockProducts();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppSizes.paddingMedium,
        mainAxisSpacing: AppSizes.paddingMedium,
      ),
      itemCount: limit != null ? (products.length > limit! ? limit! : products.length) : products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        sellerId: 'seller1',
        name: 'Свежие помидоры',
        description: 'Сочные красные помидоры с фермы',
        price: 150.0,
        category: 'vegetables',
        images: ['https://via.placeholder.com/300x200'],
        stock: 50,
        unit: 'кг',
        isOrganic: true,
        createdAt: DateTime.now(),
        rating: 4.5,
        reviewCount: 23,
      ),
      Product(
        id: '2',
        sellerId: 'seller1',
        name: 'Молоко коровье',
        description: 'Свежее молоко от коров',
        price: 80.0,
        category: 'dairy',
        images: ['https://via.placeholder.com/300x200'],
        stock: 30,
        unit: 'л',
        isOrganic: true,
        createdAt: DateTime.now(),
        rating: 4.8,
        reviewCount: 15,
      ),
      Product(
        id: '3',
        sellerId: 'seller2',
        name: 'Яблоки красные',
        description: 'Сладкие красные яблоки',
        price: 120.0,
        category: 'fruits',
        images: ['https://via.placeholder.com/300x200'],
        stock: 40,
        unit: 'кг',
        isOrganic: false,
        createdAt: DateTime.now(),
        rating: 4.2,
        reviewCount: 18,
      ),
      Product(
        id: '4',
        sellerId: 'seller2',
        name: 'Домашние яйца',
        description: 'Свежие яйца от кур',
        price: 200.0,
        category: 'eggs',
        images: ['https://via.placeholder.com/300x200'],
        stock: 25,
        unit: 'десяток',
        isOrganic: true,
        createdAt: DateTime.now(),
        rating: 4.9,
        reviewCount: 31,
      ),
    ];
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.borderRadiusMedium),
                  ),
                  color: Color(AppColors.backgroundColor),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.borderRadiusMedium),
                  ),
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
            
            // Информация о товаре
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Цена
                    Text(
                      FormatUtils.formatPrice(product.price),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(AppColors.primaryColor),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Рейтинг и кнопка добавления
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Рейтинг
                        if (product.rating != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                FormatUtils.formatRating(product.rating),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        
                        // Кнопка добавления в корзину
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                            final isInCart = cartProvider.isInCart(product.id);
                            return GestureDetector(
                              onTap: () {
                                if (isInCart) {
                                  cartProvider.removeFromCart(product.id);
                                } else {
                                  cartProvider.addToCart(product, 1);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isInCart
                                      ? Color(AppColors.primaryColor)
                                      : Color(AppColors.backgroundColor),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Color(AppColors.primaryColor),
                                  ),
                                ),
                                child: Icon(
                                  isInCart ? Icons.check : Icons.add,
                                  size: 16,
                                  color: isInCart
                                      ? Colors.white
                                      : Color(AppColors.primaryColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
