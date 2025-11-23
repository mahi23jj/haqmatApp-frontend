import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

Widget _buildHeroImage(BuildContext context, Product product) {
  final vm = Provider.of<ProductViewModel>(context);
  final imagePath = product.images[vm.selectedImageIndex];

  Widget imageWidget;
  // If the path exists as a file, use Image.file, otherwise fallback.
  try {
    if (File(imagePath).existsSync()) {
      imageWidget = Image.file(File(imagePath), fit: BoxFit.cover);
    } else {
      imageWidget = Image.asset('assets/placeholder.png', fit: BoxFit.cover);
    }
  } catch (e) {
    imageWidget = Image.asset('assets/placeholder.png', fit: BoxFit.cover);
  }

  return Hero(
    tag: product.id,
    child: Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(child: imageWidget),
          // pagination dots
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(product.images.length, (i) {
                final isActive = i == vm.selectedImageIndex;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 10 : 8,
                  height: isActive ? 10 : 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.white70,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ),
  );
}
