import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';

enum BookingStep { service, staff, datetime, confirm }

class EnhancedBookingScreen extends StatefulWidget {
  final String? salonId;
  
  const EnhancedBookingScreen({super.key, this.salonId});

  @override
  State<EnhancedBookingScreen> createState() => _EnhancedBookingScreenState();
}

class _EnhancedBookingScreenState extends State<EnhancedBookingScreen> {
  BookingStep _currentStep = BookingStep.service;
  bool _isLoading = false;
  
  // Booking data
  String? _selectedService;
  String? _selectedStaff;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  // Mock data
  final List<Map<String, dynamic>> _services = [
    {'id': '1', 'name': 'Hair Styling', 'duration': '60 min', 'price': 2500, 'description': 'Professional hair styling and blow dry'},
    {'id': '2', 'name': 'Haircut & Styling', 'duration': '90 min', 'price': 3500, 'description': 'Complete haircut with professional styling'},
    {'id': '3', 'name': 'Hair Coloring', 'duration': '120 min', 'price': 5000, 'description': 'Full hair coloring with premium products'},
    {'id': '4', 'name': 'Manicure & Pedicure', 'duration': '75 min', 'price': 2000, 'description': 'Complete nail care and polish'},
  ];
  
  final List<Map<String, dynamic>> _staff = [
    {'id': '1', 'name': 'Grace Wanjiku', 'rating': 4.8, 'reviews': 127, 'specialties': ['Hair Styling', 'Coloring']},
    {'id': '2', 'name': 'Sarah Muthoni', 'rating': 4.9, 'reviews': 89, 'specialties': ['Manicure', 'Pedicure']},
    {'id': '3', 'name': 'Jane Akinyi', 'rating': 4.7, 'reviews': 156, 'specialties': ['Haircut', 'Styling']},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radius16),
                                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.gray200.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
              ),
              child: _buildStepContent(theme),
            ),
          ),
          
          // Bottom actions
          _buildBottomActions(theme),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      color: AppTheme.white,
      child: Row(
        children: BookingStep.values.map((step) {
          final isActive = step == _currentStep;
          final isCompleted = BookingStep.values.indexOf(step) < BookingStep.values.indexOf(_currentStep);
          
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted ? AppTheme.primary : AppTheme.gray200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : _getStepIcon(step),
                    color: AppTheme.white,
                    size: 16,
                  ),
                ),
                SizedBox(height: AppTheme.spacing4),
                Text(
                  _getStepTitle(step),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AppTheme.primary : AppTheme.gray500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_currentStep) {
      case BookingStep.service:
        return _buildServiceSelection(theme);
      case BookingStep.staff:
        return _buildStaffSelection(theme);
      case BookingStep.datetime:
        return _buildDateTimeSelection(theme);
      case BookingStep.confirm:
        return _buildConfirmation(theme);
    }
  }

  Widget _buildServiceSelection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Service',
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'Choose the service you\'d like to book',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: AppTheme.gray600,
            ),
          ),
          SizedBox(height: AppTheme.spacing24),
          Expanded(
            child: ListView.builder(
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                final isSelected = _selectedService == service['id'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedService = service['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.white,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.gray200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['name'],
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.gray900,
                                ),
                              ),
                              SizedBox(height: AppTheme.spacing4),
                              Text(
                                service['description'],
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: AppTheme.gray600,
                                ),
                              ),
                              SizedBox(height: AppTheme.spacing8),
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 16, color: AppTheme.gray500),
                                  SizedBox(width: AppTheme.spacing4),
                                  Text(
                                    service['duration'],
                                    style: theme.textTheme.bodySmall!.copyWith(
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
                            Text(
                              'KSh ${service['price']}',
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffSelection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Stylist',
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'Select your preferred beauty professional',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: AppTheme.gray600,
            ),
          ),
          SizedBox(height: AppTheme.spacing24),
          Expanded(
            child: ListView.builder(
              itemCount: _staff.length,
              itemBuilder: (context, index) {
                final stylist = _staff[index];
                final isSelected = _selectedStaff == stylist['id'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStaff = stylist['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.white,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.gray200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                          child: Text(
                            stylist['name'].split(' ').map((n) => n[0]).join(''),
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: AppTheme.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stylist['name'],
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.gray900,
                                ),
                              ),
                              SizedBox(height: AppTheme.spacing4),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: AppTheme.warning),
                                  SizedBox(width: AppTheme.spacing4),
                                  Text(
                                    '${stylist['rating']} (${stylist['reviews']} reviews)',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: AppTheme.gray600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppTheme.spacing4),
                              Text(
                                'Specialties: ${stylist['specialties'].join(', ')}',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: AppTheme.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.primary,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date & Time',
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing8),
          Text(
            'Choose your preferred appointment time',
            style: theme.textTheme.bodyLarge!.copyWith(
              color: AppTheme.gray600,
            ),
          ),
          SizedBox(height: AppTheme.spacing24),
          
          // Date selection
          Text(
            'Date',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing12),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.gray50,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                border: Border.all(color: AppTheme.gray200),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppTheme.gray500),
                  SizedBox(width: AppTheme.spacing12),
                  Text(
                    _selectedDate != null 
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select date',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: _selectedDate != null ? AppTheme.gray900 : AppTheme.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Time selection
          Text(
            'Time',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing12),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.gray50,
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                border: Border.all(color: AppTheme.gray200),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: AppTheme.gray500),
                  SizedBox(width: AppTheme.spacing12),
                  Text(
                    _selectedTime != null 
                        ? _selectedTime!.format(context)
                        : 'Select time',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: _selectedTime != null ? AppTheme.gray900 : AppTheme.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Spacer(),
          
          // Quick time slots
          Text(
            'Quick Select',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing12),
          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: ['9:00 AM', '11:00 AM', '2:00 PM', '4:00 PM'].map((time) {
              return GestureDetector(
                onTap: () {
                  // Parse and set time
                  final parts = time.split(' ');
                  final hour = int.parse(parts[0].split(':')[0]);
                  final minute = int.parse(parts[0].split(':')[1]);
                  final isPM = parts[1] == 'PM';
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: isPM && hour != 12 ? hour + 12 : hour,
                      minute: minute,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                    border: Border.all(color: AppTheme.primary),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation(ThemeData theme) {
    final selectedService = _services.firstWhere((s) => s['id'] == _selectedService);
    final selectedStylist = _staff.firstWhere((s) => s['id'] == _selectedStaff);
    
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Booking',
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing24),
          
          // Booking details
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.gray50,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Column(
              children: [
                _buildDetailRow('Service', selectedService['name']),
                _buildDetailRow('Stylist', selectedStylist['name']),
                _buildDetailRow('Date', '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                _buildDetailRow('Time', _selectedTime!.format(context)),
                _buildDetailRow('Duration', selectedService['duration']),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacing24),
          
          // Pricing breakdown
          Text(
            'Pricing Breakdown',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing12),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: Column(
              children: [
                _buildPriceRow('Service Price', 'KSh ${selectedService['price']}'),
                _buildPriceRow('Platform Fee (5%)', 'KSh ${(selectedService['price'] * 0.05).round()}'),
                _buildPriceRow('VAT (16%)', 'KSh ${(selectedService['price'] * 0.16).round()}'),
                Divider(color: AppTheme.gray200),
                _buildPriceRow('Total', 'KSh ${(selectedService['price'] * 1.21).round()}', isTotal: true),
              ],
            ),
          ),
          
          Spacer(),
          
          // Additional notes
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
                                color: AppTheme.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.info, size: 20),
                SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    'You can cancel or reschedule up to 2 hours before your appointment',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: AppTheme.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.gray600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? AppTheme.primary : AppTheme.gray900,
              fontWeight: FontWeight.w700,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
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
      child: Row(
        children: [
          if (_currentStep != BookingStep.service)
            Expanded(
              child: TaartuButton(
                text: 'Back',
                variant: TaartuButtonVariant.outline,
                onPressed: _previousStep,
              ),
            ),
          if (_currentStep != BookingStep.service) SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: TaartuButton(
              text: _getNextButtonText(),
              isLoading: _isLoading,
              onPressed: _canProceed() ? _nextStep : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(BookingStep step) {
    switch (step) {
      case BookingStep.service:
        return 'Service';
      case BookingStep.staff:
        return 'Stylist';
      case BookingStep.datetime:
        return 'Time';
      case BookingStep.confirm:
        return 'Confirm';
    }
  }

  IconData _getStepIcon(BookingStep step) {
    switch (step) {
      case BookingStep.service:
        return Icons.spa;
      case BookingStep.staff:
        return Icons.person;
      case BookingStep.datetime:
        return Icons.schedule;
      case BookingStep.confirm:
        return Icons.check;
    }
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case BookingStep.service:
        return 'Next';
      case BookingStep.staff:
        return 'Next';
      case BookingStep.datetime:
        return 'Next';
      case BookingStep.confirm:
        return 'Confirm Booking';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case BookingStep.service:
        return _selectedService != null;
      case BookingStep.staff:
        return _selectedStaff != null;
      case BookingStep.datetime:
        return _selectedDate != null && _selectedTime != null;
      case BookingStep.confirm:
        return true;
    }
  }

  void _nextStep() {
    if (_currentStep == BookingStep.confirm) {
      _handleBooking();
    } else {
      setState(() {
        _currentStep = BookingStep.values[BookingStep.values.indexOf(_currentStep) + 1];
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = BookingStep.values[BookingStep.values.indexOf(_currentStep) - 1];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _handleBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual booking API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking confirmed! Check your email for details.'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 