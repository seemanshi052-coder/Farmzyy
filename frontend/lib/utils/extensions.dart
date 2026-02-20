import 'package:flutter/material.dart';

/// Extension methods for common operations
extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Check if string is a valid number
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  /// Truncate string to length with ellipsis
  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }
}

/// Extension methods for BuildContext
extension ContextExtension on BuildContext {
  /// Get screen width
  double get width => MediaQuery.of(this).size.width;

  /// Get screen height
  double get height => MediaQuery.of(this).size.height;

  /// Check if device is in portrait mode
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if device is in landscape mode
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Get screen padding (for notch/safe area)
  EdgeInsets get screenPadding => MediaQuery.of(this).padding;

  /// Get screen view insets (for keyboards)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Get bottom padding for keyboard or notch
  double get bottomPadding => viewInsets.bottom + screenPadding.bottom;

  /// Navigate to a new screen
  Future<T?> navigateTo<T>(Widget screen) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Navigate and replace current screen
  Future<T?> navigateAndReplace<T>(Widget screen) {
    return Navigator.pushReplacement<T, T>(
      this,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  /// Pop current screen
  void pop<T>([T? result]) => Navigator.pop(this, result);
}

/// Extension methods for num
extension NumExtension on num {
  /// Format number to fixed decimal places
  String toStringAsFixedNumber(int decimals) {
    return toStringAsFixed(decimals);
  }
}

/// Extension methods for Duration
extension DurationExtension on Duration {
  /// Convert duration to formatted string (HH:MM:SS)
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
