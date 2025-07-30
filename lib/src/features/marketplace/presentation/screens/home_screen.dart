import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Enhanced featured service providers for Kenyan market
  final List<Map<String, dynamic>> _featuredProviders = [
    {
      'id': 1,
      'name': 'Elegant Beauty Salon',
      'category': 'Salons',
      'image': 'https://via.placeholder.com/300x200/2563EB/FFFFFF?text=Elegant+Beauty',
      'rating': 4.8,
      'reviews': 124,
      'services': ['Hair Styling', 'Manicure', 'Facial', 'Makeup'],
      'price': 'KSh 2,500',
      'distance': '0.5 km',
      'location': 'Westlands, Nairobi',
      'isOpen': true,
      'isVerified': true,
    },
    {
      'id': 2,
      'name': 'Cut & Style Barbershop',
      'category': 'Barbers',
      'image': 'https://via.placeholder.com/300x200/10B981/FFFFFF?text=Cut+Style',
      'rating': 4.6,
      'reviews': 89,
      'services': ['Hair Cut', 'Beard Trim', 'Hair Color', 'Shaving'],
      'price': 'KSh 800',
      'distance': '1.2 km',
      'location': 'CBD, Nairobi',
      'isOpen': true,
      'isVerified': true,
    },
    {
      'id': 3,
      'name': 'FitLife Gym & Fitness',
      'category': 'Gyms',
      'image': 'https://via.placeholder.com/300x200/EF4444/FFFFFF?text=FitLife+Gym',
      'rating': 4.9,
      'reviews': 156,
      'services': ['Personal Training', 'Group Classes', 'Cardio', 'Strength Training'],
      'price': 'KSh 5,000',
      'distance': '2.1 km',
      'location': 'Kilimani, Nairobi',
      'isOpen': true,
      'isVerified': true,
    },
    {
      'id': 4,
      'name': 'DJ Mwangi Entertainment',
      'category': 'DJs & MCs',
      'image': 'https://via.placeholder.com/300x200/8B5CF6/FFFFFF?text=DJ+Mwangi',
      'rating': 4.7,
      'reviews': 67,
      'services': ['Wedding DJ', 'Corporate Events', 'Birthday Parties', 'MC Services'],
      'price': 'KSh 15,000',
      'distance': '3.5 km',
      'location': 'Karen, Nairobi',
      'isOpen': true,
      'isVerified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, Color(0xFF1D4ED8)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Karibu Taartu!',
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing4),
                        Text(
                          'Find trusted local services in Kenya',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppTheme.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.white),
                onPressed: () => context.go(AppRouter.notifications),
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quick Actions
                  _buildQuickActions(),
                  
                  SizedBox(height: AppTheme.spacing24),
                  
                  // Featured Service Providers
                  Text(
                    'Featured Services',
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing12),
                  Text(
                    'Top-rated service providers near you',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppTheme.gray600,
                    ),
                  ),
                  
                  SizedBox(height: AppTheme.spacing16),
                  
                  // Featured Providers List
                  ..._featuredProviders.map((provider) => _buildProviderCard(provider)),
                  
                  SizedBox(height: AppTheme.spacing24),
                  
                  // View All Button
                  Center(
                    child: TaartuButton(
                      text: 'Explore All Services',
                      variant: TaartuButtonVariant.outline,
                      onPressed: () => context.go(AppRouter.marketplace),
                    ),
                  ),
                  
                  SizedBox(height: AppTheme.spacing32),
                  
                  // Local Insights Section
                  _buildLocalInsights(),
                  
                  SizedBox(height: AppTheme.spacing32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.search,
                  title: 'Find Services',
                  subtitle: 'Browse providers',
                  color: AppTheme.primary,
                  onTap: () => context.go(AppRouter.marketplace),
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.calendar_today,
                  title: 'My Bookings',
                  subtitle: 'View appointments',
                  color: AppTheme.secondary,
                  onTap: () => context.go(AppRouter.booking),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.favorite,
                  title: 'Favorites',
                  subtitle: 'Saved providers',
                  color: AppTheme.error,
                  onTap: () {
                    // TODO: Navigate to favorites
                  },
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.local_offer,
                  title: 'Offers',
                  subtitle: 'Special deals',
                  color: AppTheme.warning,
                  onTap: () {
                    // TODO: Navigate to offers
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radius8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
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
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.spacing2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radius12),
                  topRight: Radius.circular(AppTheme.radius12),
                ),
                child: Image.network(
                  provider['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: AppTheme.gray200,
                      child: const Icon(
                        Icons.image,
                        size: 48,
                        color: AppTheme.gray400,
                      ),
                    );
                  },
                ),
              ),
              
              // Status badges
              Positioned(
                top: AppTheme.spacing12,
                left: AppTheme.spacing12,
                child: Row(
                  children: [
                    if (provider['isOpen'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(AppTheme.radius4),
                        ),
                        child: const Text(
                          'OPEN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    if (provider['isVerified'])
                      Container(
                        margin: const EdgeInsets.only(left: AppTheme.spacing8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(AppTheme.radius4),
                        ),
                        child: const Text(
                          'VERIFIED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Category badge
              Positioned(
                top: AppTheme.spacing12,
                right: AppTheme.spacing12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.gray900.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppTheme.radius4),
                  ),
                  child: Text(
                    provider['category'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Provider Info
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        provider['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray900,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radius4),
                      ),
                      child: Text(
                        'From ${provider['price']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing8),
                
                // Rating and Distance
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.warning,
                    ),
                    SizedBox(width: AppTheme.spacing4),
                    Text(
                      '${provider['rating']} (${provider['reviews']} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing16),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.gray500,
                    ),
                    SizedBox(width: AppTheme.spacing4),
                    Text(
                      provider['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray600,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing12),
                
                // Services
                Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing4,
                  children: (provider['services'] as List<String>).take(3).map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(AppTheme.radius4),
                      ),
                      child: Text(
                        service,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                SizedBox(height: AppTheme.spacing16),
                
                // Book Now Button
                TaartuButton(
                  text: 'Book Now',
                  isFullWidth: true,
                  onPressed: () {
                    // Navigate to payment with booking data
                    final booking = {
                      'providerName': provider['name'],
                      'service': provider['services'][0],
                      'date': 'Dec 15, 2024',
                      'time': '2:00 PM',
                      'price': provider['price'],
                    };
                    context.go(AppRouter.payment, extra: booking);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalInsights() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Local Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.trending_up,
                  title: 'Popular',
                  subtitle: 'Most booked services this week',
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.star,
                  title: 'Top Rated',
                  subtitle: 'Highest rated providers',
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.local_offer,
                  title: 'Deals',
                  subtitle: 'Special offers available',
                  color: AppTheme.success,
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.new_releases,
                  title: 'New',
                  subtitle: 'Recently added providers',
                  color: AppTheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            subtitle,
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
} 