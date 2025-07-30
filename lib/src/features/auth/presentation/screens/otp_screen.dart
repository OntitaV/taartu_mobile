import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';

class OtpScreen extends StatefulWidget {
  final String? role;
  final String? action;
  final String? email;
  final String? phone;
  
  const OtpScreen({
    super.key,
    this.role,
    this.action,
    this.email,
    this.phone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 0;
  late String _contactInfo;
  late String _contactType;

  @override
  void initState() {
    super.initState();
    _initializeContactInfo();
    _startResendCountdown();
  }

  void _initializeContactInfo() {
    if (widget.email != null && widget.email!.isNotEmpty) {
      _contactInfo = widget.email!;
      _contactType = 'email';
    } else if (widget.phone != null && widget.phone!.isNotEmpty) {
      _contactInfo = widget.phone!;
      _contactType = 'phone';
    } else {
      _contactInfo = 'user@example.com'; // Default fallback
      _contactType = 'email';
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSignUp = widget.action == 'signup';
    
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppTheme.spacing16),
              
              // Back button and title
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/auth?role=${widget.role}'),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.gray100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius8),
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing16),
                  Expanded(
                    child: Text(
                      isSignUp ? 'Verify Account' : 'Verify Login',
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.gray900,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppTheme.spacing32),
              
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                ),
                child: Icon(
                  _contactType == 'email' ? Icons.email : Icons.phone,
                  color: AppTheme.primary,
                  size: 40,
                ),
              ),
              
              SizedBox(height: AppTheme.spacing24),
              
              // Title and description
              Text(
                'Verification Code',
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppTheme.spacing8),
              
              Text(
                'We\'ve sent a ${_contactType == 'email' ? 'verification code' : 'SMS'} to',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: AppTheme.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppTheme.spacing4),
              
              Text(
                _contactInfo,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppTheme.spacing32),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radius8),
                          borderSide: BorderSide(color: AppTheme.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radius8),
                          borderSide: BorderSide(color: AppTheme.gray300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radius8),
                          borderSide: BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        _checkOtpComplete();
                      },
                    ),
                  );
                }),
              ),
              
              SizedBox(height: AppTheme.spacing32),
              
              // Verify Button
              TaartuButton(
                text: _isLoading ? 'Verifying...' : 'Verify Code',
                onPressed: _isLoading ? null : _handleVerification,
                isLoading: _isLoading,
              ),
              
              SizedBox(height: AppTheme.spacing24),
              
              // Resend Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the code? ',
                    style: TextStyle(
                      color: AppTheme.gray600,
                      fontSize: 14,
                    ),
                  ),
                  if (_resendCountdown > 0)
                    Text(
                      'Resend in $_resendCountdown',
                      style: TextStyle(
                        color: AppTheme.gray500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _isResending ? null : _handleResend,
                      child: Text(
                        _isResending ? 'Sending...' : 'Resend Code',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: AppTheme.spacing16),
              
              // Change contact info
              TextButton(
                onPressed: () {
                  // Navigate back to auth screen to change contact info
                  context.go('/auth?role=${widget.role}');
                },
                child: Text(
                  'Change ${_contactType == 'email' ? 'Email' : 'Phone Number'}',
                  style: TextStyle(
                    color: AppTheme.gray500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkOtpComplete() {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _isOtpComplete()) {
          _handleVerification();
        }
      });
    }
  }

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  Future<void> _handleVerification() async {
    if (!_isOtpComplete()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the complete OTP
      final otp = _otpControllers.map((controller) => controller.text).join(); // ignore: unused_local_variable
      
      // TODO: Implement actual OTP verification with API using the 'otp' variable
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful!'),
            backgroundColor: AppTheme.success,
          ),
        );
        
        // Navigate based on role and action
        if (widget.action == 'signup') {
          // Navigate to onboarding
          context.go('/onboarding?role=${widget.role}');
        } else {
          // Navigate to appropriate dashboard
          final route = widget.role == 'business' ? '/business-dashboard' : '/home';
          context.go(route);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResend() async {
    setState(() {
      _isResending = true;
    });

    try {
      // TODO: Implement actual resend OTP with API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent!'),
            backgroundColor: AppTheme.success,
          ),
        );
        
        // Clear OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        
        // Focus on first field
        _focusNodes[0].requestFocus();
        
        // Start countdown
        _startResendCountdown();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }
} 