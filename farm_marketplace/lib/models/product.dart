class Product {
  final String id;
  final String sellerId;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final int stock;
  final String unit; // кг, шт, л и т.д.
  final bool isOrganic;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final double? rating;
  final int? reviewCount;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.stock,
    required this.unit,
    this.isOrganic = false,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.rating,
    this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      sellerId: json['sellerId'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'],
      unit: json['unit'],
      isOrganic: json['isOrganic'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      isActive: json['isActive'] ?? true,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'stock': stock,
      'unit': unit,
      'isOrganic': isOrganic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  Product copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    int? stock,
    String? unit,
    bool? isOrganic,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
      isOrganic: isOrganic ?? this.isOrganic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
