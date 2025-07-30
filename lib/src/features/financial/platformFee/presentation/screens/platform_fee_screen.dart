import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/features/financial/providers/financial_providers.dart';

class PlatformFeeScreen extends ConsumerStatefulWidget {
  const PlatformFeeScreen({super.key});

  @override
  ConsumerState<PlatformFeeScreen> createState() => _PlatformFeeScreenState();
}

class _PlatformFeeScreenState extends ConsumerState<PlatformFeeScreen> {
  double _currentFee = 10.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlatformFee();
    });
  }

  void _loadPlatformFee() {
    final feeAsync = ref.read(platformFeeProvider);
    feeAsync.whenData((fee) {
      setState(() => _currentFee = fee);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feeAsync = ref.watch(platformFeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Fee'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: feeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.error),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Failed to load platform fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Please try again',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              TaartuButton(
                onPressed: () => ref.refresh(platformFeeProvider),
                text: 'Retry',
                variant: TaartuButtonVariant.primary,
              ),
            ],
          ),
        ),
        data: (fee) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: AppTheme.white,
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      'Platform Fee',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Configure the fee percentage charged on each booking',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Current Fee Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                  border: Border.all(color: AppTheme.gray200),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.gray200.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Platform Fee',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray700,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      '${_currentFee.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'per booking',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Fee Slider
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                  border: Border.all(color: AppTheme.gray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adjust Platform Fee',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Drag the slider to set your preferred platform fee percentage (5% - 15%)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    
                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.primary,
                        inactiveTrackColor: AppTheme.gray200,
                        thumbColor: AppTheme.primary,
                        overlayColor: AppTheme.primary.withValues(alpha: 0.2),
                        valueIndicatorColor: AppTheme.primary,
                        valueIndicatorTextStyle: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Slider(
                        value: _currentFee,
                        min: 5.0,
                        max: 15.0,
                        divisions: 20,
                        label: '${_currentFee.toStringAsFixed(1)}%',
                        onChanged: (value) {
                          setState(() => _currentFee = value);
                        },
                      ),
                    ),
                    
                    // Min/Max labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5%',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray500,
                          ),
                        ),
                        Text(
                          '15%',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Fee Examples
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.gray50,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                  border: Border.all(color: AppTheme.gray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fee Examples',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    _buildFeeExample('KSh 1,000 booking', 1000),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildFeeExample('KSh 5,000 booking', 5000),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildFeeExample('KSh 10,000 booking', 10000),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Save Button
              TaartuButton(
                onPressed: _isLoading ? null : _savePlatformFee,
                text: _isLoading ? 'Saving...' : 'Save Platform Fee',
                variant: TaartuButtonVariant.primary,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                  border: Border.all(color: AppTheme.info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Text(
                        'The platform fee is automatically calculated and deducted from each booking. This helps us maintain and improve the Taartu platform.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeExample(String bookingAmount, double amount) {
    final fee = amount * (_currentFee / 100);
    return Row(
      children: [
        Expanded(
          child: Text(
            bookingAmount,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray700,
            ),
          ),
        ),
        Text(
          'KSh ${fee.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  void _savePlatformFee() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(platformFeeProvider.notifier).updatePlatformFee(_currentFee);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Platform fee updated to ${_currentFee.toStringAsFixed(1)}%'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating platform fee: ${error.toString()}'),
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