import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';
import '../../utils/format_utils.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Заголовок
                Text(
                  'Добро пожаловать!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.paddingMedium),
                
                Text(
                  'Войдите в свой аккаунт',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(AppColors.textSecondaryColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.paddingXLarge),
                
                // Поле email
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Введите ваш email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Email обязателен'),
                    FormBuilderValidators.email(errorText: 'Неверный формат email'),
                  ]),
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Поле пароля
                FormBuilderTextField(
                  name: 'password',
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    hintText: 'Введите ваш пароль',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Пароль обязателен'),
                    FormBuilderValidators.minLength(
                      AppConstants.minPasswordLength,
                      errorText: 'Пароль должен содержать минимум ${AppConstants.minPasswordLength} символов',
                    ),
                  ]),
                  obscureText: _obscurePassword,
                ),
                
                const SizedBox(height: AppSizes.paddingMedium),
                
                // Забыли пароль
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _showForgotPasswordDialog();
                    },
                    child: const Text('Забыли пароль?'),
                  ),
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Кнопка входа
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppColors.primaryColor),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Войти',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Ошибка
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.error != null) {
                      return Container(
                        padding: const EdgeInsets.all(AppSizes.paddingMedium),
                        decoration: BoxDecoration(
                          color: Color(AppColors.errorColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                          border: Border.all(color: Color(AppColors.errorColor)),
                        ),
                        child: Text(
                          authProvider.error!,
                          style: TextStyle(color: Color(AppColors.errorColor)),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const Spacer(),
                
                // Ссылка на регистрацию
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Нет аккаунта? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        formData['email'],
        formData['password'],
      );
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Восстановление пароля'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Введите ваш email для восстановления пароля'),
            const SizedBox(height: AppSizes.paddingMedium),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return TextButton(
                onPressed: authProvider.isLoading ? null : () async {
                  if (FormatUtils.isValidEmail(emailController.text)) {
                    await authProvider.resetPassword(emailController.text);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Инструкции отправлены на ваш email'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Неверный формат email'),
                      ),
                    );
                  }
                },
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Отправить'),
              );
            },
          ),
        ],
      ),
    );
  }
}
