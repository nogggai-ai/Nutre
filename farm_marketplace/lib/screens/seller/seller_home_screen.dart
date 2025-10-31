import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';
import 'seller_screens.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
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
          SellerDashboard(),
          SellerProductsScreen(),
          SellerOrdersScreen(),
          SellerProfileScreen(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Панель',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Заказы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductScreen(),
                  ),
                );
              },
              backgroundColor: Color(AppColors.primaryColor),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель продавца'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingLarge),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(AppColors.primaryColor),
                          child: Text(
                            authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'П',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Добро пожаловать, ${authProvider.user?.name ?? 'Продавец'}!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Управляйте своими товарами и заказами',
                                style: TextStyle(
                                  color: Color(AppColors.textSecondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppSizes.paddingLarge),
            
            // Статистика
            Text(
              'Статистика',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Товары',
                    '12',
                    Icons.inventory,
                    Color(AppColors.primaryColor),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMedium),
                Expanded(
                  child: _buildStatCard(
                    'Заказы',
                    '8',
                    Icons.receipt_long,
                    Color(AppColors.secondaryColor),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Продажи',
                    '₽45,600',
                    Icons.attach_money,
                    Color(AppColors.successColor),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMedium),
                Expanded(
                  child: _buildStatCard(
                    'Рейтинг',
                    '4.8',
                    Icons.star,
                    Color(AppColors.warningColor),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.paddingXLarge),
            
            // Быстрые действия
            Text(
              'Быстрые действия',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: AppSizes.paddingMedium,
              mainAxisSpacing: AppSizes.paddingMedium,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  'Добавить товар',
                  Icons.add_box,
                  Color(AppColors.primaryColor),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  'Мои товары',
                  Icons.inventory,
                  Color(AppColors.secondaryColor),
                  () {
                    // Переключение на вкладку товаров
                  },
                ),
                _buildActionCard(
                  'Новые заказы',
                  Icons.receipt_long,
                  Color(AppColors.accentColor),
                  () {
                    // Переключение на вкладку заказов
                  },
                ),
                _buildActionCard(
                  'Аналитика',
                  Icons.analytics,
                  Color(AppColors.successColor),
                  () {
                    // TODO: Открыть аналитику
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Color(AppColors.textSecondaryColor),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: AppSizes.paddingSmall),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
