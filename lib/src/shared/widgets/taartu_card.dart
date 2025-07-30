import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

enum TaartuCardVariant {
  default_,
  elevated,
  outlined,
  filled,
  interactive,
}

enum TaartuCardSize {
  small,
  medium,
  large,
}

class TaartuCard extends StatefulWidget {
  final Widget child;
  final TaartuCardVariant variant;
  final TaartuCardSize size;
  final VoidCallback? onTap;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Widget? header;
  final Widget? footer;
  final List<Widget>? actions;

  const TaartuCard({
    super.key,
    required this.child,
    this.variant = TaartuCardVariant.default_,
    this.size = TaartuCardSize.medium,
    this.onTap,
    this.isLoading = false,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.header,
    this.footer,
    this.actions,
  });

  @override
  State<TaartuCard> createState() => _TaartuCardState();
}

class _TaartuCardState extends State<TaartuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Widget card = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? _getDefaultMargin(),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: widget.borderRadius ?? _getDefaultBorderRadius(),
              border: _getBorder(),
              boxShadow: _getBoxShadow(_elevationAnimation.value),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                if (widget.header != null) ...[
                  Container(
                    padding: _getHeaderPadding(),
                    decoration: BoxDecoration(
                      color: _getHeaderBackgroundColor(),
                      borderRadius: BorderRadius.only(
                        topLeft: (widget.borderRadius ?? _getDefaultBorderRadius()).topLeft,
                        topRight: (widget.borderRadius ?? _getDefaultBorderRadius()).topRight,
                      ),
                    ),
                    child: widget.header!,
                  ),
                ],
                
                // Content
                Container(
                  padding: widget.padding ?? _getDefaultPadding(),
                  child: widget.isLoading
                      ? _buildLoadingContent()
                      : widget.child,
                ),
                
                // Footer
                if (widget.footer != null) ...[
                  Container(
                    padding: _getFooterPadding(),
                    decoration: BoxDecoration(
                      color: _getFooterBackgroundColor(),
                      borderRadius: BorderRadius.only(
                        bottomLeft: (widget.borderRadius ?? _getDefaultBorderRadius()).bottomLeft,
                        bottomRight: (widget.borderRadius ?? _getDefaultBorderRadius()).bottomRight,
                      ),
                    ),
                    child: widget.footer!,
                  ),
                ],
                
                // Actions
                if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                  Container(
                    padding: _getActionsPadding(),
                    decoration: BoxDecoration(
                      color: _getActionsBackgroundColor(),
                      borderRadius: BorderRadius.only(
                        bottomLeft: (widget.borderRadius ?? _getDefaultBorderRadius()).bottomLeft,
                        bottomRight: (widget.borderRadius ?? _getDefaultBorderRadius()).bottomRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: widget.actions!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    // Add tap gesture if onTap is provided
    if (widget.onTap != null) {
      card = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: card,
      );
    }

    return card;
  }

  Widget _buildLoadingContent() {
    return Column(
      children: [
        // Shimmer loading effect
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.gray200,
            borderRadius: BorderRadius.circular(AppTheme.radius4),
          ),
        ),
        SizedBox(height: AppTheme.spacing8),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.gray200,
            borderRadius: BorderRadius.circular(AppTheme.radius4),
          ),
        ),
        SizedBox(height: AppTheme.spacing8),
        Container(
          height: 12,
          width: 200,
          decoration: BoxDecoration(
            color: AppTheme.gray200,
            borderRadius: BorderRadius.circular(AppTheme.radius4),
          ),
        ),
      ],
    );
  }

  Color _getBackgroundColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    
    switch (widget.variant) {
      case TaartuCardVariant.default_:
        return AppTheme.white;
      case TaartuCardVariant.elevated:
        return AppTheme.white;
      case TaartuCardVariant.outlined:
        return AppTheme.white;
      case TaartuCardVariant.filled:
        return AppTheme.gray50;
      case TaartuCardVariant.interactive:
        return AppTheme.white;
    }
  }

  Color _getHeaderBackgroundColor() {
    switch (widget.variant) {
      case TaartuCardVariant.default_:
        return AppTheme.gray50;
      case TaartuCardVariant.elevated:
        return AppTheme.gray50;
      case TaartuCardVariant.outlined:
        return AppTheme.gray50;
      case TaartuCardVariant.filled:
        return AppTheme.gray100;
      case TaartuCardVariant.interactive:
        return AppTheme.primary.withValues(alpha: 0.1);
    }
  }

  Color _getFooterBackgroundColor() {
    switch (widget.variant) {
      case TaartuCardVariant.default_:
        return AppTheme.gray50;
      case TaartuCardVariant.elevated:
        return AppTheme.gray50;
      case TaartuCardVariant.outlined:
        return AppTheme.gray50;
      case TaartuCardVariant.filled:
        return AppTheme.gray100;
      case TaartuCardVariant.interactive:
        return AppTheme.gray50;
    }
  }

  Color _getActionsBackgroundColor() {
    return AppTheme.gray50;
  }

  Border? _getBorder() {
    switch (widget.variant) {
      case TaartuCardVariant.default_:
        return Border.all(color: AppTheme.gray200, width: 1);
      case TaartuCardVariant.elevated:
        return null;
      case TaartuCardVariant.outlined:
        return Border.all(color: AppTheme.gray300, width: 1.5);
      case TaartuCardVariant.filled:
        return null;
      case TaartuCardVariant.interactive:
        return Border.all(color: AppTheme.primary.withValues(alpha: 0.2), width: 1);
    }
  }

  List<BoxShadow> _getBoxShadow(double elevation) {
    switch (widget.variant) {
      case TaartuCardVariant.default_:
        return [
          BoxShadow(
            color: AppTheme.gray200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      case TaartuCardVariant.elevated:
        return [
          BoxShadow(
            color: AppTheme.gray200.withValues(alpha: 0.8),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ];
      case TaartuCardVariant.outlined:
        return [];
      case TaartuCardVariant.filled:
        return [];
      case TaartuCardVariant.interactive:
        return [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (widget.size) {
      case TaartuCardSize.small:
        return const EdgeInsets.all(AppTheme.spacing12);
      case TaartuCardSize.medium:
        return const EdgeInsets.all(AppTheme.spacing16);
      case TaartuCardSize.large:
        return const EdgeInsets.all(AppTheme.spacing24);
    }
  }

  EdgeInsetsGeometry _getDefaultMargin() {
    switch (widget.size) {
      case TaartuCardSize.small:
        return const EdgeInsets.all(AppTheme.spacing4);
      case TaartuCardSize.medium:
        return const EdgeInsets.all(AppTheme.spacing8);
      case TaartuCardSize.large:
        return const EdgeInsets.all(AppTheme.spacing12);
    }
  }

  EdgeInsetsGeometry _getHeaderPadding() {
    switch (widget.size) {
      case TaartuCardSize.small:
        return const EdgeInsets.all(AppTheme.spacing12);
      case TaartuCardSize.medium:
        return const EdgeInsets.all(AppTheme.spacing16);
      case TaartuCardSize.large:
        return const EdgeInsets.all(AppTheme.spacing20);
    }
  }

  EdgeInsetsGeometry _getFooterPadding() {
    switch (widget.size) {
      case TaartuCardSize.small:
        return const EdgeInsets.all(AppTheme.spacing12);
      case TaartuCardSize.medium:
        return const EdgeInsets.all(AppTheme.spacing16);
      case TaartuCardSize.large:
        return const EdgeInsets.all(AppTheme.spacing20);
    }
  }

  EdgeInsetsGeometry _getActionsPadding() {
    switch (widget.size) {
      case TaartuCardSize.small:
        return const EdgeInsets.all(AppTheme.spacing8);
      case TaartuCardSize.medium:
        return const EdgeInsets.all(AppTheme.spacing12);
      case TaartuCardSize.large:
        return const EdgeInsets.all(AppTheme.spacing16);
    }
  }

  BorderRadius _getDefaultBorderRadius() {
    switch (widget.size) {
      case TaartuCardSize.small:
        return BorderRadius.circular(AppTheme.radius8);
      case TaartuCardSize.medium:
        return BorderRadius.circular(AppTheme.radius12);
      case TaartuCardSize.large:
        return BorderRadius.circular(AppTheme.radius16);
    }
  }

  // Service card for marketplace
  static Widget serviceCard({
    required String title,
    required String description,
    required String price,
    required String duration,
    String? imageUrl,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return TaartuCard(
      variant: isSelected ? TaartuCardVariant.interactive : TaartuCardVariant.default_,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(height: AppTheme.spacing12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppTheme.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: AppTheme.gray500),
                  SizedBox(width: AppTheme.spacing4),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray500,
                    ),
                  ),
                ],
              ),
              Text(
                'KSh $price',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Booking card
  static Widget bookingCard({
    required String providerName,
    required String service,
    required String date,
    required String time,
    required String price,
    required String status,
    VoidCallback? onTap,
  }) {
    return TaartuCard(
      variant: TaartuCardVariant.default_,
      onTap: onTap,
      header: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primary,
              child: Text(
                providerName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  Text(
                    service,
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
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(AppTheme.radius12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppTheme.gray500),
                  SizedBox(width: AppTheme.spacing4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppTheme.gray500),
                  SizedBox(width: AppTheme.spacing4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              Text(
                'KSh $price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Salon card for marketplace
  static Widget salonCard({
    required String name,
    required String location,
    required String rating,
    required String reviewCount,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return TaartuCard(
      variant: TaartuCardVariant.default_,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radius8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(height: AppTheme.spacing12),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          SizedBox(height: AppTheme.spacing4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppTheme.gray500),
              SizedBox(width: AppTheme.spacing4),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: AppTheme.warning),
              SizedBox(width: AppTheme.spacing4),
              Text(
                rating,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              SizedBox(width: AppTheme.spacing4),
              Text(
                '($reviewCount reviews)',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Notification card
  static Widget notificationCard({
    required String title,
    required String message,
    required String time,
    bool isRead = false,
    VoidCallback? onTap,
  }) {
    return TaartuCard(
      variant: TaartuCardVariant.default_,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isRead ? Colors.transparent : AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                SizedBox(height: AppTheme.spacing4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return AppTheme.success;
      case 'pending':
      case 'processing':
        return AppTheme.warning;
      case 'cancelled':
      case 'failed':
        return AppTheme.error;
      default:
        return AppTheme.info;
    }
  }
} 