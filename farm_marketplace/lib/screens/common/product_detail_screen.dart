import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../constants/app_constants.dart';
import '../../utils/format_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Добавить в избранное
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Поделиться
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Галерея изображений
            _buildImageGallery(),
            
            // Основная информация
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название и цена
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        FormatUtils.formatPrice(widget.product.price),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  // Рейтинг и отзывы
                  if (widget.product.rating != null)
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < widget.product.rating!.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        Text(
                          '${FormatUtils.formatRating(widget.product.rating)} (${widget.product.reviewCount} отзывов)',
                          style: TextStyle(
                            color: Color(AppColors.textSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Описание
                  Text(
                    'Описание',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Характеристики
                  _buildCharacteristics(),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Информация о продавце
                  _buildSellerInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Нижняя панель с количеством и кнопкой добавления
      bottomNavigationBar: Container(
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
        child: Row(
          children: [
            // Выбор количества
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(AppColors.primaryColor)),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () {
                      setState(() {
                        _quantity--;
                      });
                    } : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: AppSizes.paddingMedium),
            
            // Кнопка добавления в корзину
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  final isInCart = cartProvider.isInCart(widget.product.id);
                  final cartQuantity = cartProvider.getProductQuantity(widget.product.id);
                  
                  return SizedBox(
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isInCart) {
                          cartProvider.updateQuantity(
                            widget.product.id,
                            cartQuantity + _quantity,
                          );
                        } else {
                          cartProvider.addToCart(widget.product, _quantity);
                        }
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isInCart
                                  ? 'Товар добавлен в корзину'
                                  : 'Товар добавлен в корзину',
                            ),
                            backgroundColor: Color(AppColors.successColor),
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
                      child: Text(
                        isInCart ? 'В корзине ($cartQuantity)' : 'В корзину',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    if (widget.product.images.isEmpty) {
      return Container(
        height: 300,
        color: Color(AppColors.backgroundColor),
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 100,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Основное изображение
        Container(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _selectedImageIndex = index;
              });
            },
            itemCount: widget.product.images.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.product.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Color(AppColors.backgroundColor),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Индикаторы изображений
        if (widget.product.images.length > 1)
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedImageIndex == index
                        ? Color(AppColors.primaryColor)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCharacteristics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Характеристики',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        
        _buildCharacteristicRow('Категория', widget.product.category),
        _buildCharacteristicRow('Единица измерения', widget.product.unit),
        _buildCharacteristicRow('В наличии', '${widget.product.stock} ${widget.product.unit}'),
        _buildCharacteristicRow('Органический', widget.product.isOrganic ? 'Да' : 'Нет'),
      ],
    );
  }

  Widget _buildCharacteristicRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(AppColors.textSecondaryColor),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Color(AppColors.backgroundColor),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Информация о продавце',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(AppColors.primaryColor),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: AppSizes.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Фермер Иван',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Продавец с 2020 года',
                      style: TextStyle(
                        color: Color(AppColors.textSecondaryColor),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Переход к профилю продавца
                },
                child: const Text('Профиль'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
