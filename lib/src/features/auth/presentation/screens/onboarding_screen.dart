import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';

class OnboardingScreen extends StatefulWidget {
  final String? role;
  
  const OnboardingScreen({super.key, this.role});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salonNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _kraPinController = TextEditingController();
  
  // Form validation
  final _formKey = GlobalKey<FormState>();
  
  // Business-specific data
  String? _selectedBusinessType;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _salonNameController.dispose();
    _addressController.dispose();
    _kraPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusiness = widget.role == 'business';
    final totalSteps = isBusiness ? 4 : 2;
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          isBusiness ? 'Business Setup' : 'Complete Profile',
          style: TextStyle(
            color: AppTheme.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              children: [
                Row(
                  children: List.generate(totalSteps, (index) {
                    final isActive = index == _currentStep;
                    final isCompleted = index < _currentStep;
                    
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index < totalSteps - 1 ? AppTheme.spacing8 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted 
                              ? AppTheme.success 
                              : isActive 
                                  ? AppTheme.primary 
                                  : AppTheme.gray200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  _getStepTitle(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Form(
                key: _formKey,
                child: _buildCurrentStep(),
              ),
            ),
          ),
          
          // Bottom navigation
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handlePrevious,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                        side: BorderSide(color: AppTheme.gray300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radius8),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: AppTheme.gray700,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: TaartuButton(
                    text: _getButtonText(),
                    onPressed: _isLoading ? null : _handleNext,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    final isBusiness = widget.role == 'business';
    
    if (isBusiness) {
      switch (_currentStep) {
        case 0:
          return 'Basic Information';
        case 1:
          return 'Business Details';
        case 2:
          return 'KYC Verification';
        case 3:
          return 'Commission Setup';
        default:
          return 'Complete';
      }
    } else {
      switch (_currentStep) {
        case 0:
          return 'Personal Information';
        case 1:
          return 'Payment Setup';
        default:
          return 'Complete';
      }
    }
  }

  String _getButtonText() {
    final isBusiness = widget.role == 'business';
    final isLastStep = isBusiness ? _currentStep == 3 : _currentStep == 1;
    
    if (_isLoading) {
      return 'Processing...';
    }
    
    if (isLastStep) {
      return 'Complete Setup';
    }
    
    return 'Continue';
  }

  Widget _buildCurrentStep() {
    final isBusiness = widget.role == 'business';
    
    if (isBusiness) {
      switch (_currentStep) {
        case 0:
          return _buildBasicInfoStep();
        case 1:
          return _buildBusinessDetailsStep();
        case 2:
          return _buildKYCStep();
        case 3:
          return _buildCommissionStep();
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (_currentStep) {
        case 0:
          return _buildPersonalInfoStep();
        case 1:
          return _buildPaymentSetupStep();
        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us about yourself',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'We\'ll use this information to set up your business profile',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        
        TaartuInput(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        TaartuInput(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        TaartuInput(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBusinessDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Help clients find and book your services',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        
        // Business Type Selection
        Text(
          'Business Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing12),
        
        _buildBusinessTypeCard('Business', 'Beauty salon or hair salon', Icons.store),
        const SizedBox(height: AppTheme.spacing12),
        _buildBusinessTypeCard('Freelancer', 'Independent stylist or beautician', Icons.person),
        
        const SizedBox(height: AppTheme.spacing24),
        
        TaartuInput(
          controller: _salonNameController,
          label: 'Business Name',
          hint: 'Enter your business name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business name';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        TaartuInput(
          controller: _addressController,
          label: 'Business Address',
          hint: 'Enter your business address',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your business address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBusinessTypeCard(String title, String subtitle, IconData icon) {
    final isSelected = _selectedBusinessType == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBusinessType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.gray100,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.gray600,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primary : AppTheme.gray900,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKYCStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KYC Verification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Verify your identity to start accepting payments',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        
        // KRA PIN Input
        TaartuInput(
          controller: _kraPinController,
          label: 'KRA PIN',
          hint: 'Enter your KRA PIN',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your KRA PIN';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacing24),
        
        // ID Upload Section
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radius12),
            border: Border.all(color: AppTheme.gray200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.upload_file,
                size: 48,
                color: AppTheme.gray400,
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Upload ID Document',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Upload a clear photo of your ID (National ID, Passport, or Driving License)',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing16),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement file picker
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo or Upload'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommissionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commission Rate',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Set your commission rate for Taartu services',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radius16),
            border: Border.all(color: AppTheme.gray200),
          ),
          child: Column(
            children: [
              Text(
                '10%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Default Commission Rate',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
              
              // Commission Slider
              Slider(
                value: 10.0,
                min: 10.0,
                max: 15.0,
                divisions: 5,
                activeColor: AppTheme.primary,
                inactiveColor: AppTheme.gray200,
                onChanged: (value) {
                  // TODO: Update commission rate
                },
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '10%',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray500,
                    ),
                  ),
                  Text(
                    '15%',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray500,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius8),
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
                        'You can adjust this rate later in your business settings',
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
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete Your Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Help us personalize your experience',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        
        TaartuInput(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        TaartuInput(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        TaartuInput(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentSetupStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Setup',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Add a payment method for seamless bookings',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radius16),
            border: Border.all(color: AppTheme.gray200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.credit_card,
                size: 48,
                color: AppTheme.primary,
              ),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Add Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Securely add your card to make instant payments',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing24),
              
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Integrate with Paystack
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Card'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              TextButton(
                onPressed: () {
                  // Skip payment setup
                  _handleComplete();
                },
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    color: AppTheme.gray500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePrevious() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _handleNext() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final isBusiness = widget.role == 'business';
    final isLastStep = isBusiness ? _currentStep == 3 : _currentStep == 1;

    if (isLastStep) {
      await _handleComplete();
    } else {
      setState(() {
        _currentStep++;
      });
    }
  }

  Future<void> _handleComplete() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Save onboarding data to API
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Navigate to appropriate dashboard based on role and business type
        String route;
        if (widget.role == 'business') {
          // Check if it's a freelancer or business owner
          if (_selectedBusinessType == 'Freelancer') {
            route = '/freelancer-dashboard';
          } else {
            route = '/business-dashboard';
          }
        } else {
          route = '/home';
        }
        context.go(route);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup failed: ${e.toString()}'),
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
} 