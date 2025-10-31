import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order.dart';
import '../../constants/app_constants.dart';
import '../../utils/format_utils.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  DeliveryMethod _selectedDeliveryMethod = DeliveryMethod.pickup;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заказа'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text('Корзина пуста'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о заказе
                  _buildOrderSummary(cartProvider),
                  
                  const SizedBox(height: AppSizes.paddingXLarge),
                  
                  // Способ доставки
                  _buildDeliveryMethod(),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Адрес доставки (если выбран доставка)
                  if (_selectedDeliveryMethod == DeliveryMethod.delivery)
                    _buildDeliveryAddress(),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Способ оплаты
                  _buildPaymentMethod(),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Комментарий к заказу
                  _buildOrderNotes(),
                  
                  const SizedBox(height: AppSizes.paddingXLarge),
                  
                  // Кнопка оформления заказа
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _placeOrder(cartProvider, authProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppColors.primaryColor),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Состав заказа',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            // Список товаров
            ...cartProvider.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.productName} x${item.quantity}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    FormatUtils.formatPrice(item.price * item.quantity),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
            
            const Divider(),
            
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
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Способ получения',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppSizes.paddingMedium),
        
        RadioListTile<DeliveryMethod>(
          title: const Text('Самовывоз'),
          subtitle: const Text('Забрать на ферме'),
          value: DeliveryMethod.pickup,
          groupValue: _selectedDeliveryMethod,
          onChanged: (value) {
            setState(() {
              _selectedDeliveryMethod = value!;
            });
          },
          activeColor: Color(AppColors.primaryColor),
        ),
        
        RadioListTile<DeliveryMethod>(
          title: const Text('Доставка'),
          subtitle: const Text('Доставка по адресу'),
          value: DeliveryMethod.delivery,
          groupValue: _selectedDeliveryMethod,
          onChanged: (value) {
            setState(() {
              _selectedDeliveryMethod = value!;
            });
          },
          activeColor: Color(AppColors.primaryColor),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Адрес доставки',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppSizes.paddingMedium),
        
        FormBuilderTextField(
          name: 'deliveryAddress',
          decoration: const InputDecoration(
            labelText: 'Адрес',
            hintText: 'Введите адрес доставки',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
          validator: FormBuilderValidators.required(
            errorText: 'Адрес доставки обязателен',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Способ оплаты',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppSizes.paddingMedium),
        
        RadioListTile<PaymentMethod>(
          title: const Text('Наличными'),
          subtitle: const Text('При получении'),
          value: PaymentMethod.cash,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Color(AppColors.primaryColor),
        ),
        
        RadioListTile<PaymentMethod>(
          title: const Text('Картой'),
          subtitle: const Text('При получении'),
          value: PaymentMethod.card,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Color(AppColors.primaryColor),
        ),
        
        RadioListTile<PaymentMethod>(
          title: const Text('Онлайн'),
          subtitle: const Text('Оплата картой онлайн'),
          value: PaymentMethod.online,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Color(AppColors.primaryColor),
        ),
      ],
    );
  }

  Widget _buildOrderNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Комментарий к заказу',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppSizes.paddingMedium),
        
        FormBuilderTextField(
          name: 'notes',
          decoration: const InputDecoration(
            labelText: 'Комментарий',
            hintText: 'Дополнительные пожелания к заказу',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _placeOrder(CartProvider cartProvider, AuthProvider authProvider) async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // В реальном приложении здесь будет создание заказа через API
      await Future.delayed(const Duration(seconds: 2)); // Имитация запроса

      // Создаем заказ
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        buyerId: authProvider.user!.id,
        sellerId: 'seller1', // В реальном приложении это будет определяться по товарам
        items: cartProvider.getOrderItems(),
        totalAmount: cartProvider.totalAmount,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        paymentMethod: _selectedPaymentMethod,
        deliveryMethod: _selectedDeliveryMethod,
        deliveryAddress: _selectedDeliveryMethod == DeliveryMethod.delivery
            ? _formKey.currentState!.value['deliveryAddress']
            : null,
        notes: _formKey.currentState!.value['notes'],
      );

      // Очищаем корзину
      cartProvider.clearCart();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/order-success', arguments: order);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка оформления заказа: $e'),
            backgroundColor: Color(AppColors.errorColor),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
