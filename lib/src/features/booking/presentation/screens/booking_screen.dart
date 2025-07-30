import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/booking_card.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Enhanced booking data for Kenyan market
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 1,
      'providerName': 'Elegant Beauty Salon',
      'service': 'Hair Styling & Makeup',
      'date': 'Dec 15, 2024',
      'time': '2:00 PM',
      'stylist': 'Sarah Muthoni',
      'price': 'KSh 3,500',
      'status': BookingStatus.upcoming,
      'category': 'Salons',
      'location': 'Westlands, Nairobi',
      'duration': '2 hours',
    },
    {
      'id': 2,
      'providerName': 'Cut & Style Barbershop',
      'service': 'Hair Cut & Beard Trim',
      'date': 'Dec 12, 2024',
      'time': '11:00 AM',
      'stylist': 'John Kamau',
      'price': 'KSh 1,200',
      'status': BookingStatus.completed,
      'category': 'Barbers',
      'location': 'CBD, Nairobi',
      'duration': '45 minutes',
    },
    {
      'id': 3,
      'providerName': 'FitLife Gym & Fitness',
      'service': 'Personal Training Session',
      'date': 'Dec 10, 2024',
      'time': '7:00 AM',
      'stylist': 'Mike Ochieng',
      'price': 'KSh 2,000',
      'status': BookingStatus.completed,
      'category': 'Gyms',
      'location': 'Kilimani, Nairobi',
      'duration': '1 hour',
    },
    {
      'id': 4,
      'providerName': 'DJ Mwangi Entertainment',
      'service': 'Wedding DJ & MC',
      'date': 'Dec 20, 2024',
      'time': '4:00 PM',
      'stylist': 'DJ Mwangi',
      'price': 'KSh 25,000',
      'status': BookingStatus.upcoming,
      'category': 'DJs & MCs',
      'location': 'Karen, Nairobi',
      'duration': '6 hours',
    },
    {
      'id': 5,
      'providerName': 'Serenity Spa & Wellness',
      'service': 'Full Body Massage',
      'date': 'Dec 8, 2024',
      'time': '3:00 PM',
      'stylist': 'Grace Wanjiku',
      'price': 'KSh 4,500',
      'status': BookingStatus.completed,
      'category': 'Spas',
      'location': 'Lavington, Nairobi',
      'duration': '1.5 hours',
    },
    {
      'id': 6,
      'providerName': 'Capture Moments Photography',
      'service': 'Wedding Photography',
      'date': 'Dec 5, 2024',
      'time': '9:00 AM',
      'stylist': 'David Kimani',
      'price': 'KSh 35,000',
      'status': BookingStatus.completed,
      'category': 'Photography',
      'location': 'Westlands, Nairobi',
      'duration': '8 hours',
    },
    {
      'id': 7,
      'providerName': 'Taste of Kenya Catering',
      'service': 'Wedding Catering',
      'date': 'Dec 18, 2024',
      'time': '12:00 PM',
      'stylist': 'Chef Wanjiru',
      'price': 'KSh 15,000',
      'status': BookingStatus.upcoming,
      'category': 'Catering',
      'location': 'South B, Nairobi',
      'duration': '4 hours',
    },
    {
      'id': 8,
      'providerName': 'CleanPro Services',
      'service': 'House Deep Cleaning',
      'date': 'Dec 7, 2024',
      'time': '10:00 AM',
      'stylist': 'Team CleanPro',
      'price': 'KSh 5,000',
      'status': BookingStatus.cancelled,
      'category': 'Cleaning',
      'location': 'Donholm, Nairobi',
      'duration': '3 hours',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.gray600,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(BookingStatus.upcoming),
          _buildBookingsList(BookingStatus.completed),
          _buildBookingsList(BookingStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BookingStatus status) {
    final filteredBookings = _bookings.where((booking) => booking['status'] == status).toList();
    
    if (filteredBookings.isEmpty) {
      return _buildEmptyState(status);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return BookingCard(
          booking: booking,
          onReschedule: () => _showRescheduleDialog(booking),
          onCancel: () => _showCancelDialog(booking),
        );
      },
    );
  }

  Widget _buildEmptyState(BookingStatus status) {
    String title;
    String message;
    IconData icon;
    
    switch (status) {
      case BookingStatus.upcoming:
        title = 'No Upcoming Bookings';
        message = 'You don\'t have any upcoming appointments. Start exploring services!';
        icon = Icons.calendar_today_outlined;
        break;
      case BookingStatus.completed:
        title = 'No Past Bookings';
        message = 'Your completed bookings will appear here.';
        icon = Icons.check_circle_outline;
        break;
      case BookingStatus.cancelled:
        title = 'No Cancelled Bookings';
        message = 'Your cancelled bookings will appear here.';
        icon = Icons.cancel_outlined;
        break;
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.gray400,
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray600,
              ),
            ),
            SizedBox(height: AppTheme.spacing8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            if (status == BookingStatus.upcoming) ...[
              SizedBox(height: AppTheme.spacing24),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to marketplace
                },
                icon: const Icon(Icons.search),
                label: const Text('Explore Services'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showRescheduleDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Booking'),
        content: Text(
          'Would you like to reschedule your ${booking['service']} appointment with ${booking['providerName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to reschedule screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to reschedule...'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel your ${booking['service']} appointment with ${booking['providerName']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                booking['status'] = BookingStatus.cancelled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
} 