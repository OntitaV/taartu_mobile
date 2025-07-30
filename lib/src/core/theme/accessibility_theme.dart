import 'package:flutter/material.dart';
import 'package:taartu_mobile/src/core/theme/app_theme.dart';

class AccessibilityTheme {
  // Colorblind-friendly color palette
  static const Map<String, Color> colorblindFriendlyColors = {
    'primary': Color(0xFF1F77B4),    // Blue
    'secondary': Color(0xFF2CA02C),  // Green
    'accent': Color(0xFFFF7F0E),     // Orange
    'warning': Color(0xFFD62728),    // Red
    'info': Color(0xFF9467BD),       // Purple
    'success': Color(0xFF8C564B),    // Brown
  };

  // High contrast colors
  static const Map<String, Color> highContrastColors = {
    'primary': Color(0xFF000080),    // Navy Blue
    'secondary': Color(0xFF006400),  // Dark Green
    'accent': Color(0xFF8B0000),     // Dark Red
    'warning': Color(0xFF8B0000),    // Dark Red
    'info': Color(0xFF4B0082),       // Indigo
    'success': Color(0xFF006400),    // Dark Green
  };

  // Font sizes for accessibility
  static const Map<String, double> accessibleFontSizes = {
    'small': 14.0,
    'medium': 16.0,
    'large': 18.0,
    'xlarge': 20.0,
    'xxlarge': 24.0,
  };

  // Spacing for accessibility
  static const Map<String, double> accessibleSpacing = {
    'small': 8.0,
    'medium': 12.0,
    'large': 16.0,
    'xlarge': 24.0,
    'xxlarge': 32.0,
  };

  // Minimum touch target size (44x44 points)
  static const double minTouchTargetSize = 44.0;

  // High contrast theme
  static ThemeData get highContrastTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: highContrastColors['primary']!,
        brightness: Brightness.light,
        primary: highContrastColors['primary']!,
        secondary: highContrastColors['secondary']!,
        error: highContrastColors['warning']!,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      textTheme: _getAccessibleTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highContrastColors['primary']!,
          foregroundColor: Colors.white,
          minimumSize: const Size(44.0, 44.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: highContrastColors['primary']!, width: 3),
        ),
        contentPadding: const EdgeInsets.all(12.0),
      ),
    );
  }

  // Colorblind-friendly theme
  static ThemeData get colorblindFriendlyTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorblindFriendlyColors['primary']!,
        brightness: Brightness.light,
        primary: colorblindFriendlyColors['primary']!,
        secondary: colorblindFriendlyColors['secondary']!,
        error: colorblindFriendlyColors['warning']!,
        surface: Colors.white,
      ),
      textTheme: _getAccessibleTextTheme(),
    );
  }

  static TextTheme _getAccessibleTextTheme() {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: accessibleFontSizes['xxlarge']!,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: accessibleFontSizes['xlarge']!,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        fontSize: accessibleFontSizes['large']!,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.4,
      ),
      headlineLarge: TextStyle(
        fontSize: accessibleFontSizes['large']!,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontSize: accessibleFontSizes['medium']!,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.5,
      ),
      headlineSmall: TextStyle(
        fontSize: accessibleFontSizes['medium']!,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.5,
      ),
      titleLarge: TextStyle(
        fontSize: accessibleFontSizes['medium']!,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontSize: accessibleFontSizes['medium']!,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: accessibleFontSizes['small']!,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontSize: accessibleFontSizes['medium']!,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: accessibleFontSizes['medium']!,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: accessibleFontSizes['small']!,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      ),
    );
  }
}

// Accessibility utilities
class AccessibilityUtils {
  // Check if color meets WCAG contrast requirements
  static bool meetsContrastRatio(Color foreground, Color background, double ratio) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();
    
