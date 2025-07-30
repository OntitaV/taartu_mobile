import 'package:flutter_test/flutter_test.dart';
import 'package:taartu_mobile/src/features/financial/utils/price_calculator.dart';
import 'package:taartu_mobile/src/features/financial/models/offer.dart';
import 'package:taartu_mobile/src/features/financial/models/tax_rate.dart';
import 'package:taartu_mobile/src/features/financial/models/employee_rate.dart';

void main() {
  group('PriceCalculator', () {
    test('should calculate basic price breakdown without offers or tax', () {
      const servicePrice = 1000.0;
      const commissionRate = 10.0;
      
      final breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: commissionRate,
      );
      
      expect(breakdown.servicePrice, equals(servicePrice));
      expect(breakdown.taxAmount, equals(0.0));
      expect(breakdown.taartuCommission, equals(100.0)); // 10% of 1000
      expect(breakdown.employeeCommission, equals(0.0));
      expect(breakdown.grandTotal, equals(1100.0)); // 1000 + 100 (commission)
      expect(breakdown.appliedOffer, isNull);
      expect(breakdown.appliedTax, isNull);
      expect(breakdown.employeeCommissions, isEmpty);
    });

    test('should calculate price breakdown with tax', () {
      const servicePrice = 1000.0;
      const commissionRate = 10.0;
      final taxRate = TaxRate(
        id: 1,
        name: 'VAT',
        percentage: 16.0,
        isActive: true,
      );
      
      final breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: commissionRate,
        appliedTax: taxRate,
      );
      
      expect(breakdown.servicePrice, equals(servicePrice));
      expect(breakdown.taxAmount, equals(160.0)); // 16% of 1000
      expect(breakdown.subtotal, equals(1160.0)); // 1000 + 160
      expect(breakdown.taartuCommission, equals(116.0)); // 10% of 1160
      expect(breakdown.grandTotal, equals(1276.0)); // 1160 + 116
    });

    test('should calculate price breakdown with offer', () {
      const servicePrice = 1000.0;
      const commissionRate = 10.0;
      final offer = Offer(
        id: 1,
        code: 'SUMMER20',
        discountType: 'percentage',
        value: 20.0,
        validFrom: DateTime.now().subtract(const Duration(days: 1)),
        validTo: DateTime.now().add(const Duration(days: 30)),
        usageLimit: 100,
      );
      
      final breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: commissionRate,
        appliedOffer: offer,
      );
      
      expect(breakdown.servicePrice, equals(servicePrice));
      expect(breakdown.discountAmount, equals(200.0)); // 20% of 1000
      expect(breakdown.subtotal, equals(800.0)); // 1000 - 200
      expect(breakdown.taartuCommission, equals(80.0)); // 10% of 800
      expect(breakdown.grandTotal, equals(880.0)); // 800 + 80
    });

    test('should calculate price breakdown with employee commission', () {
      const servicePrice = 1000.0;
      const commissionRate = 10.0;
      final employeeRate = EmployeeRate(
        employeeId: 1,
        employeeName: 'John Doe',
        type: 'commission',
        value: 15.0,
      );
      
      final breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: commissionRate,
        assignedEmployees: [employeeRate],
      );
      
      expect(breakdown.servicePrice, equals(servicePrice));
      expect(breakdown.taartuCommission, equals(100.0)); // 10% of 1000
      expect(breakdown.employeeCommission, equals(150.0)); // 15% of 1000
      expect(breakdown.employeeCommissions, hasLength(1));
      expect(breakdown.employeeCommissions!.first.employeeName, equals('John Doe'));
      expect(breakdown.employeeCommissions!.first.commission, equals(150.0));
      expect(breakdown.grandTotal, equals(1100.0)); // 1000 + 100 (Taartu commission)
    });

    test('should calculate price breakdown with employee flat rate', () {
      const servicePrice = 1000.0;
      const commissionRate = 10.0;
      final employeeRate = EmployeeRate(
        employeeId: 1,
        employeeName: 'Jane Smith',
        type: 'flat',
        value: 200.0,
      );
      
      final breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: commissionRate,
        assignedEmployees: [employeeRate],
      );
      
      expect(breakdown.servicePrice, equals(servicePrice));
      expect(breakdown.taartuCommission, equals(100.0)); // 10% of 1000
      expect(breakdown.employeeCommission, equals(200.0)); // Flat rate
      expect(breakdown.employeeCommissions, hasLength(1));
      expect(breakdown.employeeCommissions!.first.employeeName, equals('Jane Smith'));
      expect(breakdown.employeeCommissions!.first.commission, equals(200.0));
    });

    test('should calculate complex price breakdown with all components', () {
      const servicePrice = 1000.0;
      const commissionRate = 12.5;
      final taxRate = TaxRate(
        id: 1,
        name: 'VAT',
        percentage: 16.0,
        isActive: true,
      );
      final offer = Offer(
        id: 1,
        code: 'DISCOUNT10',
        discountType: 'percentage',
        value: 10.0,
        validFrom: DateTime.now().subtract(const Duration(days: 1)),
        validTo: DateTime.now().add(const Duration(days: 30)),
        usageLimit: 100,
      );
      final employeeRate = EmployeeRate(
        employeeId: 1,
        employeeName: 'Stylist A',
        type: 'commission',
        value: 20.0,
      );
      
      final breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: commissionRate,
        appliedTax: taxRate,
        appliedOffer: offer,
        assignedEmployees: [employeeRate],
      );
      
      expect(breakdown.servicePrice, equals(servicePrice));
      expect(breakdown.taxAmount, equals(160.0)); // 16% of 1000
      expect(breakdown.discountAmount, equals(116.0)); // 10% of 1160
      expect(breakdown.subtotal, equals(1044.0)); // 1160 - 116
      expect(breakdown.taartuCommission, equals(130.5)); // 12.5% of 1044
      expect(breakdown.employeeCommission, equals(208.8)); // 20% of 1044
      expect(breakdown.grandTotal, equals(1174.5)); // 1044 + 130.5
    });

    test('should clamp commission rate between 5% and 15%', () {
      const servicePrice = 1000.0;
      
      // Test below minimum
      var breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: 3.0,
      );
      expect(breakdown.taartuCommission, equals(50.0)); // Clamped to 5%
      
      // Test above maximum
      breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: 20.0,
      );
      expect(breakdown.taartuCommission, equals(150.0)); // Clamped to 15%
      
      // Test within range
      breakdown = PriceCalculator.calculateBookingPrice(
        servicePrice: servicePrice,
        commissionRate: 12.5,
      );
      expect(breakdown.taartuCommission, equals(125.0)); // 12.5% of 1000
    });
  });
} 