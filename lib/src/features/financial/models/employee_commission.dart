class EmployeeCommission {
  final int employeeId;
  final String employeeName;
  final double commission;

  const EmployeeCommission({
    required this.employeeId,
    required this.employeeName,
    required this.commission,
  });

  factory EmployeeCommission.fromJson(Map<String, dynamic> json) {
    return EmployeeCommission(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      commission: json['commission'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'commission': commission,
    };
  }

  @override
  String toString() {
    return 'EmployeeCommission(employeeId: $employeeId, employeeName: $employeeName, commission: $commission)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmployeeCommission &&
        other.employeeId == employeeId &&
        other.employeeName == employeeName &&
        other.commission == commission;
  }

  @override
  int get hashCode {
    return employeeId.hashCode ^ employeeName.hashCode ^ commission.hashCode;
  }
} 