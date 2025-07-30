import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                SizedBox(height: AppTheme.spacing32),
                
                // Logo and welcome text
                Column(
                  children: [
                    Container(
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
                    SizedBox(height: AppTheme.spacing24),
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.gray900,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Sign in to your Taartu account',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: AppTheme.gray600,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing48),
                
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
                
                // Password input
                TaartuInput(
                  label: 'Password',
                  hint: 'Enter your password',
                  type: TaartuInputType.password,
                  controller: _passwordController,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                
                SizedBox(height: AppTheme.spacing8),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password screen
                    },
                    child: Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: AppTheme.spacing32),
                
                // Login button
                TaartuButton(
                  text: 'Sign In',
                  isFullWidth: true,
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
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
                
                // Social login buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement Google sign in
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
                          // TODO: Implement Apple sign in
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
                
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppTheme.gray600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRouter.signup),
                      child: Text(
                        'Sign Up',
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual login logic with API
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        context.go(AppRouter.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
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