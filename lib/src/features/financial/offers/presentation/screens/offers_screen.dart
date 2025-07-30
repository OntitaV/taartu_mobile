import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';
import 'package:taartu_mobile/src/shared/widgets/taartu_button.dart';

import 'package:taartu_mobile/src/features/financial/providers/financial_providers.dart';
import 'package:taartu_mobile/src/features/financial/models/offer.dart';
import 'create_offer_screen.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Coupons'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: offersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.error),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                'Failed to load offers',
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
                onPressed: () => ref.refresh(offersProvider),
                text: 'Retry',
                variant: TaartuButtonVariant.primary,
              ),
            ],
          ),
        ),
        data: (offers) => Column(
          children: [
            // Header with stats
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              color: AppTheme.primary,
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Active Offers',
                      offers.where((o) => o.isValid).length.toString(),
                      Icons.local_offer,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: _buildStatCard(
                      'Total Offers',
                      offers.length.toString(),
                      Icons.inventory,
                    ),
                  ),
                ],
              ),
            ),
            
            // Offers list
            Expanded(
              child: offers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];
                        return _buildOfferCard(offer);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateOffer(),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.white, size: 24),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: AppTheme.gray400,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'No offers yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'Create your first offer to attract more customers',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing24),
          TaartuButton(
            onPressed: () => _navigateToCreateOffer(),
            text: 'Create First Offer',
            variant: TaartuButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray200.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with status
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: offer.isValid ? AppTheme.success.withValues(alpha: 0.1) : AppTheme.error.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radius12),
                topRight: Radius.circular(AppTheme.radius12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.gray900,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        offer.discountDisplay,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
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
                    color: offer.isValid ? AppTheme.success : AppTheme.error,
                    borderRadius: BorderRadius.circular(AppTheme.radius8),
                  ),
                  child: Text(
                    offer.isValid ? 'ACTIVE' : 'INACTIVE',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Column(
              children: [
                _buildDetailRow('Valid From', _formatDate(offer.validFrom)),
                _buildDetailRow('Valid To', _formatDate(offer.validTo)),
                _buildDetailRow('Usage', '${offer.currentUsage}/${offer.usageLimit}'),
                _buildDetailRow('Type', offer.discountType == 'percentage' ? 'Percentage' : 'Flat Amount'),
              ],
            ),
          ),
          
          // Actions
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.gray50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.radius12),
                bottomRight: Radius.circular(AppTheme.radius12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TaartuButton(
                    onPressed: () => _editOffer(offer),
                    text: 'Edit',
                    variant: TaartuButtonVariant.outline,
                    size: TaartuButtonSize.small,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: TaartuButton(
                    onPressed: () => _deleteOffer(offer),
                    text: 'Delete',
                    variant: TaartuButtonVariant.danger,
                    size: TaartuButtonSize.small,
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
      padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToCreateOffer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateOfferScreen(),
      ),
    );
  }

  void _editOffer(Offer offer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOfferScreen(offer: offer),
      ),
    );
  }

  void _deleteOffer(Offer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Offer'),
        content: Text('Are you sure you want to delete the offer "${offer.code}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(offersProvider.notifier).deleteOffer(offer.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Offer "${offer.code}" deleted'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 