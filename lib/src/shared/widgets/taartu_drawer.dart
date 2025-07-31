import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class TaartuDrawer extends StatelessWidget {
  const TaartuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with Primary Logo
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              color: AppTheme.primary,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Primary Logo
                  Image.asset(
                    'assets/logos/logo_primary.png',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    'Taartu Booking Marketplace',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.home,
                  title: 'Home',
                  route: AppRouter.home,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.search,
                  title: 'Services',
                  route: AppRouter.marketplace,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.calendar_today,
                  title: 'Bookings',
                  route: AppRouter.booking,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person,
                  title: 'Profile',
                  route: AppRouter.profile,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  route: AppRouter.notifications,
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.business,
                  title: 'Business Dashboard',
                  route: AppRouter.businessDashboard,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.description,
                  title: 'Terms of Service',
                  route: AppRouter.terms,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  route: AppRouter.privacy,
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // TODO: Implement logout
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.gray700),
      title: Text(
        title,
        style: TextStyle(
          color: AppTheme.gray900,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
} 