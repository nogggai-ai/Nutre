class Category {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'isActive': isActive,
    };
  }
}

// Предопределенные категории для фермерского маркетплейса
class FarmCategories {
  static final List<Category> categories = [
    Category(
      id: 'vegetables',
      name: 'Овощи',
      description: 'Свежие овощи с фермы',
      icon: '🥕',
    ),
    Category(
      id: 'fruits',
      name: 'Фрукты',
      description: 'Сочные фрукты',
      icon: '🍎',
    ),
    Category(
      id: 'dairy',
      name: 'Молочные продукты',
      description: 'Молоко, сыр, творог',
      icon: '🥛',
    ),
    Category(
      id: 'meat',
      name: 'Мясо и птица',
      description: 'Свежее мясо',
      icon: '🥩',
    ),
    Category(
      id: 'eggs',
      name: 'Яйца',
      description: 'Домашние яйца',
      icon: '🥚',
    ),
    Category(
      id: 'honey',
      name: 'Мед и продукты пчеловодства',
      description: 'Натуральный мед',
      icon: '🍯',
    ),
    Category(
      id: 'grains',
      name: 'Зерновые',
      description: 'Крупы и мука',
      icon: '🌾',
    ),
    Category(
      id: 'herbs',
      name: 'Зелень и специи',
      description: 'Свежая зелень',
      icon: '🌿',
    ),
  ];
}
