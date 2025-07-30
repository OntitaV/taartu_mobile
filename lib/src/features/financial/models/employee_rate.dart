class EmployeeRate {
  final int? id;
  final int employeeId;
  final String employeeName;
  final String type; // 'commission' or 'flat'
  final double value;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EmployeeRate({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.value,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory EmployeeRate.fromJson(Map<String, dynamic> json) {
    return EmployeeRate(
      id: json['id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      type: json['type'],
      value: json['value'].toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'type': type,
      'value': value,
      'is_active': isActive,
    };
  }

  EmployeeRate copyWith({
    int? id,
    int? employeeId,
    String? employeeName,
    String? type,
    double? value,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeRate(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      type: type ?? this.type,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayValue {
    if (type == 'commission') {
      return '${value.toStringAsFixed(1)}%';
    } else {
      return 'KSh ${value.toStringAsFixed(0)}';
    }
  }

  String get typeDisplay {
    return type == 'commission' ? 'Commission' : 'Flat Rate';
  }
} 