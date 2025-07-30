import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_card.dart';

class FreelancerDashboard extends StatefulWidget {
  const FreelancerDashboard({super.key});

  @override
  State<FreelancerDashboard> createState() => _FreelancerDashboardState();
}

class _FreelancerDashboardState extends State<FreelancerDashboard> {
  bool _isAvailable = true;

  // Freelancer data
  final Map<String, dynamic> _freelancerData = {
    'name': 'Grace Wanjiku',
    'role': 'Independent Stylist',
    'specialties': ['Hair Styling', 'Makeup', 'Facial Treatments'],
    'rating': 4.8,
    'reviews': 89,
    'experience': '5 years',
    'location': 'Westlands, Nairobi',
    'avatar': 'https://via.placeholder.com/100x100/10B981/FFFFFF?text=GW',
  };

  // Today's schedule
  final List<Map<String, dynamic>> _todaySchedule = [
    {
      'id': 1,
      'customerName': 'Sarah Muthoni',
      'service': 'Hair Styling & Makeup',
      'time': '10:00 AM',
      'duration': '2 hours',
      'status': 'confirmed',
      'price': 'KSh 3,500',
      'location': 'Client\'s Home - Westlands',
    },
    {
      'id': 2,
      'customerName': 'Mary Njeri',
      'service': 'Facial Treatment',
      'time': '2:00 PM',
      'duration': '1 hour',
      'status': 'pending',
      'price': 'KSh 2,000',
      'location': 'Client\'s Home - Kilimani',
    },
    {
      'id': 3,
      'customerName': 'Jane Kamau',
      'service': 'Bridal Makeup',
      'time': '5:00 PM',
      'duration': '3 hours',
      'status': 'confirmed',
      'price': 'KSh 8,000',
      'location': 'Wedding Venue - Karen',
    },
  ];

  // Weekly stats
  final Map<String, dynamic> _weeklyStats = {
    'totalBookings': 12,
    'completedBookings': 10,
    'pendingBookings': 2,
    'totalEarnings': 'KSh 45,000',
    'averageRating': 4.8,
    'hoursWorked': 28,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: const Text('My Schedule'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          // Availability toggle
          Switch(
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
              _showAvailabilitySnackBar(value);
            },
            activeColor: AppTheme.success,
          ),
          const SizedBox(width: AppTheme.spacing8),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.go('/notifications');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Summary
            _buildProfileSummary(),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Availability Status
            _buildAvailabilityStatus(),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Weekly Stats
            _buildWeeklyStats(),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Today's Schedule
            _buildTodaySchedule(),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSummary() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(_freelancerData['avatar']),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _freelancerData['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  _freelancerData['role'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      '${_freelancerData['rating']} (${_freelancerData['reviews']} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to profile edit
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityStatus() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: _isAvailable ? AppTheme.success.withValues(alpha: 0.1) : AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(
          color: _isAvailable ? AppTheme.success : AppTheme.error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isAvailable ? Icons.check_circle : Icons.cancel,
            color: _isAvailable ? AppTheme.success : AppTheme.error,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAvailable ? 'Available for Bookings' : 'Not Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isAvailable ? AppTheme.success : AppTheme.error,
                  ),
                ),
                Text(
                  _isAvailable 
                      ? 'Clients can book your services'
                      : 'You\'re currently not taking bookings',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Bookings',
                '${_weeklyStats['totalBookings']}',
                Icons.calendar_today,
                AppTheme.primary,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildStatCard(
                'Earnings',
                _weeklyStats['totalEarnings'],
                Icons.attach_money,
                AppTheme.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Hours',
                '${_weeklyStats['hoursWorked']}h',
                Icons.access_time,
                AppTheme.warning,
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildStatCard(
                'Rating',
                '${_weeklyStats['averageRating']}',
                Icons.star,
                AppTheme.info,
              ),
            ),
          ],
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
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray900,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full schedule
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        if (_todaySchedule.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing32),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 48,
                  color: AppTheme.gray400,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'No bookings today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Enjoy your free time!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
          )
        else
          ..._todaySchedule.map((booking) => _buildBookingCard(booking)),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final statusColor = _getStatusColor(booking['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: TaartuCard(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['customerName'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gray900,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          booking['service'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radius8),
                    ),
                    child: Text(
                      booking['status'].toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.gray500,
                  ),
                  const SizedBox(width: AppTheme.spacing4),
                  Text(
                    '${booking['time']} (${booking['duration']})',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray700,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing16),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.gray500,
                  ),
                  const SizedBox(width: AppTheme.spacing4),
                  Expanded(
                    child: Text(
                      booking['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.gray700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking['price'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  if (booking['status'] == 'confirmed')
                    TaartuButton(
                      text: 'Start Service',
                      onPressed: () => _startService(booking),
                      size: TaartuButtonSize.small,
                    )
                  else if (booking['status'] == 'pending')
                    Row(
                      children: [
                        TaartuButton(
                          text: 'Accept',
                          onPressed: () => _acceptBooking(booking),
                          size: TaartuButtonSize.small,
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        OutlinedButton(
                          onPressed: () => _declineBooking(booking),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radius8),
                            ),
                          ),
                          child: Text(
                            'Decline',
                            style: TextStyle(
                              color: AppTheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Update Schedule',
                Icons.calendar_month,
                AppTheme.primary,
                () {
                  // TODO: Navigate to schedule update
                },
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildActionCard(
                'View Earnings',
                Icons.attach_money,
                AppTheme.success,
                () {
                  // TODO: Navigate to earnings
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'My Services',
                Icons.list_alt,
                AppTheme.warning,
                () {
                  // TODO: Navigate to services
                },
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: _buildActionCard(
                'Settings',
                Icons.settings,
                AppTheme.info,
                () {
                  // TODO: Navigate to settings
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              color: color,
              size: 24,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        return AppTheme.info;
      case 'cancelled':
        return AppTheme.error;
      default:
        return AppTheme.gray500;
    }
  }

  void _showAvailabilitySnackBar(bool isAvailable) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAvailable 
              ? 'You\'re now available for bookings'
              : 'You\'re now unavailable for bookings',
        ),
        backgroundColor: isAvailable ? AppTheme.success : AppTheme.warning,
      ),
    );
  }

  void _startService(Map<String, dynamic> booking) {
    // TODO: Implement service start logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting service for ${booking['customerName']}'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _acceptBooking(Map<String, dynamic> booking) {
    // TODO: Implement booking acceptance logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking accepted for ${booking['customerName']}'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _declineBooking(Map<String, dynamic> booking) {
    // TODO: Implement booking decline logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking declined for ${booking['customerName']}'),
        backgroundColor: AppTheme.error,
      ),
    );
  }
} 