import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final bool _isLoading = false;
  String _selectedFilter = 'all';

  // Dummy notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'type': 'booking',
      'title': 'Booking Confirmed',
      'message': 'Your appointment at Elegant Beauty Salon has been confirmed for Dec 15, 2024 at 2:00 PM.',
      'time': '2 hours ago',
      'isRead': false,
      'icon': Icons.check_circle,
      'color': AppTheme.success,
    },
    {
      'id': 2,
      'type': 'reminder',
      'title': 'Appointment Reminder',
      'message': 'Don\'t forget your appointment tomorrow at Glamour Hair Studio at 11:00 AM.',
      'time': '1 day ago',
      'isRead': false,
      'icon': Icons.schedule,
      'color': AppTheme.primary,
    },
    {
      'id': 3,
      'type': 'promotion',
      'title': 'Special Offer',
      'message': 'Get 20% off on all hair styling services at Zen Spa & Wellness this weekend!',
      'time': '2 days ago',
      'isRead': true,
      'icon': Icons.local_offer,
      'color': AppTheme.warning,
    },
    {
      'id': 4,
      'type': 'booking',
      'title': 'Booking Cancelled',
      'message': 'Your appointment at Elegant Beauty Salon has been cancelled. Please reschedule.',
      'time': '3 days ago',
      'isRead': true,
      'icon': Icons.cancel,
      'color': AppTheme.error,
    },
    {
      'id': 5,
      'type': 'system',
      'title': 'Welcome to Taartu',
      'message': 'Thank you for joining Taartu! Start exploring salons and book your first appointment.',
      'time': '1 week ago',
      'isRead': true,
      'icon': Icons.waving_hand,
      'color': AppTheme.secondary,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'all') {
      return _notifications;
    }
    return _notifications.where((notification) => notification['type'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: 'booking',
                child: Text('Bookings'),
              ),
              const PopupMenuItem(
                value: 'reminder',
                child: Text('Reminders'),
              ),
              const PopupMenuItem(
                value: 'promotion',
                child: Text('Promotions'),
              ),
              const PopupMenuItem(
                value: 'system',
                child: Text('System'),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.filter_list),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _filteredNotifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppTheme.gray400,
          ),
          SizedBox(height: AppTheme.spacing16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray600,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final theme = Theme.of(context);
    final isRead = notification['isRead'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(
          color: isRead ? AppTheme.gray200 : AppTheme.primary.withValues(alpha: 0.3),
          width: isRead ? 1 : 2,
        ),
        boxShadow: isRead
            ? null
            : [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppTheme.spacing16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (notification['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radius8),
          ),
          child: Icon(
            notification['icon'] as IconData,
            color: notification['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          notification['title'] as String,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
            color: isRead ? AppTheme.gray700 : AppTheme.gray900,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppTheme.spacing4),
            Text(
              notification['message'] as String,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: AppTheme.gray600,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppTheme.spacing8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppTheme.gray500,
                ),
                SizedBox(width: AppTheme.spacing4),
                Text(
                  notification['time'] as String,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: AppTheme.gray500,
                  ),
                ),
                if (!isRead) ...[
                  SizedBox(width: AppTheme.spacing8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        onTap: () => _handleNotificationTap(notification),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleNotificationAction(value, notification),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'mark_read',
              child: Text(isRead ? 'Mark as unread' : 'Mark as read'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          child: const Icon(
            Icons.more_vert,
            color: AppTheme.gray400,
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Mark as read if not already read
    if (!notification['isRead']) {
      setState(() {
        notification['isRead'] = true;
      });
    }

    // Handle different notification types
    switch (notification['type']) {
      case 'booking':
        // Navigate to booking details
        break;
      case 'reminder':
        // Navigate to booking details
        break;
      case 'promotion':
        // Navigate to promotion details
        break;
      case 'system':
        // Show system message
        break;
    }

    // Show a snackbar for demo purposes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${notification['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleNotificationAction(String action, Map<String, dynamic> notification) {
    switch (action) {
      case 'mark_read':
        setState(() {
          notification['isRead'] = !notification['isRead'];
        });
        break;
      case 'delete':
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: AppTheme.success,
          ),
        );
        break;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppTheme.success,
      ),
    );
  }
} 