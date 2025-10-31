class AppConstants {
  // API URLs
  static const String baseUrl = 'https://api.farmmarketplace.com';
  static const String apiVersion = '/v1';
  
  // Storage keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';
  
  // App settings
  static const String appName = 'Фермерский Маркетплейс';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image settings
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Currency
  static const String currencySymbol = '₽';
  static const String currencyCode = 'RUB';
}

class AppColors {
  static const int primaryColor = 0xFF2E7D32; // Зеленый
  static const int secondaryColor = 0xFF4CAF50; // Светло-зеленый
  static const int accentColor = 0xFFFF9800; // Оранжевый
  static const int errorColor = 0xFFD32F2F; // Красный
  static const int warningColor = 0xFFFFC107; // Желтый
  static const int successColor = 0xFF4CAF50; // Зеленый
  static const int backgroundColor = 0xFFF5F5F5; // Светло-серый
  static const int surfaceColor = 0xFFFFFFFF; // Белый
  static const int textPrimaryColor = 0xFF212121; // Темно-серый
  static const int textSecondaryColor = 0xFF757575; // Серый
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double cardHeight = 200.0;
}
