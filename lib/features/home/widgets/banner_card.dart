// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';



// class BannerCard extends StatelessWidget {
// final ImageProvider imageProvider;
// const BannerCard({Key? key, required this.imageProvider}) : super(key: key);


// @override
// Widget build(BuildContext context) {
// return Container(
// margin: const EdgeInsets.symmetric(vertical: 6),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(16),
// image: DecorationImage(image: imageProvider, fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken)),
// boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0,6))],
// ),
// padding: const EdgeInsets.all(16),
// child: Align(
// alignment: Alignment.centerLeft,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(
// padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.95), borderRadius: BorderRadius.circular(8)),
// child: const Text('New Collection', style: TextStyle(fontWeight: FontWeight.bold)),
// ),
// const SizedBox(height: 8),
// const Text('Discount 50% for the first transaction', style: TextStyle(color: Colors.white70)),
// const SizedBox(height: 12),
// ElevatedButton(
// style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
// onPressed: () {},
// child: const Text('Shop Now'),
// )
// ],
// ),
// ),
// );
// }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class BannerCard extends StatelessWidget {
  final ImageProvider imageProvider;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color color;
  
  const BannerCard({
    Key? key, 
    required this.imageProvider,
    this.title = 'አዲስ ስብስብ',
    this.subtitle = 'ልዩ ቅናሽ 50%',
    this.buttonText = 'አሁን ይግዙ',
    this.color = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: imageProvider, 
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ለመጀመሪያ ግዢ ብቻ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: () {
                // Handle shop now
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}