import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_app_bar.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_drawer.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBusinessOwner = false;

  // User data
  final Map<String, dynamic> _userData = {
    'name': 'Sarah Wanjiku',
    'email': 'sarah.wanjiku@email.com',
    'phone': '+254 712 345 678',
    'avatar': 'https://via.placeholder.com/100x100/2563EB/FFFFFF?text=SW',
    'joinDate': 'December 2023',
    'totalBookings': 24,
    'favoriteServices': 8,
  };

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: TaartuAppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      drawer: const TaartuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            
            SizedBox(height: AppTheme.spacing24),
            
            // Quick Stats
            _buildQuickStats(),
            
            SizedBox(height: AppTheme.spacing24),
            
                         // Business Owner Toggle
             _buildBusinessToggle(),
             
             SizedBox(height: AppTheme.spacing16),
             
             // Business Dashboard Button
             _buildBusinessDashboardButton(),
             
             SizedBox(height: AppTheme.spacing24),
            
            // Menu Items
            _buildMenuItems(),
            
            SizedBox(height: AppTheme.spacing32),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: TaartuButton(
                text: 'Logout',
                variant: TaartuButtonVariant.danger,
                onPressed: () => _showLogoutDialog(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        children: [
          // Avatar and Edit Button
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_userData['avatar']),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacing4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing16),
          
          // User Info
          Text(
            _userData['name'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            _userData['email'],
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.gray600,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'Member since ${_userData['joinDate']}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Bookings',
            _userData['totalBookings'].toString(),
            Icons.calendar_today,
            AppTheme.primary,
          ),
        ),
        SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: _buildStatCard(
            'Favorites',
            _userData['favoriteServices'].toString(),
            Icons.favorite,
            AppTheme.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessToggle() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business,
            color: AppTheme.primary,
            size: 24,
          ),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Owner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                Text(
                  'Manage your business services',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
          ),
                     Switch(
             value: _isBusinessOwner,
             onChanged: (value) {
               setState(() {
                 _isBusinessOwner = value;
               });
             },
             activeColor: AppTheme.primary,
           ),
         ],
       ),
     );
   }

   Widget _buildBusinessDashboardButton() {
     if (!_isBusinessOwner) return const SizedBox.shrink();
     
     return Container(
       margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
       child: TaartuButton(
         text: 'Open Business Dashboard',
         variant: TaartuButtonVariant.primary,
         isFullWidth: true,
         onPressed: () => context.go(AppRouter.businessDashboard),
       ),
     );
   }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Personal Information',
          subtitle: 'Update your profile details',
          onTap: () => _showEditProfileDialog(),
        ),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          subtitle: 'Manage your addresses',
          onTap: () => _showAddressesDialog(),
        ),
        _buildMenuItem(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap: () => _showPaymentMethodsDialog(),
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: () => context.go(AppRouter.notifications),
        ),
        _buildMenuItem(
          icon: Icons.security_outlined,
          title: 'Privacy & Security',
          subtitle: 'Manage your account security',
          onTap: () => _showPrivacyDialog(),
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () => _showHelpDialog(),
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About Taartu',
          subtitle: 'Learn more about the app',
          onTap: () => _showAboutDialog(),
        ),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          onTap: () => context.go(AppRouter.terms),
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: () => context.go(AppRouter.privacy),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: AppTheme.gray100,
            borderRadius: BorderRadius.circular(AppTheme.radius8),
          ),
          child: Icon(
            icon,
            color: AppTheme.gray700,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray900,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.gray600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.gray400,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius12),
        ),
        tileColor: AppTheme.white,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRouter.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('This will open the profile editing form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile editing form opened'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showAddressesDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Manage Addresses'),
        content: const Text('This will open the address management interface.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address management opened'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Payment Methods'),
        content: const Text('This will open the payment methods management.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment methods management opened'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text('This will open the privacy and security settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings opened'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('This will open the help and support center.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help center opened'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About Taartu'),
        content: const Text('This will show information about the Taartu app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('About information displayed'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
} 