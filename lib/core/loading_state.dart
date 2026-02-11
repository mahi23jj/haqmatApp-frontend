import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ምርቶች በመጫን ላይ...',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontFamily: 'Ethiopia',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'እባክዎ ይጠብቁ',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildLoadingState();
  }
}