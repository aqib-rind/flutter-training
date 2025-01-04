import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BookCard extends StatelessWidget {
  final String bookName;

  const BookCard({
    super.key,
    required this.bookName,
  });

  // List of 6 predefined gradient colors
  static final List<List<Color>> _gradientColors = [
    [const Color(0xFF1E88E5), const Color(0xFF1565C0)], // Medium Blue gradient
    [const Color(0xFF6A1B9A), const Color(0xFF4A148C)], // Medium Purple gradient
    [const Color(0xFFD84315), const Color(0xFFBF360C)], // Medium Orange gradient
    [const Color(0xFF388E3C), const Color(0xFF2E7D32)], // Medium Green gradient
    [const Color(0xFFC62828), const Color(0xFFB71C1C)], // Medium Red gradient
    [const Color(0xFF00695C), const Color(0xFF004D40)], // Medium Teal gradient
  ];

  @override
  Widget build(BuildContext context) {
    // Randomly select a gradient from the list
    final gradient = _gradientColors[Random().nextInt(_gradientColors.length)];

    return Container(
      width: 150,
      height: 220,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Center(
          child: AutoSizeText(
            bookName,
            textAlign: TextAlign.center,
            maxLines: 6,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 12,
            maxFontSize: 16,
          ),
        ),
      ),
    );
  }
}
