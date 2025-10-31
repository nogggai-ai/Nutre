class Order {
  final String id;
  final String buyerId;
  final String sellerId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? deliveryAddress;
  final String? notes;
  final PaymentMethod paymentMethod;
  final DeliveryMethod deliveryMethod;

  Order({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.deliveryAddress,
    this.notes,
    required this.paymentMethod,
    required this.deliveryMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      buyerId: json['buyerId'],
      sellerId: json['sellerId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      deliveryAddress: json['deliveryAddress'],
      notes: json['notes'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['paymentMethod']}',
        orElse: () => PaymentMethod.cash,
      ),
      deliveryMethod: DeliveryMethod.values.firstWhere(
        (e) => e.toString() == 'DeliveryMethod.${json['deliveryMethod']}',
        orElse: () => DeliveryMethod.pickup,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'deliveryMethod': deliveryMethod.toString().split('.').last,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String unit;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash,
  card,
  online,
}

enum DeliveryMethod {
  pickup,
  delivery,
}
