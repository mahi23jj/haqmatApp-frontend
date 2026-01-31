// import 'package:flutter/material.dart';
// import 'package:haqmate/features/home/models/product.dart';
// import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
// import 'package:haqmate/features/product_detail/views/product_view.dart';
// import 'package:provider/provider.dart';

// class FlashSaleItem extends StatelessWidget {
//   final ProductModel product;
//   const FlashSaleItem({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async{

//         /* await context.read<ProductViewModel>().load(product.id); */

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailPage(productid: product.id),
//           ),
//         );
//       },
//       child: Container(
//         width: 170,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 10,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16),
//               ),
//               child: Image.asset(
//                 'assets/images/teff.jpg',
//                 // product.imageUrl,
//                 height: 140,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '\$${product.price.toStringAsFixed(2)}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       InkWell(
//                         onTap: () {},
//                         child: const Icon(Icons.favorite_border),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/home/models/product.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/views/product_view.dart';
import 'package:provider/provider.dart';

class FlashSaleItem extends StatelessWidget {
  final ProductModel product;
  const FlashSaleItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productid: product.id),
          ),
        );
      },
      child: Container(
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    'assets/images/teff.jpg',
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
               /*  Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      onPressed: () {
                        // Add to favorites
                      },
                    ),
                  ),
                ), */
                // Discount badge
                /*   if (product.discount != null && product.discount! > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ), */
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Row(
                    children: [
                      Text(
                        'ብር${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 4),
                     /*  if (product.price != null)
                        Text(
                          'ብር${product.price!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ), */
                    ],
                  ),

                  // const SizedBox(height: 8),

                  // Rating
                 /*  Row(
                    children: [
                      /*   Icon(
                        Icons.star,
                        color: Colors.amber.shade600,
                        size: 16,
                      ), */
                      // const SizedBox(width: 4),
                      /*  Text(
                        product.rating?.toStringAsFixed(1) ?? '4.5',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ), */
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ያስቀምጡ',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
