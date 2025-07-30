import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      route: AppRouter.home,
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Search',
      route: AppRouter.marketplace,
    ),
    NavigationItem(
      icon: Icons.calendar_today,
      label: 'Bookings',
      route: AppRouter.booking,
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Profile',
      route: AppRouter.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    // Update current index based on current route
    _currentIndex = _navigationItems.indexWhere(
      (item) => location.startsWith(item.route),
    );
    
    if (_currentIndex == -1) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.gray200.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;
                
                return _buildNavigationItem(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => _onItemTapped(index, item.route),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required NavigationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.animationNormal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radius8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? AppTheme.primary : AppTheme.gray400,
            ),
            SizedBox(height: AppTheme.spacing4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primary : AppTheme.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, String route) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      context.go(route);
    }
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
} 