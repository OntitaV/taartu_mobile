import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

class TaartuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  const TaartuAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onBackPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? Image.asset(
        'assets/logos/logo_secondary.png',
        height: 32,
        fit: BoxFit.contain,
      ),
      actions: actions,
      leading: leading ?? (automaticallyImplyLeading && onBackPressed != null
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed,
          )
        : null),
      automaticallyImplyLeading: automaticallyImplyLeading && onBackPressed == null,
      backgroundColor: backgroundColor ?? AppTheme.white,
      foregroundColor: foregroundColor ?? AppTheme.gray900,
      elevation: elevation ?? 0,
      centerTitle: true,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)
  );
} 