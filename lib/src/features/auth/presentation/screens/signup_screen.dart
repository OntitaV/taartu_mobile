import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _selectedRole = 'client';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppTheme.spacing16),
                
                // Back button and title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go(AppRouter.login),
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
                        'Create Account',
                        style: theme.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.gray900,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing24),
                
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(AppTheme.radius16),
                    ),
                    child: const Icon(
                      Icons.spa,
                      size: 40,
                      color: AppTheme.white,
                    ),
                  ),
                ),
                
                SizedBox(height: AppTheme.spacing32),
                
                // Role selection
                Text(
                  'I am a:',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray700,
                  ),
                ),
                SizedBox(height: AppTheme.spacing12),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        title: 'Client',
                        subtitle: 'Book services',
                        icon: Icons.person,
                        isSelected: _selectedRole == 'client',
                        onTap: () => setState(() => _selectedRole = 'client'),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: _buildRoleCard(
                        title: 'Business',
                        subtitle: 'Manage salon',
                        icon: Icons.business,
                        isSelected: _selectedRole == 'business',
                        onTap: () => setState(() => _selectedRole = 'business'),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing24),
                
                // Name input
                TaartuInput(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                
                SizedBox(height: AppTheme.spacing16),
                
                // Email input
                TaartuInput(
                  label: 'Email',
                  hint: 'Enter your email address',
                  type: TaartuInputType.email,
                  controller: _emailController,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                
                SizedBox(height: AppTheme.spacing16),
                
                // Phone input
                TaartuInput(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  type: TaartuInputType.phone,
                  controller: _phoneController,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                
                SizedBox(height: AppTheme.spacing16),
                
                // Password input
                TaartuInput(
                  label: 'Password',
                  hint: 'Create a strong password',
                  type: TaartuInputType.password,
                  controller: _passwordController,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                
                SizedBox(height: AppTheme.spacing16),
                
                // Confirm password input
                TaartuInput(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  type: TaartuInputType.password,
                  controller: _confirmPasswordController,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                
                SizedBox(height: AppTheme.spacing24),
                
                // Terms and conditions
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primary,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppTheme.gray600,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing32),
                
                // Sign up button
                TaartuButton(
                  text: 'Create Account',
                  isFullWidth: true,
                  isLoading: _isLoading,
                  onPressed: _acceptTerms ? _handleSignup : null,
                ),
                
                SizedBox(height: AppTheme.spacing24),
                
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.gray300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
                      child: Text(
                        'OR',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppTheme.gray500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.gray300)),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing24),
                
                // Social signup buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement Google sign up
                        },
                        icon: const Icon(Icons.g_mobiledata, size: 24),
                        label: const Text('Google'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                          side: const BorderSide(color: AppTheme.gray300),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement Apple sign up
                        },
                        icon: const Icon(Icons.apple, size: 24),
                        label: const Text('Apple'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
                          side: const BorderSide(color: AppTheme.gray300),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing32),
                
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppTheme.gray600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRouter.login),
                      child: Text(
                        'Sign In',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.animationNormal,
        padding: const EdgeInsets.all(AppTheme.spacing16),
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
              size: 32,
              color: isSelected ? AppTheme.primary : AppTheme.gray500,
            ),
            SizedBox(height: AppTheme.spacing8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.gray700,
              ),
            ),
            SizedBox(height: AppTheme.spacing4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual signup logic with API
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Navigate to OTP verification
        context.go(AppRouter.otp);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed: ${e.toString()}'),
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