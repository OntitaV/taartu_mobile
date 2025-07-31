import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

class TaartuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final VoidCallback? onBackPressed;

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
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null 
        ? Text(title!)
        : Image.asset(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 