import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';
import 'package:taartu_mobile/src/core/navigation/app_router.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'Nairobi';

  // Kenyan service categories
  final List<String> _categories = [
    'All',
    'Salons',
    'Barbers',
    'Gyms',
    'DJs & MCs',
    'Spas',
    'Photography',
    'Catering',
    'Transport',
    'Cleaning',
    'Tutoring',
    'Events',
  ];

  // Kenyan locations
  final List<String> _locations = [
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Eldoret',
    'Thika',
    'Nyeri',
    'Kakamega',
    'Kisii',
    'Kericho',
  ];

  // Enhanced dummy data for Kenyan market
  final List<Map<String, dynamic>> _serviceProviders = [
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
      'description': 'Premium beauty services for all occasions',
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
      'description': 'Professional barbering services',
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
      'description': 'Modern fitness facility with expert trainers',
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
      'description': 'Professional DJ and MC for all events',
      'isOpen': true,
      'isVerified': true,
    },
    {
      'id': 5,
      'name': 'Serenity Spa & Wellness',
      'category': 'Spas',
      'image': 'https://via.placeholder.com/300x200/F59E0B/FFFFFF?text=Serenity+Spa',
      'rating': 4.8,
      'reviews': 92,
      'services': ['Massage', 'Facial', 'Body Treatment', 'Aromatherapy'],
      'price': 'KSh 3,500',
      'distance': '1.8 km',
      'location': 'Lavington, Nairobi',
      'description': 'Relaxing spa treatments for mind and body',
      'isOpen': true,
      'isVerified': true,
    },
    {
      'id': 6,
      'name': 'Capture Moments Photography',
      'category': 'Photography',
      'image': 'https://via.placeholder.com/300x200/06B6D4/FFFFFF?text=Capture+Moments',
      'rating': 4.9,
      'reviews': 78,
      'services': ['Wedding Photography', 'Portrait Sessions', 'Event Coverage', 'Video Production'],
      'price': 'KSh 25,000',
      'distance': '4.2 km',
      'location': 'Westlands, Nairobi',
      'description': 'Professional photography and videography services',
      'isOpen': true,
      'isVerified': true,
    },
    {
      'id': 7,
      'name': 'Taste of Kenya Catering',
      'category': 'Catering',
      'image': 'https://via.placeholder.com/300x200/84CC16/FFFFFF?text=Taste+of+Kenya',
      'rating': 4.5,
      'reviews': 45,
      'services': ['Wedding Catering', 'Corporate Events', 'Private Parties', 'Traditional Cuisine'],
      'price': 'KSh 1,200',
      'distance': '2.8 km',
      'location': 'South B, Nairobi',
      'description': 'Authentic Kenyan cuisine for all occasions',
      'isOpen': true,
      'isVerified': false,
    },
    {
      'id': 8,
      'name': 'CleanPro Services',
      'category': 'Cleaning',
      'image': 'https://via.placeholder.com/300x200/6B7280/FFFFFF?text=CleanPro',
      'rating': 4.4,
      'reviews': 56,
      'services': ['House Cleaning', 'Office Cleaning', 'Deep Cleaning', 'Carpet Cleaning'],
      'price': 'KSh 2,000',
      'distance': '1.5 km',
      'location': 'Donholm, Nairobi',
      'description': 'Professional cleaning services for homes and offices',
      'isOpen': true,
      'isVerified': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredProviders {
    return _serviceProviders.where((provider) {
      final matchesCategory = _selectedCategory == 'All' || provider['category'] == _selectedCategory;
      final matchesLocation = provider['location'].contains(_selectedLocation);
      final matchesSearch = _searchController.text.isEmpty ||
          provider['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          provider['services'].any((service) => service.toLowerCase().contains(_searchController.text.toLowerCase()));
      
      return matchesCategory && matchesLocation && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                          'Find Local Services',
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppTheme.spacing4),
                        Text(
                          'Discover trusted service providers in Kenya',
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
          ),
          
          // Search and Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              child: Column(
                children: [
                  // Search Bar
                  TaartuInput(
                    label: 'Search services or providers',
                    hint: 'e.g., Hair styling, DJ, Gym...',
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (value) => setState(() {}),
                  ),
                  
                  SizedBox(height: AppTheme.spacing16),
                  
                  // Categories
                  Text(
                    'Categories',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        
                        return Padding(
                          padding: EdgeInsets.only(
                            right: AppTheme.spacing8,
                            left: index == 0 ? 0 : 0,
                          ),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            backgroundColor: AppTheme.gray100,
                            selectedColor: AppTheme.primary.withValues(alpha: 0.2),
                            checkmarkColor: AppTheme.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? AppTheme.primary : AppTheme.gray700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: AppTheme.spacing16),
                  
                  // Location Filter
                  Text(
                    'Location',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        final location = _locations[index];
                        final isSelected = location == _selectedLocation;
                        
                        return Padding(
                          padding: EdgeInsets.only(
                            right: AppTheme.spacing8,
                            left: index == 0 ? 0 : 0,
                          ),
                          child: FilterChip(
                            label: Text(location),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedLocation = location;
                              });
                            },
                            backgroundColor: AppTheme.gray100,
                            selectedColor: AppTheme.secondary.withValues(alpha: 0.2),
                            checkmarkColor: AppTheme.secondary,
                            labelStyle: TextStyle(
                              color: isSelected ? AppTheme.secondary : AppTheme.gray700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: AppTheme.spacing16),
                  
                  // Results Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_filteredProviders.length} service providers found',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Show advanced filters
                        },
                        icon: const Icon(Icons.tune, size: 16),
                        label: const Text('Filters'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Service Providers List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final provider = _filteredProviders[index];
                return _buildServiceProviderCard(provider);
              },
              childCount: _filteredProviders.length,
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppTheme.spacing32),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceProviderCard(Map<String, dynamic> provider) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppTheme.spacing16,
        right: AppTheme.spacing16,
        bottom: AppTheme.spacing16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radius12),
                  topRight: Radius.circular(AppTheme.radius12),
                ),
                child: Image.network(
                  provider['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
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
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        provider['name'],
                        style: const TextStyle(
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
                
                // Rating and Location
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
                
                // Description
                Text(
                  provider['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray700,
                    height: 1.4,
                  ),
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
                
                if ((provider['services'] as List<String>).length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spacing4),
                    child: Text(
                      '+${(provider['services'] as List<String>).length - 3} more services',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                
                SizedBox(height: AppTheme.spacing16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to provider details
                        },
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing12),
                                           Expanded(
                         child: ElevatedButton.icon(
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
                           icon: const Icon(Icons.calendar_today, size: 16),
                           label: const Text('Book Now'),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppTheme.primary,
                             foregroundColor: AppTheme.white,
                           ),
                         ),
                       ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 