    final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
    final darkest = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (brightest + 0.05) / (darkest + 0.05) >= ratio;
  }

  // Get accessible text color for background
  static Color getAccessibleTextColor(Color backgroundColor) {
    const white = Colors.white;
    const black = Colors.black;
    
    final whiteContrast = (backgroundColor.computeLuminance() + 0.05) / (white.computeLuminance() + 0.05);
    final blackContrast = (backgroundColor.computeLuminance() + 0.05) / (black.computeLuminance() + 0.05);
    
    return whiteContrast > blackContrast ? white : black;
  }

  // Create semantic color for status
  static Color getSemanticColor(String status, {bool colorblindFriendly = false}) {
    final colors = colorblindFriendly ? AccessibilityTheme.colorblindFriendlyColors : {
      'success': AppTheme.success,
      'warning': AppTheme.warning,
      'error': AppTheme.error,
      'info': AppTheme.info,
      'primary': AppTheme.primary,
      'secondary': AppTheme.secondary,
    };

    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'approved':
        return colors['success']!;
      case 'warning':
      case 'pending':
      case 'processing':
        return colors['warning']!;
      case 'error':
      case 'cancelled':
      case 'failed':
        return colors['error']!;
      case 'info':
      case 'upcoming':
      case 'active':
        return colors['info']!;
      default:
        return colors['primary']!;
    }
  }

  // Get accessible icon for status
  static IconData getSemanticIcon(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'approved':
        return Icons.check_circle;
      case 'warning':
      case 'pending':
      case 'processing':
        return Icons.warning;
      case 'error':
      case 'cancelled':
      case 'failed':
        return Icons.error;
      case 'info':
      case 'upcoming':
      case 'active':
        return Icons.info;
      default:
        return Icons.circle;
    }
  }

  // Get accessible label for screen readers
  static String getAccessibleLabel(String status, String context) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return '$context completed successfully';
      case 'warning':
      case 'pending':
        return '$context is pending';
      case 'error':
      case 'cancelled':
        return '$context was cancelled';
      case 'info':
      case 'upcoming':
        return '$context is upcoming';
      default:
        return '$context status: $status';
    }
  }

  // Get accessible hint for interactive elements
  static String getAccessibleHint(String action, String target) {
    switch (action.toLowerCase()) {
      case 'tap':
      case 'press':
        return 'Double tap to $target';
      case 'swipe':
        return 'Swipe to $target';
      case 'scroll':
        return 'Scroll to $target';
      default:
        return '$action to $target';
    }
  }
}

// Accessibility utilities for widgets
class AccessibilityWidgets {
  // Build accessible widget
  static Widget buildAccessible({
    required Widget child,
    String? label,
    String? hint,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }

  // Build accessible button
  static Widget buildAccessibleButton({
    required VoidCallback? onPressed,
    required Widget child,
    String? label,
    String? hint,
    bool isEnabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: isEnabled,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: child,
      ),
    );
  }

  // Build accessible input
  static Widget buildAccessibleInput({
    required Widget child,
    String? label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: child,
    );
  }
}

// Accessibility provider for app-wide settings
class AccessibilityProvider extends ChangeNotifier {
  bool _highContrast = false;
  bool _colorblindFriendly = false;
  bool _largeText = false;
  bool _reduceMotion = false;
  String _language = 'en';

  bool get highContrast => _highContrast;
  bool get colorblindFriendly => _colorblindFriendly;
  bool get largeText => _largeText;
  bool get reduceMotion => _reduceMotion;
  String get language => _language;

  void toggleHighContrast() {
    _highContrast = !_highContrast;
    notifyListeners();
  }

  void toggleColorblindFriendly() {
    _colorblindFriendly = !_colorblindFriendly;
    notifyListeners();
  }

  void toggleLargeText() {
    _largeText = !_largeText;
    notifyListeners();
  }

  void toggleReduceMotion() {
    _reduceMotion = !_reduceMotion;
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  ThemeData getCurrentTheme() {
    if (_highContrast) {
      return AccessibilityTheme.highContrastTheme;
    } else if (_colorblindFriendly) {
      return AccessibilityTheme.colorblindFriendlyTheme;
    } else {
      return AppTheme.lightTheme;
    }
  }

  Duration getAnimationDuration() {
    return _reduceMotion ? Duration.zero : AppTheme.animationNormal;
  }
} 