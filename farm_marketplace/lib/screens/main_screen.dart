import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'buyer/buyer_home_screen.dart';
import 'seller/seller_home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authProvider.isAuthenticated) {
          return const WelcomeScreen();
        }

        // Показываем соответствующий экран в зависимости от типа пользователя
        if (authProvider.user!.type == UserType.buyer) {
          return const BuyerHomeScreen();
        } else {
          return const SellerHomeScreen();
        }
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            children: [
              const Spacer(),
              
              // Логотип и название
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusXLarge),
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingLarge),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.primaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.paddingMedium),
                  Text(
                    'Свежие продукты прямо с фермы',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color(AppColors.textSecondaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Кнопки действий
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
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
                        'Войти',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(AppColors.primaryColor),
                        side: BorderSide(color: Color(AppColors.primaryColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                        ),
                      ),
                      child: const Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
