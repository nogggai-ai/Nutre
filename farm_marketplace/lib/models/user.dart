class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserType type;
  final String? avatar;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.type,
    this.avatar,
    required this.createdAt,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      type: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['type']}',
        orElse: () => UserType.buyer,
      ),
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'type': type.toString().split('.').last,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserType? type,
    String? avatar,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum UserType {
  buyer,
  seller,
}
