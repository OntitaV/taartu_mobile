import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_app_bar.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import '../../../financial/offers/presentation/screens/offers_screen.dart';
import '../../../financial/platformFee/presentation/screens/commission_rate_screen.dart';
import 'package:go_router/go_router.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  // Business data
  final Map<String, dynamic> _businessData = {
    'name': 'Elegant Beauty Salon',
    'category': 'Salons',
    'location': 'Westlands, Nairobi',
    'rating': 4.8,
    'reviews': 124,
    'isVerified': true,
    'isOpen': true,
  };

  // Dashboard stats
  final Map<String, dynamic> _stats = {
    'totalBookings': 156,
    'pendingBookings': 12,
    'completedBookings': 144,
    'totalRevenue': 'KSh 425,000',
    'monthlyRevenue': 'KSh 85,000',
    'averageRating': 4.8,
    'totalCustomers': 89,
    'activeEmployees': 8,
  };

  // Recent bookings
  final List<Map<String, dynamic>> _recentBookings = [
    {
      'id': 1,
      'customerName': 'Sarah Wanjiku',
      'service': 'Hair Styling & Makeup',
      'date': 'Dec 15, 2024',
      'time': '2:00 PM',
      'status': 'confirmed',
      'price': 'KSh 3,500',
      'employee': 'Grace Muthoni',
    },
    {
      'id': 2,
      'customerName': 'John Kamau',
      'service': 'Beard Trim',
      'date': 'Dec 15, 2024',
      'time': '3:30 PM',
      'status': 'pending',
      'price': 'KSh 800',
      'employee': 'Mike Ochieng',
    },
    {
      'id': 3,
      'customerName': 'Mary Njeri',
      'service': 'Facial Treatment',
      'date': 'Dec 14, 2024',
      'time': '11:00 AM',
      'status': 'completed',
      'price': 'KSh 2,500',
      'employee': 'Sarah Muthoni',
    },
  ];

  // Employees
  final List<Map<String, dynamic>> _employees = [
    {
      'id': 1,
      'name': 'Sarah Muthoni',
      'role': 'Senior Stylist',
      'specialties': ['Hair Styling', 'Makeup', 'Facial'],
      'rating': 4.9,
      'bookings': 45,
      'isAvailable': true,
      'avatar': 'https://via.placeholder.com/60x60/2563EB/FFFFFF?text=SM',
    },
    {
      'id': 2,
      'name': 'Grace Wanjiku',
      'role': 'Hair Specialist',
      'specialties': ['Hair Coloring', 'Extensions', 'Braiding'],
      'rating': 4.7,
      'bookings': 38,
      'isAvailable': true,
      'avatar': 'https://via.placeholder.com/60x60/10B981/FFFFFF?text=GW',
    },
    {
      'id': 3,
      'name': 'Mike Ochieng',
      'role': 'Barber',
      'specialties': ['Hair Cuts', 'Beard Trim', 'Shaving'],
      'rating': 4.8,
      'bookings': 52,
      'isAvailable': false,
      'avatar': 'https://via.placeholder.com/60x60/EF4444/FFFFFF?text=MO',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: TaartuAppBar(
        title: Text(
          'Business Dashboard',
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to business settings
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.gray600,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Bookings'),
            Tab(text: 'Employees'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildBookingsTab(),
          _buildEmployeesTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Info Card
          _buildBusinessInfoCard(),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Quick Stats
          Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          // Stats Grid
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Bookings', _stats['totalBookings'].toString(), Icons.calendar_today, AppTheme.primary)),
              SizedBox(width: AppTheme.spacing12),
              Expanded(child: _buildStatCard('Pending', _stats['pendingBookings'].toString(), Icons.schedule, AppTheme.warning)),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing12),
          
          Row(
            children: [
              Expanded(child: _buildStatCard('Revenue', _stats['monthlyRevenue'], Icons.attach_money, AppTheme.success)),
              SizedBox(width: AppTheme.spacing12),
              Expanded(child: _buildStatCard('Rating', _stats['averageRating'].toString(), Icons.star, AppTheme.warning)),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.add_circle,
                  title: 'Add Service',
                  subtitle: 'Create new service',
                  color: AppTheme.primary,
                  onTap: () => _showAddServiceDialog(),
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.person_add,
                  title: 'Add Employee',
                  subtitle: 'Hire new staff',
                  color: AppTheme.secondary,
                  onTap: () => _showAddEmployeeDialog(),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing12),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.schedule,
                  title: 'Manage Schedule',
                  subtitle: 'Set availability',
                  color: AppTheme.success,
                  onTap: () => _showScheduleDialog(),
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.analytics,
                  title: 'View Reports',
                  subtitle: 'Business insights',
                  color: AppTheme.warning,
                  onTap: () => _showReportsDialog(),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing12),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.local_offer,
                  title: 'Offers & Coupons',
                  subtitle: 'Create promotions',
                  color: AppTheme.primary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OffersScreen(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.percent,
                  title: 'Your Commission Rate',
                  subtitle: 'Set commission rate',
                  color: AppTheme.info,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommissionRateScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing12),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.check_circle,
                  title: 'Commission Model',
                  subtitle: 'Zero subscription fees',
                  color: AppTheme.success,
                  onTap: () => _showCommissionModelInfo(),
                ),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.people,
                  title: 'Team Rates',
                  subtitle: 'Set commission rates',
                  color: AppTheme.secondary,
                  onTap: () => context.go('/employee-rates'),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Recent Bookings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(1); // Switch to bookings tab
                },
                child: const Text('View All'),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing16),
          
          ..._recentBookings.map((booking) => _buildBookingCard(booking)),
        ],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking filters
          Row(
            children: [
              Expanded(
                child: _buildFilterChip('All', _selectedIndex == 0, () => setState(() => _selectedIndex = 0)),
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: _buildFilterChip('Pending', _selectedIndex == 1, () => setState(() => _selectedIndex = 1)),
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: _buildFilterChip('Confirmed', _selectedIndex == 2, () => setState(() => _selectedIndex = 2)),
              ),
              SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: _buildFilterChip('Completed', _selectedIndex == 3, () => setState(() => _selectedIndex = 3)),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Bookings list
          ..._recentBookings.map((booking) => _buildBookingCard(booking)),
        ],
      ),
    );
  }

  Widget _buildEmployeesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Employees', _employees.length.toString(), Icons.people, AppTheme.primary),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildStatCard('Available', _employees.where((e) => e['isAvailable']).length.toString(), Icons.check_circle, AppTheme.success),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Employees list
          Text(
            'Employees',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          ..._employees.map((employee) => _buildEmployeeCard(employee)),
          
          SizedBox(height: AppTheme.spacing16),
          
          // Add employee button
          SizedBox(
            width: double.infinity,
            child: TaartuButton(
              text: 'Add New Employee',
              variant: TaartuButtonVariant.outline,
              onPressed: () => _showAddEmployeeDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue overview
          Text(
            'Revenue Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.gray600,
                      ),
                    ),
                    Text(
                      _stats['totalRevenue'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'This Month',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray500,
                      ),
                    ),
                    Text(
                      _stats['monthlyRevenue'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Performance metrics
          Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
          
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Customer Satisfaction', '${_stats['averageRating']}/5.0', Icons.star, AppTheme.warning),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildMetricCard('Total Customers', _stats['totalCustomers'].toString(), Icons.people, AppTheme.primary),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacing12),
          
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Completion Rate', '92%', Icons.check_circle, AppTheme.success),
              ),
              SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: _buildMetricCard('Avg. Booking Value', 'KSh 2,700', Icons.attach_money, AppTheme.secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
            child: const Icon(
              Icons.business,
              size: 30,
              color: AppTheme.white,
            ),
          ),
          SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _businessData['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                SizedBox(height: AppTheme.spacing4),
                Text(
                  _businessData['category'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
                SizedBox(height: AppTheme.spacing4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppTheme.gray500,
                    ),
                    SizedBox(width: AppTheme.spacing4),
                    Text(
                      _businessData['location'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: AppTheme.warning,
                  ),
                  SizedBox(width: AppTheme.spacing4),
                  Text(
                    _businessData['rating'].toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing2,
                ),
                decoration: BoxDecoration(
                  color: _businessData['isOpen'] ? AppTheme.success : AppTheme.error,
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
                child: Text(
                  _businessData['isOpen'] ? 'OPEN' : 'CLOSED',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const Spacer(),
              Icon(
                Icons.trending_up,
                size: 16,
                color: AppTheme.success,
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
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
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radius12),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            SizedBox(height: AppTheme.spacing12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
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
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking['customerName'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking['status']),
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
                child: Text(
                  booking['status'].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            booking['service'],
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray700,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppTheme.gray500,
              ),
              SizedBox(width: AppTheme.spacing4),
              Text(
                '${booking['date']} at ${booking['time']}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray600,
                ),
              ),
              SizedBox(width: AppTheme.spacing16),
              Icon(
                Icons.person,
                size: 14,
                color: AppTheme.gray500,
              ),
              SizedBox(width: AppTheme.spacing4),
              Text(
                booking['employee'],
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking['price'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
              if (booking['status'] == 'pending')
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _confirmBooking(booking),
                      child: const Text('Confirm'),
                    ),
                    SizedBox(width: AppTheme.spacing8),
                    OutlinedButton(
                      onPressed: () => _rejectBooking(booking),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        side: const BorderSide(color: AppTheme.error),
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(employee['avatar']),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle error
            },
          ),
          SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                SizedBox(height: AppTheme.spacing4),
                Text(
                  employee['role'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
                SizedBox(height: AppTheme.spacing8),
                Wrap(
                  spacing: AppTheme.spacing4,
                  children: (employee['specialties'] as List<String>).take(2).map((specialty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing6,
                        vertical: AppTheme.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(AppTheme.radius4),
                      ),
                      child: Text(
                        specialty,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.gray700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 14,
                    color: AppTheme.warning,
                  ),
                  SizedBox(width: AppTheme.spacing2),
                  Text(
                    employee['rating'].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing6,
                  vertical: AppTheme.spacing2,
                ),
                decoration: BoxDecoration(
                  color: employee['isAvailable'] ? AppTheme.success : AppTheme.error,
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
                child: Text(
                  employee['isAvailable'] ? 'Available' : 'Busy',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.gray100,
          borderRadius: BorderRadius.circular(AppTheme.radius8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.white : AppTheme.gray700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.success;
      case 'pending':
        return AppTheme.warning;
      case 'completed':
        return AppTheme.primary;
      case 'cancelled':
        return AppTheme.error;
      default:
        return AppTheme.gray500;
    }
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: const Text('This will open the service creation form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service creation form opened'),
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

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Employee'),
        content: const Text('This will open the employee registration form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee registration form opened'),
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

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Schedule'),
        content: const Text('This will open the schedule management interface.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Schedule management opened'),
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

  void _showReportsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Business Reports'),
        content: const Text('This will open the detailed business analytics and reports.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Business reports opened'),
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

  void _confirmBooking(Map<String, dynamic> booking) {
    setState(() {
      booking['status'] = 'confirmed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed for ${booking['customerName']}'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _rejectBooking(Map<String, dynamic> booking) {
    setState(() {
      booking['status'] = 'cancelled';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking rejected for ${booking['customerName']}'),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  void _showCommissionModelInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success, size: 24),
            SizedBox(width: AppTheme.spacing8),
            const Text('Commission Model'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zero Subscription Model',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'How it works:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray700,
              ),
            ),
            SizedBox(height: AppTheme.spacing8),
            ...[
              _buildInfoItem('1. No monthly fees or subscriptions'),
              _buildInfoItem('2. Pay only when you earn'),
              _buildInfoItem('3. Commission rate: 5% - 15%'),
              _buildInfoItem('4. Set your own team rates'),
              _buildInfoItem('5. Transparent pricing'),
            ],
            SizedBox(height: AppTheme.spacing16),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                                  border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.success, size: 16),
                  SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: Text(
                      'This model ensures you only pay when you earn, making it perfect for businesses of all sizes.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommissionRateScreen(),
                ),
              );
            },
            child: const Text('Set Commission Rate'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: AppTheme.spacing8),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 