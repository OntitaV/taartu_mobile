import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/features/financial/providers/financial_providers.dart';
import 'package:taartu_mobile/src/core/config/feature_flags.dart';

class CommissionRateScreen extends ConsumerStatefulWidget {
  const CommissionRateScreen({super.key});

  @override
  ConsumerState<CommissionRateScreen> createState() => _CommissionRateScreenState();
}

class _CommissionRateScreenState extends ConsumerState<CommissionRateScreen> {
  double _currentCommissionRate = FeatureFlags.defaultCommissionRate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCommissionRate();
    });
  }

  void _loadCommissionRate() {
    final commissionAsync = ref.read(platformFeeProvider);
    commissionAsync.whenData((rate) {
      setState(() => _currentCommissionRate = rate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commissionAsync = ref.watch(platformFeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Commission Rate'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: commissionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.error),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Failed to load commission rate',
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
        data: (rate) => SingleChildScrollView(
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
                      Icons.percent,
                      size: 48,
                      color: AppTheme.white,
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      'Taartu Commission',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      FeatureFlags.commissionDescription,
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

              // Current Commission Display
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
                      'Your Commission Rate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray700,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      '${_currentCommissionRate.toStringAsFixed(1)}%',
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

              // Commission Slider
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
                      'Adjust Commission Rate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Drag the slider to set your preferred commission rate (${FeatureFlags.minCommissionRate}% - ${FeatureFlags.maxCommissionRate}%)',
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
                        value: _currentCommissionRate,
                        min: FeatureFlags.minCommissionRate,
                        max: FeatureFlags.maxCommissionRate,
                        divisions: 20, // 0.5% increments
                        label: '${_currentCommissionRate.toStringAsFixed(1)}%',
                        onChanged: (value) {
                          setState(() => _currentCommissionRate = value);
                        },
                      ),
                    ),
                    
                    // Min/Max labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${FeatureFlags.minCommissionRate}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray500,
                          ),
                        ),
                        Text(
                          '${FeatureFlags.maxCommissionRate}%',
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

              // Commission Examples
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
                      'Commission Examples',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    _buildCommissionExample('KSh 1,000 booking', 1000),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildCommissionExample('KSh 5,000 booking', 5000),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildCommissionExample('KSh 10,000 booking', 10000),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Save Button
              TaartuButton(
                onPressed: _isLoading ? null : _saveCommissionRate,
                text: _isLoading ? 'Saving...' : 'Save Commission Rate',
                variant: TaartuButtonVariant.primary,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Zero Subscription Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                  border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.success,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commission-Only Model',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.success,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            'Zero subscription fees—pay only when you earn',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.success.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // How It Works Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                  border: Border.all(color: AppTheme.info.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.info,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildHowItWorksItem('1. You set your commission rate'),
                    _buildHowItWorksItem('2. Customers book your services'),
                    _buildHowItWorksItem('3. Taartu takes the commission from each booking'),
                    _buildHowItWorksItem('4. You receive the rest directly'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionExample(String bookingAmount, double amount) {
    final commission = amount * (_currentCommissionRate / 100);
    final youReceive = amount - commission;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bookingAmount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray700,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Row(
          children: [
            Expanded(
              child: Text(
                'Taartu commission (${_currentCommissionRate.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray600,
                ),
              ),
            ),
            Text(
              'KSh ${commission.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'You receive',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray600,
                ),
              ),
            ),
            Text(
              'KSh ${youReceive.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHowItWorksItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: AppTheme.spacing8),
            decoration: BoxDecoration(
              color: AppTheme.info,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.info.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveCommissionRate() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(platformFeeProvider.notifier).updatePlatformFee(_currentCommissionRate);
      
      // Track commission rate confirmation
      if (FeatureFlags.trackCommissionEvents) {
        // TODO: Implement Mixpanel tracking
        // mixpanel.track('platform_fee_confirmed', {
        //   'commission_rate': _currentCommissionRate,
        //   'business_id': currentBusinessId,
        // });
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commission rate updated to ${_currentCommissionRate.toStringAsFixed(1)}%'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating commission rate: ${error.toString()}'),
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