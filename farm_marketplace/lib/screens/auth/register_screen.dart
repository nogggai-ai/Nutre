import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../constants/app_constants.dart';
import '../../utils/format_utils.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserType _selectedUserType = UserType.buyer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Заголовок
                Text(
                  'Создать аккаунт',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.paddingMedium),
                
                Text(
                  'Выберите тип аккаунта и заполните данные',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(AppColors.textSecondaryColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSizes.paddingXLarge),
                
                // Выбор типа пользователя
                Text(
                  'Тип аккаунта',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingMedium),
                
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<UserType>(
                        title: const Text('Покупатель'),
                        subtitle: const Text('Покупка продуктов'),
                        value: UserType.buyer,
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value!;
                          });
                        },
                        activeColor: Color(AppColors.primaryColor),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<UserType>(
                        title: const Text('Продавец'),
                        subtitle: const Text('Продажа продуктов'),
                        value: UserType.seller,
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value!;
                          });
                        },
                        activeColor: Color(AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Поле имени
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    hintText: 'Введите ваше имя',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Имя обязательно'),
                    FormBuilderValidators.maxLength(
                      AppConstants.maxNameLength,
                      errorText: 'Имя не должно превышать ${AppConstants.maxNameLength} символов',
                    ),
                  ]),
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
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
                
                // Поле телефона
                FormBuilderTextField(
                  name: 'phone',
                  decoration: const InputDecoration(
                    labelText: 'Телефон',
                    hintText: '+7 (999) 123-45-67',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Телефон обязателен'),
                  ]),
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Поле пароля
                FormBuilderTextField(
                  name: 'password',
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    hintText: 'Введите пароль',
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
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Поле подтверждения пароля
                FormBuilderTextField(
                  name: 'confirmPassword',
                  decoration: InputDecoration(
                    labelText: 'Подтвердите пароль',
                    hintText: 'Повторите пароль',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Подтверждение пароля обязательно'),
                    (value) {
                      if (value != _formKey.currentState?.fields['password']?.value) {
                        return 'Пароли не совпадают';
                      }
                      return null;
                    },
                  ]),
                  obscureText: _obscureConfirmPassword,
                ),
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Кнопка регистрации
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _register,
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
                                'Зарегистрироваться',
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
                
                const SizedBox(height: AppSizes.paddingLarge),
                
                // Ссылка на вход
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Уже есть аккаунт? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Войти'),
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

  Future<void> _register() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        email: formData['email'],
        password: formData['password'],
        name: formData['name'],
        phone: formData['phone'],
        type: _selectedUserType,
      );
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }
}
