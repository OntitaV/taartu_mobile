import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Logo and Welcome Text - Flexible section
                        Flexible(
                          flex: 2,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight * 0.4,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo placeholder
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(AppTheme.radius16),
                                  ),
                                  child: const Icon(
                                    Icons.cut,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing6),
                                Text(
                                  'Welcome to Taartu',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.gray900,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing2),
                                Text(
                                  'Connect with the best salons and stylists in Kenya',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.gray600,
                                    height: 1.1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Role Selection Cards - Flexible section
                        Flexible(
                          flex: 3,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight * 0.5,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'I am a...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.gray900,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing4),
                                
                                // Business Owner/Freelancer Card
                                _buildRoleCard(
                                  context: context,
                                  title: 'Business',
                                  subtitle: 'Manage your business, staff, and bookings',
                                  icon: Icons.store,
                                  color: AppTheme.primary,
                                  onTap: () => _handleRoleSelection(context, 'business'),
                                ),
                                
                                const SizedBox(height: AppTheme.spacing4),
                                
                                // Client Card
                                _buildRoleCard(
                                  context: context,
                                  title: 'Client',
                                  subtitle: 'Book appointments and discover great salons',
                                  icon: Icons.person,
                                  color: AppTheme.secondary,
                                  onTap: () => _handleRoleSelection(context, 'client'),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Footer - Fixed section
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight * 0.1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
                            child: Text(
                              'By continuing, you agree to our Terms of Service and Privacy Policy',
                              style: TextStyle(
                                fontSize: 8,
                                color: AppTheme.gray500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacing24),
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
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
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.gray400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _handleRoleSelection(BuildContext context, String role) {
    // Navigate to unified auth screen with role parameter
    context.go('/auth?role=$role');
  }
} 