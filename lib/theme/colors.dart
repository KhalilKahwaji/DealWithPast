import 'package:flutter/material.dart';


class AppColors {
  // Brand
  static const Color primary = Color(0xFFD11F2E); // red
  static const Color primarySoft = Color(0xFFEF4444);

  // Surfaces
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF6F7F9);
  static const Color card = Colors.white;

  // Text
  static const Color text = Color(0xFF111827);     // near-black
  static const Color muted = Color(0xFF6B7280);    // gray-500

  // Lines
  static const Color border = Color(0xFFE5E7EB);   // gray-200

  // Shadows (very soft)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
  ];
}
