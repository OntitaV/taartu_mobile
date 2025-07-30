class TaxRate {
  final int? id;
  final String name;
  final double percentage;
  final bool isActive;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaxRate({
    this.id,
    required this.name,
    required this.percentage,
    this.isActive = true,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory TaxRate.fromJson(Map<String, dynamic> json) {
    return TaxRate(
      id: json['id'],
      name: json['name'],
      percentage: json['percentage'].toDouble(),
      isActive: json['is_active'] ?? true,
      description: json['description'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'percentage': percentage,
      'is_active': isActive,
      'description': description,
    };
  }

  TaxRate copyWith({
    int? id,
    String? name,
    double? percentage,
    bool? isActive,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaxRate(
      id: id ?? this.id,
      name: name ?? this.name,
      percentage: percentage ?? this.percentage,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayPercentage => '${percentage.toStringAsFixed(1)}%';
} 