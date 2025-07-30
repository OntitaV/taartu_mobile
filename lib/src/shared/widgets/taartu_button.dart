import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

enum TaartuButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
}

enum TaartuButtonSize {
  small,
  medium,
  large,
}

class TaartuButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TaartuButtonVariant variant;
  final TaartuButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? trailingIcon;

  const TaartuButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = TaartuButtonVariant.primary,
    this.size = TaartuButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.trailingIcon,
  });

  @override
  State<TaartuButton> createState() => _TaartuButtonState();
}

class _TaartuButtonState extends State<TaartuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget button;
    
    switch (widget.variant) {
      case TaartuButtonVariant.primary:
        button = ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getButtonStyle(theme),
          child: _buildButtonContent(),
        );
        break;
      case TaartuButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getSecondaryButtonStyle(theme),
          child: _buildButtonContent(),
        );
        break;
      case TaartuButtonVariant.outline:
        button = OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getOutlineButtonStyle(theme),
          child: _buildButtonContent(),
        );
        break;
      case TaartuButtonVariant.text:
        button = TextButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getTextButtonStyle(theme),
          child: _buildButtonContent(),
        );
        break;
      case TaartuButtonVariant.danger:
        button = ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: _getDangerButtonStyle(theme),
          child: _buildButtonContent(),
        );
        break;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: SizedBox(
              width: widget.isFullWidth ? double.infinity : null,
              child: button,
            ),
          ),
        );
      },
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primary,
      foregroundColor: AppTheme.white,
      elevation: 0,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  ButtonStyle _getSecondaryButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.secondary,
      foregroundColor: AppTheme.white,
      elevation: 0,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  ButtonStyle _getOutlineButtonStyle(ThemeData theme) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppTheme.primary,
      side: const BorderSide(color: AppTheme.primary, width: 1.5),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  ButtonStyle _getTextButtonStyle(ThemeData theme) {
    return TextButton.styleFrom(
      foregroundColor: AppTheme.primary,
      padding: _getPadding(),
      textStyle: _getTextStyle(theme),
    );
  }

  ButtonStyle _getDangerButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.error,
      foregroundColor: AppTheme.white,
      elevation: 0,
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case TaartuButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing8,
        );
      case TaartuButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing24,
          vertical: AppTheme.spacing12,
        );
      case TaartuButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing32,
          vertical: AppTheme.spacing16,
        );
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (widget.size) {
      case TaartuButtonSize.small:
        return theme.textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
        );
      case TaartuButtonSize.medium:
        return theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
        );
      case TaartuButtonSize.large:
        return theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.variant == TaartuButtonVariant.outline || 
            widget.variant == TaartuButtonVariant.text
                ? AppTheme.primary
                : AppTheme.white,
          ),
        ),
      );
    }

    final children = <Widget>[];

    if (widget.icon != null) {
      children.add(
        Icon(
          widget.icon,
          size: _getIconSize(),
        ),
      );
      children.add(SizedBox(width: AppTheme.spacing8));
    }

    children.add(Text(widget.text));

    if (widget.trailingIcon != null) {
      children.add(SizedBox(width: AppTheme.spacing8));
      children.add(widget.trailingIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case TaartuButtonSize.small:
        return 16;
      case TaartuButtonSize.medium:
        return 20;
      case TaartuButtonSize.large:
        return 24;
    }
  }
} 