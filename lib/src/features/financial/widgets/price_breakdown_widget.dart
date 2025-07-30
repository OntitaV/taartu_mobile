import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/feature_flags.dart';
import '../models/offer.dart';
import '../models/tax_rate.dart';
import '../models/employee_rate.dart';
import '../utils/price_calculator.dart';

class PriceBreakdownWidget extends StatelessWidget {
  final double servicePrice;
  final Offer? appliedOffer;
  final TaxRate? appliedTax;
  final EmployeeRate? employeeRate;
  final double commissionRate;
  final bool showEmployeeCommission;
  final VoidCallback? onApplyOffer;

  const PriceBreakdownWidget({
    super.key,
    required this.servicePrice,
    this.appliedOffer,
    this.appliedTax,
    this.employeeRate,
    this.commissionRate = FeatureFlags.defaultCommissionRate,
    this.showEmployeeCommission = false,
    this.onApplyOffer,
  });

  @override
  Widget build(BuildContext context) {
    final breakdown = PriceCalculator.calculateBookingPrice(
      servicePrice: servicePrice,
      commissionRate: commissionRate,
      appliedTax: appliedTax,
      appliedOffer: appliedOffer,
      assignedEmployees: employeeRate != null ? [employeeRate!] : null,
    );

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
                            color: AppTheme.gray200.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: AppTheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                'Price Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),

          // Price Details
          _buildPriceRow(
            'Service Price',
            PriceCalculator.formatCurrency(breakdown.servicePrice),
            isTotal: false,
          ),

          // Applied Offer
          if (appliedOffer != null) ...[
            _buildPriceRow(
              'Discount (${appliedOffer!.code})',
              '-${PriceCalculator.formatCurrency(breakdown.discountAmount)}',
              isDiscount: true,
            ),
          ] else if (onApplyOffer != null) ...[
            _buildApplyOfferRow(),
          ],

          // Subtotal
          if (appliedOffer != null) ...[
            const Divider(height: AppTheme.spacing16),
            _buildPriceRow(
              'Subtotal',
              PriceCalculator.formatCurrency(breakdown.subtotal),
              isSubtotal: true,
            ),
          ],

          // Tax
          if (appliedTax != null) ...[
            _buildPriceRow(
              'Tax (${appliedTax!.displayPercentage})',
              PriceCalculator.formatCurrency(breakdown.taxAmount),
            ),
          ],

          // Taartu Commission
          _buildPriceRow(
            'Taartu Commission (${commissionRate.toStringAsFixed(1)}%)',
            PriceCalculator.formatCurrency(breakdown.taartuCommission),
          ),

          // Employee Commissions
          _buildEmployeeCommissions(breakdown),

          // Grand Total
          const Divider(height: AppTheme.spacing16),
          _buildPriceRow(
            'Total',
            PriceCalculator.formatCurrency(breakdown.grandTotal),
            isTotal: true,
          ),

          // Savings Info
          if (appliedOffer != null) ...[
            const SizedBox(height: AppTheme.spacing12),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                                  border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.savings,
                    color: AppTheme.success,
                    size: 16,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    'You saved ${PriceCalculator.formatCurrency(breakdown.discountAmount)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isSubtotal = false,
    bool isDiscount = false,
    bool isCommission = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal || isSubtotal ? FontWeight.w600 : FontWeight.normal,
                color: isTotal ? AppTheme.gray900 : AppTheme.gray700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal || isSubtotal ? FontWeight.bold : FontWeight.w500,
              color: _getValueColor(isTotal, isSubtotal, isDiscount, isCommission),
            ),
          ),
        ],
      ),
    );
  }

  Color _getValueColor(bool isTotal, bool isSubtotal, bool isDiscount, bool isCommission) {
    if (isTotal) return AppTheme.primary;
    if (isSubtotal) return AppTheme.gray900;
    if (isDiscount) return AppTheme.success;
    if (isCommission) return AppTheme.warning;
    return AppTheme.gray900;
  }

  Widget _buildApplyOfferRow() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radius8),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer,
            color: AppTheme.primary,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: Text(
              'Have a coupon code?',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onApplyOffer,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing4,
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, double amount, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color ?? AppTheme.gray600,
            ),
          ),
          Text(
            'KSh ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color ?? AppTheme.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCommissions(PriceBreakdown breakdown) {
    if (breakdown.employeeCommissions == null || breakdown.employeeCommissions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Team Commissions',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        ...breakdown.employeeCommissions!.map((commission) => 
          _buildBreakdownItem(
            commission.employeeName,
            commission.commission,
            color: AppTheme.secondary,
          ),
        ),
        const Divider(),
        _buildBreakdownItem(
          'Total Team Commission',
          breakdown.employeeCommission,
          color: AppTheme.secondary,
        ),
      ],
    );
  }
} 