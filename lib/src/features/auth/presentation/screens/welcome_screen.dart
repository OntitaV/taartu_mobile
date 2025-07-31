import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Logo and Welcome Text - Compact section
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00CED1), // Teal background
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                          ),
                          child: Image.asset(
                            'assets/logos/app_icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Welcome to Taartu',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.gray900,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Connect with the best salons and stylists in Kenya',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: AppTheme.gray600,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Role Selection Cards - Main section
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          'I am a...',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gray900,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Business Owner/Freelancer Card
                        _buildRoleCard(
                          context: context,
                          title: 'Business',
                          subtitle: 'Manage your business, staff, and bookings',
                          icon: Icons.store,
                          color: AppTheme.primary,
                          onTap: () => _handleRoleSelection(context, 'business'),
                        ),
                        
                        SizedBox(height: screenHeight * 0.015),
                        
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

                  // Footer - Minimal section
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: Text(
                        'By continuing, you agree to our Terms of Service and Privacy Policy',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.08, // Reduced height
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
        padding: EdgeInsets.all(screenWidth * 0.03), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.08, // Reduced size
              height: screenWidth * 0.08, // Reduced size
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: screenWidth * 0.04, // Reduced size
              ),
            ),
            SizedBox(width: screenWidth * 0.03), // Reduced spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gray900,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.003), // Reduced spacing
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03, // Reduced font size
                      color: AppTheme.gray600,
                    ),
                    maxLines: 1, // Reduced to 1 line
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.gray400,
              size: screenWidth * 0.035, // Reduced size
            ),
          ],
        ),
      ),
    );
  }

  void _handleRoleSelection(BuildContext context, String role) {
    // Navigate to appropriate onboarding flow based on role
    if (role == 'business') {
      context.go('/auth/signup?role=business');
    } else {
      context.go('/auth/signup?role=client');
    }
  }
} 