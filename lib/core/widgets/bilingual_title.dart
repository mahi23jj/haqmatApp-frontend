import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class BilingualTitle extends StatelessWidget {
  final String amharic;
  final String english;
  final TextAlign textAlign;

  const BilingualTitle({
    super.key,
    required this.amharic,
    required this.english,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          amharic,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          english,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
