import 'package:flutter/material.dart';
import 'package:haqmate/core/widgets/app_shimmer.dart';

class CartLoadingSkeleton extends StatelessWidget {
  final int itemCount;
  const CartLoadingSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _CartSkeletonItem(),
      ),
    );
  }
}

class _CartSkeletonItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade300,
              ),
            ),

            const SizedBox(width: 12),

            // Text lines placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(width: 140, height: 14),
                  const SizedBox(height: 6),
                  _line(width: 100, height: 10),
                  const SizedBox(height: 6),
                  _line(width: 80, height: 12),
                ],
              ),
            ),

            // Quantity controls placeholder
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(31, 182, 127, 26),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _circle(size: 18),
                  const SizedBox(height: 6),
                  _line(width: 24, height: 12),
                  const SizedBox(height: 6),
                  _circle(size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line({required double width, required double height}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      );

  Widget _circle({required double size}) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      );
}
