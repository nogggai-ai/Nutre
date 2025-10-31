import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Экран заказов покупателя'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              children: [
                // Аватар и основная информация
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingLarge),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(AppColors.primaryColor),
                          child: Text(
                            authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'П',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingMedium),
                        Text(
                          authProvider.user?.name ?? 'Пользователь',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingSmall),
                        Text(
                          authProvider.user?.email ?? '',
                          style: TextStyle(
                            color: Color(AppColors.textSecondaryColor),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingSmall),
                        Text(
                          authProvider.user?.phone ?? '',
                          style: TextStyle(
                            color: Color(AppColors.textSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Меню профиля
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Редактировать профиль'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Редактирование профиля
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.favorite),
                        title: const Text('Избранное'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Избранное
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Настройки'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Настройки
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Помощь'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Помощь
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
