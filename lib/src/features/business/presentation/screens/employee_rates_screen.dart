import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_input.dart';
import 'package:taartu_mobile/src/features/financial/models/employee_rate.dart';
import 'package:taartu_mobile/src/features/financial/providers/financial_providers.dart';

class EmployeeRatesScreen extends ConsumerStatefulWidget {
  const EmployeeRatesScreen({super.key});

  @override
  ConsumerState<EmployeeRatesScreen> createState() => _EmployeeRatesScreenState();
}

class _EmployeeRatesScreenState extends ConsumerState<EmployeeRatesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  String _selectedType = 'commission';
  bool _isLoading = false;
  bool _showAddForm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRatesAsync = ref.watch(employeeRatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Rates'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showAddForm ? Icons.close : Icons.add),
            onPressed: () {
              setState(() {
                _showAddForm = !_showAddForm;
                if (!_showAddForm) {
                  _resetForm();
                }
              });
            },
          ),
        ],
      ),
      body: employeeRatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.error),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Failed to load team rates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'Please try again',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              TaartuButton(
                onPressed: () => ref.refresh(employeeRatesProvider),
                text: 'Retry',
                variant: TaartuButtonVariant.primary,
              ),
            ],
          ),
        ),
        data: (rates) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.people,
                      size: 48,
                      color: AppTheme.white,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'Team Commission Rates',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Set commission rates for your team members',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Add New Rate Form
              if (_showAddForm) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radius16),
                    border: Border.all(color: AppTheme.gray200),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.gray200.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Team Member',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gray900,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing20),
                        
                        // Employee Name
                        TaartuInput(
                          controller: _nameController,
                          label: 'Employee Name',
                          hint: 'Enter employee name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter employee name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Rate Type
                        Text(
                          'Rate Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.gray900,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Commission %'),
                                value: 'commission',
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Flat Rate'),
                                value: 'flat',
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        
                        // Rate Value
                        TaartuInput(
                          controller: _valueController,
                          label: _selectedType == 'commission' ? 'Commission %' : 'Flat Rate (KSh)',
                          hint: _selectedType == 'commission' ? 'Enter percentage' : 'Enter amount',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null) {
                              return 'Please enter a valid number';
                            }
                            if (_selectedType == 'commission' && (numValue < 0 || numValue > 100)) {
                              return 'Commission must be between 0% and 100%';
                            }
                            if (_selectedType == 'flat' && numValue < 0) {
                              return 'Flat rate must be positive';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppTheme.spacing24),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: TaartuButton(
                                onPressed: _isLoading ? null : _resetForm,
                                text: 'Cancel',
                                variant: TaartuButtonVariant.outline,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing12),
                            Expanded(
                              child: TaartuButton(
                                onPressed: _isLoading ? null : _addEmployeeRate,
                                text: _isLoading ? 'Adding...' : 'Add Member',
                                variant: TaartuButtonVariant.primary,
                                isLoading: _isLoading,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing24),
              ],

              // Team Members List
              Text(
                'Team Members (${rates.length})',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              if (rates.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing32),
                  decoration: BoxDecoration(
                    color: AppTheme.gray50,
                    borderRadius: BorderRadius.circular(AppTheme.radius16),
                    border: Border.all(color: AppTheme.gray200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: AppTheme.gray400,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'No team members yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Add your first team member to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...rates.map((rate) => _buildEmployeeRateCard(rate)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeRateCard(EmployeeRate rate) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray200.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
            child: Text(
              rate.employeeName[0].toUpperCase(),
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rate.employeeName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  rate.displayValue,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editEmployeeRate(rate);
              } else if (value == 'delete') {
                _deleteEmployeeRate(rate);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _nameController.clear();
    _valueController.clear();
    _selectedType = 'commission';
    setState(() {
      _showAddForm = false;
    });
  }

  void _addEmployeeRate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final value = double.parse(_valueController.text);
      await ref.read(employeeRatesProvider.notifier).createEmployeeRate({
        'employee_name': _nameController.text,
        'type': _selectedType,
        'value': value,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team member added successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add team member: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _editEmployeeRate(EmployeeRate rate) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality coming soon'),
        backgroundColor: AppTheme.info,
      ),
    );
  }

  void _deleteEmployeeRate(EmployeeRate rate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team Member'),
        content: Text('Are you sure you want to delete ${rate.employeeName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(employeeRatesProvider.notifier).deleteEmployeeRate(rate.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Team member deleted successfully'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete team member: ${e.toString()}'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }
} 