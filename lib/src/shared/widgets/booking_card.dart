import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

enum BookingStatus { upcoming, completed, cancelled }

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onReschedule,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = booking['status'] as BookingStatus;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.2),
          width: 1,
        ),
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
          // Header with status
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radius12),
                topRight: Radius.circular(AppTheme.radius12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(AppTheme.radius4),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.white,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  booking['price'] as String,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider name and category
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking['providerName'] as String,
                        style: theme.textTheme.titleMedium!.copyWith(
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
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(AppTheme.radius4),
                      ),
                      child: Text(
                        booking['category'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.gray700,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing8),
                
                // Service name
                Text(
                  booking['service'] as String,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.gray700,
                  ),
                ),
                
                SizedBox(height: AppTheme.spacing12),
                
                // Details grid
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: booking['date'] as String,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.access_time,
                        label: 'Time',
                        value: booking['time'] as String,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing8),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.person,
                        label: 'Provider',
                        value: booking['stylist'] as String,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.schedule,
                        label: 'Duration',
                        value: booking['duration'] as String,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacing8),
                
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.gray500,
                    ),
                    SizedBox(width: AppTheme.spacing4),
                    Expanded(
                      child: Text(
                        booking['location'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Action buttons for upcoming bookings
                if (status == BookingStatus.upcoming) ...[
                  SizedBox(height: AppTheme.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReschedule,
                          icon: const Icon(Icons.schedule, size: 16),
                          label: const Text('Reschedule'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                          ),
                        ),
                      ),
                      SizedBox(width: AppTheme.spacing12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onCancel,
                          icon: const Icon(Icons.cancel, size: 16),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.error,
                            foregroundColor: AppTheme.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                
                // View details button for all bookings
                if (status != BookingStatus.upcoming) ...[
                  SizedBox(height: AppTheme.spacing16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to booking details
                      },
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.primary),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.gray500,
        ),
        SizedBox(width: AppTheme.spacing4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray900,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return AppTheme.primary;
      case BookingStatus.completed:
        return AppTheme.success;
      case BookingStatus.cancelled:
        return AppTheme.error;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return 'UPCOMING';
      case BookingStatus.completed:
        return 'COMPLETED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
    }
  }
} 