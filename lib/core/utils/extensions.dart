import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

extension DoubleExtension on double {
  String toCelsiusDisplay() {
    return '${round()}°';
  }

  String toSpeedDisplay() {
    return '${toStringAsFixed(1)} m/s';
  }

  String toPressureDisplay() {
    return '${round()} hPa';
  }
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
