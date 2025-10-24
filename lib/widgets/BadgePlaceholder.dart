// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// Placeholder widget for badge/level icons while actual icons are being generated
class BadgePlaceholder extends StatelessWidget {
  final String name;
  final Color color;
  final double size;

  const BadgePlaceholder({
    Key? key,
    required this.name,
    required this.color,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.3,
            fontWeight: FontWeight.bold,
            fontFamily: 'Baloo',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    // Extract first two characters or first letter
    final cleaned = name.replaceAll('.png', '').replaceAll('_', ' ');
    final words = cleaned.split(' ');

    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (cleaned.length >= 2) {
      return cleaned.substring(0, 2).toUpperCase();
    } else {
      return cleaned[0].toUpperCase();
    }
  }
}
