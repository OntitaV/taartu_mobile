import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/features/auth/presentation/screens/welcome_screen.dart';
import 'package:taartu_mobile/src/features/auth/presentation/screens/unified_auth_screen.dart';
import 'package:taartu_mobile/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:taartu_mobile/src/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:taartu_mobile/src/features/auth/presentation/screens/login_screen.dart';
import 'package:taartu_mobile/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:taartu_mobile/src/features/marketplace/presentation/screens/marketplace_screen.dart';
import 'package:taartu_mobile/src/features/marketplace/presentation/screens/home_screen.dart';
import 'package:taartu_mobile/src/features/booking/presentation/screens/booking_screen.dart';
import 'package:taartu_mobile/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:taartu_mobile/src/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:taartu_mobile/src/features/business/presentation/screens/business_dashboard.dart';
import 'package:taartu_mobile/src/features/business/presentation/screens/freelancer_dashboard.dart';
import 'package:taartu_mobile/src/features/business/presentation/screens/employee_rates_screen.dart';
import 'package:taartu_mobile/src/features/payments/presentation/screens/payment_screen.dart';
import 'package:taartu_mobile/src/features/legal/presentation/screens/terms_screen.dart';
import 'package:taartu_mobile/src/features/legal/presentation/screens/privacy_screen.dart';

class AppRouter {
  // Route paths
  static const String welcome = '/welcome';
  static const String auth = '/auth';
  static const String otp = '/otp';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String marketplace = '/marketplace';
  static const String booking = '/booking';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String businessDashboard = '/business-dashboard';
  static const String freelancerDashboard = '/freelancer-dashboard';
  static const String payment = '/payment';
  static const String salonDetails = '/salon/:id';
  static const String bookingDetails = '/booking/:id';
  static const String terms = '/legal/terms';
  static const String privacy = '/legal/privacy';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    routes: [
      // Welcome screen
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      // Unified auth screen
      GoRoute(
        path: auth,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          return UnifiedAuthScreen(role: role);
        },
      ),
      
      // OTP verification screen
      GoRoute(
        path: otp,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          final action = state.uri.queryParameters['action'];
          final email = state.uri.queryParameters['email'];
          final phone = state.uri.queryParameters['phone'];
          return OtpScreen(
            role: role,
            action: action,
            email: email,
            phone: phone,
          );
        },
      ),
      
      // Onboarding screen
      GoRoute(
        path: onboarding,
        builder: (context, state) {
          final role = state.uri.queryParameters['role'];
          return OnboardingScreen(role: role);
        },
      ),
      
      // Legacy auth routes (for backward compatibility)
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavigationBar(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: marketplace,
            builder: (context, state) => const MarketplaceScreen(),
          ),
          GoRoute(
            path: booking,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      
      // Business dashboard (for business owners)
      GoRoute(
        path: businessDashboard,
        builder: (context, state) => const BusinessDashboard(),
      ),
      
      // Freelancer dashboard (for independent stylists)
      GoRoute(
        path: freelancerDashboard,
        builder: (context, state) => const FreelancerDashboard(),
      ),
      GoRoute(
        path: '/employee-rates',
        builder: (context, state) => const EmployeeRatesScreen(),
      ),
      
      // Payment screen
      GoRoute(
        path: payment,
        builder: (context, state) {
          final booking = state.extra as Map<String, dynamic>? ?? {};
          return PaymentScreen(booking: booking);
        },
      ),
      
      // Detail routes
      GoRoute(
        path: salonDetails,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SalonDetailsScreen(id: id);
        },
      ),
      GoRoute(
        path: bookingDetails,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BookingDetailsScreen(id: id);
        },
      ),
      
      // Legal routes
      GoRoute(
        path: terms,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: privacy,
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
  );
}

class ScaffoldWithNavigationBar extends StatefulWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ScaffoldWithNavigationBar> createState() => _ScaffoldWithNavigationBarState();
}

class _ScaffoldWithNavigationBarState extends State<ScaffoldWithNavigationBar> {
  int _currentIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      route: AppRouter.home,
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Services',
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
    NavigationItem(
      icon: Icons.notifications,
      label: 'Alerts',
      route: AppRouter.notifications,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    // Update current index based on current route
    _currentIndex = _items.indexWhere((item) => location.startsWith(item.route));
    if (_currentIndex == -1) _currentIndex = 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isSelected) {
                        context.go(item.route);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? Colors.blue : Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(height: 0),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.grey,
                              fontSize: 6,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
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

// Placeholder widgets for detail screens
class SalonDetailsScreen extends StatelessWidget {
  final String id;

  const SalonDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Details - $id'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Salon Details for ID: $id'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to payment with booking data
                final booking = {
                  'providerName': 'Elegant Beauty Salon',
                  'service': 'Hair Styling & Makeup',
                  'date': 'Dec 15, 2024',
                  'time': '2:00 PM',
                  'price': 'KSh 3,500',
                };
                context.go(AppRouter.payment, extra: booking);
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsScreen extends StatelessWidget {
  final String id;

  const BookingDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details - $id'),
      ),
      body: Center(
        child: Text('Booking Details for ID: $id'),
      ),
    );
  }
} 