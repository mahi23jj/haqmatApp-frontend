// import 'package:flutter/material.dart';
// import 'package:haqmate/features/home/models/product.dart';

// class ProductSearchCard extends StatelessWidget {
//   final ProductModel product;

//   const ProductSearchCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ListTile(
//         leading: product.imageUrl.isNotEmpty
//             ? Image.network(
//                 product.imageUrl,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               )
//             : const Icon(Icons.image_not_supported),
//         title: Text(product.name),
//        /*  subtitle: Text(
//           '${product.}${product.quality != null ? ' • ${product.quality}' : ''}',
//         ), */
//         trailing: Text(
//           '${product.price} ETB',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         onTap: () {
//           // Navigate to product details
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/home/models/product.dart';

class ProductSearchCard extends StatelessWidget {
  final ProductModel product;

  const ProductSearchCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Stack(
          children: [
            // Main Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Product Image
                  _buildProductImage(),
                  
                  // Product Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name and Type
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                              fontFamily: 'Ethiopia',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Quality and Origin
                   /*        if (product.quality != null || product.origin != null)
                            Text(
                              _buildProductSubtitle(),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                                fontFamily: 'Ethiopia',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ) */
                          
                          // const SizedBox(height: 8),
                          
                          // Price and Rating Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              Text(
                                '${product.price.toStringAsFixed(2)} ብር',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  fontFamily: 'Ethiopia',
                                ),
                              ),
                              
                              // Rating
                              /* if (product.rating != null && product.rating! > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: AppColors.accent,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        product.rating!.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ), */
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Stock Status and Add Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Stock Status
                  /*             Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStockColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.inventory_2_rounded,
                                      color: _getStockColor(),
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getStockStatus(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: _getStockColor(),
                                        fontFamily: 'Ethiopia',
                                      ),
                                    ),
                                  ],
                                ),
                              ), */
                              
                              // Add to Cart Button
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Favorite Button
         /*    if (product.isFavorite != null && product.isFavorite!)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ),
            
            // Discount Badge
            if (product.discount != null && product.discount! > 0)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '-${product.discount!.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ), */
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 120,
      height: 140,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: product.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.05),
                  BlendMode.darken,
                ),
              )
            : null,
        color: product.imageUrl.isEmpty
            ? AppColors.background
            : AppColors.primary.withOpacity(0.05),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: product.imageUrl.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grain_rounded,
                    color: AppColors.primary,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'የተፍ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontFamily: 'Ethiopia',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.textLight,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ምስል አልተገኘም',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 10,
                            fontFamily: 'Ethiopia',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _buildProductSubtitle() {
    final List<String> parts = [];
    
 /*    if (product.quality != null && product.quality!.isNotEmpty) {
      parts.add('ጥራት: ${product.quality!}');
    } */
    
    if (product.teffType != null && product.teffType!.isNotEmpty) {
      parts.add('ዓይነት: ${product.teffType!}');
    }
    
 /*    if (product.origin != null && product.origin!.isNotEmpty) {
      parts.add('አመጣጥ: ${product.origin!}');
    } */
    
    return parts.join(' • ');
  }

  // Color _getStockColor() {
  //   // if (product.stockQuantity == null || product.stockQuantity! <= 0) {
  //   //   return Colors.red;
  //   // } else if (product.stockQuantity! < 10) {
  //   //   return Colors.orange;
  //   // } else {
  //   //   return Colors.green;
  //   // }
  // }

  // String _getStockStatus() {
  //   if (product.stockQuantity == null || product.stockQuantity! <= 0) {
  //     return 'ባዶ';
  //   } else if (product.stockQuantity! < 10) {
  //     return 'ጥቂት ቀርቷል';
  //   } else {
  //     return 'ሙሉ ክምችት';
  //   }
  // }

  // Optional: If you want to show original price when there's a discount
  Widget _buildPriceWithDiscount(double price, double? discount) {
    if (discount == null || discount <= 0) {
      return Text(
        '${price.toStringAsFixed(2)} ብር',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          fontFamily: 'Ethiopia',
        ),
      );
    }

    final discountedPrice = price - (price * discount / 100);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${discountedPrice.toStringAsFixed(2)} ብር',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            fontFamily: 'Ethiopia',
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              '${price.toStringAsFixed(2)} ብር',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${discount.toStringAsFixed(0)}% ቅናሽ',
              style: TextStyle(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontFamily: 'Ethiopia',
              ),
            ),
          ],
        ),
      ],
    );
  }
}