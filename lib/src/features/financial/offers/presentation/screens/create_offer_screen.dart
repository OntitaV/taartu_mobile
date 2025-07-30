import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';
import 'package:taartu_mobile/src/features/financial/providers/financial_providers.dart';
import 'package:taartu_mobile/src/features/financial/models/offer.dart';

class CreateOfferScreen extends ConsumerStatefulWidget {
  final Offer? offer;

  const CreateOfferScreen({super.key, this.offer});

  @override
  ConsumerState<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends ConsumerState<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _usageLimitController = TextEditingController();
  
  String _discountType = 'percentage';
  DateTime _validFrom = DateTime.now();
  DateTime _validTo = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _codeController.text = widget.offer!.code;
      _valueController.text = widget.offer!.value.toString();
      _usageLimitController.text = widget.offer!.usageLimit.toString();
      _discountType = widget.offer!.discountType;
      _validFrom = widget.offer!.validFrom;
      _validTo = widget.offer!.validTo;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _valueController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.offer != null ? 'Edit Offer' : 'Create Offer'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          children: [
            // Offer Code
            TaartuInput(
              controller: _codeController,
              label: 'Offer Code',
              hint: 'e.g., WELCOME20',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an offer code';
                }
                if (value.length < 3) {
                  return 'Offer code must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing16),

            // Discount Type
            Text(
              'Discount Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Row(
              children: [
                Expanded(
                  child: _buildDiscountTypeCard(
                    'Percentage',
                    'percentage',
                    Icons.percent,
                    'Discount by percentage',
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: _buildDiscountTypeCard(
                    'Flat Amount',
                    'flat',
                    Icons.attach_money,
                    'Fixed amount discount',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),

            // Discount Value
            TaartuInput(
              controller: _valueController,
              label: _discountType == 'percentage' ? 'Discount Percentage' : 'Discount Amount (KSh)',
              hint: _discountType == 'percentage' ? 'e.g., 20' : 'e.g., 500',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final numValue = double.tryParse(value);
                if (numValue == null || numValue <= 0) {
                  return 'Please enter a valid positive number';
                }
                if (_discountType == 'percentage' && numValue > 100) {
                  return 'Percentage cannot exceed 100%';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing16),

            // Usage Limit
            TaartuInput(
              controller: _usageLimitController,
              label: 'Usage Limit',
              hint: 'e.g., 100',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter usage limit';
                }
                final numValue = int.tryParse(value);
                if (numValue == null || numValue <= 0) {
                  return 'Please enter a valid positive number';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing16),

            // Valid From Date
            _buildDateField(
              'Valid From',
              _validFrom,
              (date) => setState(() => _validFrom = date),
            ),
            const SizedBox(height: AppTheme.spacing16),

            // Valid To Date
            _buildDateField(
              'Valid To',
              _validTo,
              (date) => setState(() => _validTo = date),
            ),
            const SizedBox(height: AppTheme.spacing24),

            // Preview Card
            _buildPreviewCard(),
            const SizedBox(height: AppTheme.spacing24),

            // Submit Button
            TaartuButton(
              onPressed: _isLoading ? null : _submitForm,
              text: _isLoading ? 'Saving...' : (widget.offer != null ? 'Update Offer' : 'Create Offer'),
              variant: TaartuButtonVariant.primary,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountTypeCard(String title, String type, IconData icon, String subtitle) {
    final isSelected = _discountType == type;
    return GestureDetector(
      onTap: () => setState(() => _discountType = type),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.gray50,
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.gray200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radius12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.gray600,
              size: 24,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.gray900,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.primary.withValues(alpha: 0.8) : AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        GestureDetector(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              onChanged(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.gray50,
              border: Border.all(color: AppTheme.gray200),
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.gray600, size: 20),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray900,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: AppTheme.gray600),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard() {
    final value = double.tryParse(_valueController.text) ?? 0;
    final offer = Offer(
      code: _codeController.text,
      discountType: _discountType,
      value: value,
      validFrom: _validFrom,
      validTo: _validTo,
      usageLimit: int.tryParse(_usageLimitController.text) ?? 0,
    );

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.05),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.code.isNotEmpty ? offer.code : 'OFFER_CODE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      offer.discountDisplay,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(AppTheme.radius8),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'Valid: ${_formatDate(_validFrom)} - ${_formatDate(_validTo)}',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_validTo.isBefore(_validFrom)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Valid To date must be after Valid From date'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final offer = Offer(
        id: widget.offer?.id,
        code: _codeController.text.toUpperCase(),
        discountType: _discountType,
        value: double.parse(_valueController.text),
        validFrom: _validFrom,
        validTo: _validTo,
        usageLimit: int.parse(_usageLimitController.text),
      );

      if (widget.offer != null) {
        await ref.read(offersProvider.notifier).updateOffer(offer);
      } else {
        await ref.read(offersProvider.notifier).createOffer(offer);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.offer != null ? 'Offer updated successfully' : 'Offer created successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
} 