import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> booking;
  
  const PaymentScreen({
    super.key,
    required this.booking,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'mpesa';
  bool _isLoading = false;
  
  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  // Payment methods for Kenyan market
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'mpesa',
      'name': 'M-Pesa',
      'description': 'Pay with M-Pesa mobile money',
      'icon': Icons.phone_android,
      'color': const Color(0xFF00A651),
      'isPopular': true,
    },
    {
      'id': 'paystack',
      'name': 'Paystack',
      'description': 'Pay with card or bank transfer',
      'icon': Icons.credit_card,
      'color': const Color(0xFF0BA4DB),
      'isPopular': false,
    },
    {
      'id': 'airtel',
      'name': 'Airtel Money',
      'description': 'Pay with Airtel Money',
      'icon': Icons.phone_android,
      'color': const Color(0xFFE60000),
      'isPopular': false,
    },
    {
      'id': 'cash',
      'name': 'Cash Payment',
      'description': 'Pay at the service location',
      'icon': Icons.money,
      'color': const Color(0xFF10B981),
      'isPopular': false,
    },
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary
            _buildBookingSummary(),
            
            SizedBox(height: AppTheme.spacing24),
            
            // Payment Methods
            Text(
              'Choose Payment Method',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            SizedBox(height: AppTheme.spacing16),
            
            // Payment Methods List
            ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)),
            
            SizedBox(height: AppTheme.spacing24),
            
            // Payment Form
            if (_selectedPaymentMethod != 'cash') _buildPaymentForm(),
            
            SizedBox(height: AppTheme.spacing32),
            
            // Pay Button
            SizedBox(
              width: double.infinity,
              child: TaartuButton(
                text: _getPayButtonText(),
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _processPayment,
              ),
            ),
            
            SizedBox(height: AppTheme.spacing16),
            
            // Security Notice
            _buildSecurityNotice(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius8),
                ),
                child: Icon(
                  Icons.spa,
                  color: AppTheme.primary,
                  size: 30,
                ),
              ),
              SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking['providerName'] ?? 'Service Provider',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing4),
                    Text(
                      widget.booking['service'] ?? 'Service',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing4),
                    Text(
                      '${widget.booking['date'] ?? 'Date'} at ${widget.booking['time'] ?? 'Time'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing16),
          
          // Price breakdown
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.gray50,
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Cost',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                    Text(
                      widget.booking['price'] ?? 'KSh 0',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Fee',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                    Text(
                      'KSh 100',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                  ],
                ),
                Divider(height: AppTheme.spacing16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    Text(
                      _calculateTotal(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(
            color: isSelected ? method['color'] : AppTheme.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: 24,
              ),
            ),
            SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray900,
                        ),
                      ),
                      if (method['isPopular'])
                        Container(
                          margin: const EdgeInsets.only(left: AppTheme.spacing8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing6,
                            vertical: AppTheme.spacing2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(AppTheme.radius4),
                          ),
                          child: const Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacing4),
                  Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? method['color'] : AppTheme.gray400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getPaymentFormTitle(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          if (_selectedPaymentMethod == 'mpesa' || _selectedPaymentMethod == 'airtel')
            TaartuInput(
              label: 'Phone Number',
              hint: 'Enter your phone number',
              controller: _phoneController,
              type: TaartuInputType.phone,
              prefixIcon: const Icon(Icons.phone),
            ),
          
          if (_selectedPaymentMethod == 'paystack') ...[
            TaartuInput(
              label: 'Card Number',
              hint: '1234 5678 9012 3456',
              controller: _cardNumberController,
              type: TaartuInputType.text,
              prefixIcon: const Icon(Icons.credit_card),
            ),
            SizedBox(height: AppTheme.spacing16),
            Row(
              children: [
                Expanded(
                  child: TaartuInput(
                    label: 'Expiry Date',
                    hint: 'MM/YY',
                    controller: _expiryController,
                    type: TaartuInputType.text,
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: TaartuInput(
                    label: 'CVV',
                    hint: '123',
                    controller: _cvvController,
                    type: TaartuInputType.text,
                    prefixIcon: const Icon(Icons.security),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacing16),
            TaartuInput(
              label: 'Cardholder Name',
              hint: 'Enter cardholder name',
              controller: _nameController,
              type: TaartuInputType.text,
              prefixIcon: const Icon(Icons.person),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: AppTheme.primary,
            size: 24,
          ),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Payment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                SizedBox(height: AppTheme.spacing4),
                Text(
                  'Your payment information is encrypted and secure. We never store your card details.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTotal() {
    final basePrice = widget.booking['price'] ?? 'KSh 0';
    final priceValue = int.tryParse(basePrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final total = priceValue + 100; // Add booking fee
    return 'KSh ${total.toStringAsFixed(0)}';
  }

  String _getPayButtonText() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return 'Pay with M-Pesa';
      case 'paystack':
        return 'Pay with Card';
      case 'airtel':
        return 'Pay with Airtel Money';
      case 'cash':
        return 'Confirm Cash Payment';
      default:
        return 'Pay Now';
    }
  }

  String _getPaymentFormTitle() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return 'M-Pesa Payment';
      case 'paystack':
        return 'Card Payment';
      case 'airtel':
        return 'Airtel Money Payment';
      default:
        return 'Payment Details';
    }
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod != 'cash') {
      // Validate form
      if (_selectedPaymentMethod == 'mpesa' || _selectedPaymentMethod == 'airtel') {
        if (_phoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter your phone number'),
              backgroundColor: AppTheme.error,
            ),
          );
          return;
        }
      }
      
      if (_selectedPaymentMethod == 'paystack') {
        if (_cardNumberController.text.isEmpty || 
            _expiryController.text.isEmpty || 
            _cvvController.text.isEmpty ||
            _nameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all card details'),
              backgroundColor: AppTheme.error,
            ),
          );
          return;
        }
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));
      
      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      if (mounted) {
        _showPaymentSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppTheme.success,
              size: 24,
            ),
            SizedBox(width: AppTheme.spacing8),
            const Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your payment of ${_calculateTotal()} has been processed successfully.',
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'Booking Details:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            SizedBox(height: AppTheme.spacing8),
            Text('Service: ${widget.booking['service'] ?? 'Service'}'),
            Text('Date: ${widget.booking['date'] ?? 'Date'}'),
            Text('Time: ${widget.booking['time'] ?? 'Time'}'),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'You will receive a confirmation SMS shortly.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.gray600,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
} 