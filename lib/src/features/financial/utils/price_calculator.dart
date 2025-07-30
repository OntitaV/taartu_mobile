import '../models/offer.dart';
import '../models/tax_rate.dart';
import '../models/employee_rate.dart';
import '../models/employee_commission.dart';
import '../../../core/config/feature_flags.dart';

class PriceBreakdown {
  final double servicePrice;
  final double discountAmount;
  final double subtotal;
  final double taxAmount;
  final double taartuCommission;
  final double employeeCommission;
  final double grandTotal;
  final Offer? appliedOffer;
  final TaxRate? appliedTax;
  final EmployeeRate? employeeRate;
  final List<EmployeeCommission>? employeeCommissions;

  PriceBreakdown({
    required this.servicePrice,
    required this.discountAmount,
    required this.subtotal,
    required this.taxAmount,
    required this.taartuCommission,
    required this.employeeCommission,
    required this.grandTotal,
    this.appliedOffer,
    this.appliedTax,
    this.employeeRate,
    this.employeeCommissions,
  });
}

class PriceCalculator {
  static PriceBreakdown calculateBookingPrice({
    required double servicePrice,
    required double commissionRate,
    TaxRate? appliedTax,
    Offer? appliedOffer,
    List<EmployeeRate>? assignedEmployees,
  }) {
    // Validate commission rate is within allowed range
    commissionRate = commissionRate.clamp(
      FeatureFlags.minCommissionRate, 
      FeatureFlags.maxCommissionRate
    );

    // Calculate subtotal (service price + tax)
    double subtotal = servicePrice;
    double taxAmount = 0.0;
    
    if (appliedTax != null) {
      taxAmount = subtotal * (appliedTax.percentage / 100);
      subtotal += taxAmount;
    }

    // Apply offer discount if available
    double discountAmount = 0.0;
    if (appliedOffer != null && appliedOffer.isActive) {
      if (appliedOffer.discountType == 'percentage') {
        discountAmount = subtotal * (appliedOffer.value / 100);
      } else {
        discountAmount = appliedOffer.value;
      }
      subtotal -= discountAmount;
    }

    // Calculate Taartu commission
    double taartuCommission = subtotal * (commissionRate / 100);

    // Calculate employee commissions
    double totalEmployeeCommission = 0.0;
    List<EmployeeCommission> employeeCommissions = [];

    if (assignedEmployees != null && assignedEmployees.isNotEmpty) {
      for (final employee in assignedEmployees) {
        double employeeCommission = 0.0;
        
        if (employee.type == 'commission') {
          employeeCommission = subtotal * (employee.value / 100);
        } else {
          employeeCommission = employee.value; // Flat rate
        }
        
        totalEmployeeCommission += employeeCommission;
        employeeCommissions.add(EmployeeCommission(
          employeeId: employee.employeeId,
          employeeName: employee.employeeName,
          commission: employeeCommission,
        ));
      }
    }

    // Calculate grand total
    double grandTotal = subtotal + taartuCommission;

    return PriceBreakdown(
      servicePrice: servicePrice,
      taxAmount: taxAmount,
      discountAmount: discountAmount,
      subtotal: subtotal,
      taartuCommission: taartuCommission,
      employeeCommission: totalEmployeeCommission,
      grandTotal: grandTotal,
      appliedOffer: appliedOffer,
      appliedTax: appliedTax,
      employeeCommissions: employeeCommissions,
    );
  }

  static String formatCurrency(double amount) {
    return 'KSh ${amount.toStringAsFixed(0)}';
  }

  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
} 