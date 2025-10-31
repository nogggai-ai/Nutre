import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../constants/app_constants.dart';
import '../../screens/common/product_grid.dart';
import '../../screens/common/category_grid.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeTab(),
          CartScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(AppColors.primaryColor),
        unselectedItemColor: Color(AppColors.textSecondaryColor),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    if (cartProvider.itemCount > 0) {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color(AppColors.errorColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            label: 'Корзина',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Заказы',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // TODO: Показать уведомления
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          Container(
            color: Color(AppColors.primaryColor),
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск продуктов...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Контент
          Expanded(
            child: _searchQuery.isNotEmpty
                ? ProductGrid(searchQuery: _searchQuery)
                : const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Категории
                        Padding(
                          padding: EdgeInsets.all(AppSizes.paddingLarge),
                          child: Text(
                            'Категории',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CategoryGrid(),
                        
                        SizedBox(height: AppSizes.paddingLarge),
                        
                        // Популярные товары
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
                          child: Text(
                            'Популярные товары',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingMedium),
                        ProductGrid(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
