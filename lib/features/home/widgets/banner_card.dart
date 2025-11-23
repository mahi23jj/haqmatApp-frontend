import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';



class BannerCard extends StatelessWidget {
final ImageProvider imageProvider;
const BannerCard({Key? key, required this.imageProvider}) : super(key: key);


@override
Widget build(BuildContext context) {
return Container(
margin: const EdgeInsets.symmetric(vertical: 6),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(16),
image: DecorationImage(image: imageProvider, fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken)),
boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0,6))],
),
padding: const EdgeInsets.all(16),
child: Align(
alignment: Alignment.centerLeft,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.95), borderRadius: BorderRadius.circular(8)),
child: const Text('New Collection', style: TextStyle(fontWeight: FontWeight.bold)),
),
const SizedBox(height: 8),
const Text('Discount 50% for the first transaction', style: TextStyle(color: Colors.white70)),
const SizedBox(height: 12),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
onPressed: () {},
child: const Text('Shop Now'),
)
],
),
),
);
}
}