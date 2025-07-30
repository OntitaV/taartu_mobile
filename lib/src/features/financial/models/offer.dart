class Offer {
  final int? id;
  final String code;
  final String discountType; // 'percentage' or 'flat'
  final double value;
  final DateTime validFrom;
  final DateTime validTo;
  final int usageLimit;
  final int currentUsage;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Offer({
    this.id,
    required this.code,
    required this.discountType,
    required this.value,
    required this.validFrom,
    required this.validTo,
    required this.usageLimit,
    this.currentUsage = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      code: json['code'],
      discountType: json['discount_type'],
      value: json['value'].toDouble(),
      validFrom: DateTime.parse(json['valid_from']),
      validTo: DateTime.parse(json['valid_to']),
      usageLimit: json['usage_limit'],
      currentUsage: json['current_usage'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount_type': discountType,
      'value': value,
      'valid_from': validFrom.toIso8601String(),
      'valid_to': validTo.toIso8601String(),
      'usage_limit': usageLimit,
      'current_usage': currentUsage,
      'is_active': isActive,
    };
  }

  Offer copyWith({
    int? id,
    String? code,
    String? discountType,
    double? value,
    DateTime? validFrom,
    DateTime? validTo,
    int? usageLimit,
    int? currentUsage,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Offer(
      id: id ?? this.id,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      value: value ?? this.value,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      usageLimit: usageLimit ?? this.usageLimit,
      currentUsage: currentUsage ?? this.currentUsage,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(validFrom) && 
           now.isBefore(validTo) && 
           currentUsage < usageLimit;
  }

  String get discountDisplay {
    if (discountType == 'percentage') {
      return '${value.toInt()}% OFF';
    } else {
      return 'KSh ${value.toStringAsFixed(0)} OFF';
    }
  }
} 