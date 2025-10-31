import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class FormatUtils {
  // Форматирование цены
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,##0.00', 'ru_RU');
    return '${formatter.format(price)} ${AppConstants.currencySymbol}';
  }

  // Форматирование даты
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd.MM.yyyy', 'ru_RU');
    return formatter.format(date);
  }

  // Форматирование даты и времени
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy HH:mm', 'ru_RU');
    return formatter.format(dateTime);
  }

  // Форматирование времени
  static String formatTime(DateTime time) {
    final formatter = DateFormat('HH:mm', 'ru_RU');
    return formatter.format(time);
  }

  // Форматирование количества
  static String formatQuantity(int quantity, String unit) {
    return '$quantity $unit';
  }

  // Форматирование рейтинга
  static String formatRating(double? rating) {
    if (rating == null) return 'Нет оценок';
    return rating.toStringAsFixed(1);
  }

  // Форматирование номера телефона
  static String formatPhone(String phone) {
    if (phone.length == 11 && phone.startsWith('7')) {
      return '+7 (${phone.substring(1, 4)}) ${phone.substring(4, 7)}-${phone.substring(7, 9)}-${phone.substring(9)}';
    }
    return phone;
  }

  // Форматирование размера файла
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Обрезка текста
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Валидация email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Валидация телефона
  static bool isValidPhone(String phone) {
    return RegExp(r'^(\+7|7|8)?[\s\-]?\(?[489][0-9]{2}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$').hasMatch(phone);
  }
}
