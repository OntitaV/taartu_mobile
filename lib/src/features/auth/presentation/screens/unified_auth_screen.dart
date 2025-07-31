import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_app_bar.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';

class UnifiedAuthScreen extends StatefulWidget {
  final String? role;
  
  const UnifiedAuthScreen({super.key, this.role});

  @override
  State<UnifiedAuthScreen> createState() => _UnifiedAuthScreenState();
}

class _UnifiedAuthScreenState extends State<UnifiedAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Form validation
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isSignUp = _tabController.index == 1;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: TaartuAppBar(
        title: Text(widget.role == 'business' ? 'Business Account' : 'Client Account'),
        onBackPressed: () => context.go('/welcome'),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.gray500,
              indicatorColor: AppTheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Sign In'),
                Tab(text: 'Sign Up'),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSignInTab(),
                _buildSignUpTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray900,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Sign in to your account to continue',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.gray600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),
            
            // Email/Phone Input
            TaartuInput(
              controller: _emailController,
              label: 'Email or Phone',
              hint: 'Enter your email or phone number',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or phone';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing16),
            
            // Password Input
            TaartuInput(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              type: TaartuInputType.password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing8),
            
            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),
            
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: TaartuButton(
                text: _isLoading ? 'Signing In...' : 'Sign In',
                onPressed: _isLoading ? null : _handleSignIn,
                isLoading: _isLoading,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: AppTheme.gray300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: AppTheme.gray500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppTheme.gray300)),
              ],
            ),
            const SizedBox(height: AppTheme.spacing24),
            
            // Continue with OTP
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _handleContinueWithOTP,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                  side: BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                ),
                child: Text(
                  'Continue with OTP',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray900,
              ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Join Taartu and start your journey',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.gray600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),
            
            // Name Input
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
            
            // Email Input
            TaartuInput(
              controller: _emailController,
              label: 'Email',
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
            
            // Phone Input
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
            const SizedBox(height: AppTheme.spacing16),
            
            // Password Input
            TaartuInput(
              controller: _passwordController,
              label: 'Password',
              hint: 'Create a password',
              type: TaartuInputType.password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing16),
            
            // Confirm Password Input
            TaartuInput(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Confirm your password',
              type: TaartuInputType.password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: AppTheme.spacing32),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: TaartuButton(
                text: _isLoading ? 'Creating Account...' : 'Create Account',
                onPressed: _isLoading ? null : _handleSignUp,
                isLoading: _isLoading,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: AppTheme.gray300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: AppTheme.gray500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppTheme.gray300)),
              ],
            ),
            const SizedBox(height: AppTheme.spacing24),
            
            // Continue with OTP
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _handleContinueWithOTP,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
                  side: BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                ),
                child: Text(
                  'Continue with OTP',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement actual sign in logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Navigate to appropriate dashboard based on role
        final route = widget.role == 'business' ? '/business-dashboard' : '/home';
        context.go(route);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement actual sign up logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Navigate to OTP verification
        context.go('/otp?role=${widget.role}&action=signup');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
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

  void _handleContinueWithOTP() {
    // Navigate to OTP screen
    final action = _isSignUp ? 'signup' : 'signin';
    context.go('/otp?role=${widget.role}&action=$action');
  }
} 