// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/product_detail/model/products.dart';
// import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
// import 'package:haqmate/features/product_detail/widgets/add_to_cart.dart';
// import 'package:haqmate/features/review/view/review_screen.dart';
// import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
// import 'package:haqmate/features/review/widget/review_list.dart';
// import 'package:haqmate/features/review/widget/write_review.dart';
// import 'package:provider/provider.dart';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:haqmate/core/widgets/custom_button.dart';

// class ProductDetailPage extends StatefulWidget {
//   final String productid;
//   const ProductDetailPage({super.key, required this.productid});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   final _scrollController = ScrollController();

//   void _openWriteReviewSheet(BuildContext context, String productId) async {
//     final result = await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
//       ),
//       builder: (ctx) => Padding(
//         padding: MediaQuery.of(ctx).viewInsets,
//         child: WriteReviewSheet(productId: productId),
//       ),
//     );

//     if (result == 'review_success') {
//       Flushbar(
//         message: 'Review submitted successfully',
//         backgroundColor: Colors.green.shade600,
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(12),
//         borderRadius: BorderRadius.circular(12),
//       ).show(context);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     print('product id in detail page: ${widget.productid}');
//     // Run AFTER the first frame so notifyListeners is safe
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProductViewModel>().load(widget.productid);
//     });
//   }

//   // dispose()
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<ProductViewModel>();

//     // 1️⃣ LOADING SCREEN
//     if (vm.loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     // 2️⃣ NO PRODUCT FOUND
//     if (vm.product == null) {
//       return const Scaffold(body: Center(child: Text("No product found")));
//     }

//     // 3️⃣ SAFE — product is guaranteed non-null here
//     final product = vm.product!;

//     return Scaffold(
//       body: Stack(
//         children: [
//           CustomScrollView(
//             controller: _scrollController,
//             slivers: [
//               SliverAppBar(
//                 backgroundColor: AppColors.background,
//                 expandedHeight: 500,
//                 pinned: true,
//                 elevation: 0,
//                 leading: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     // padding: EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       color: AppColors.background,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: BackButton(color: AppColors.textDark),
//                   ),
//                 ),
//                 actions: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       // padding: EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         color: AppColors.background,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.shopping_cart_outlined,
//                           color: AppColors.textDark,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ),
//                 ],
//                 flexibleSpace: LayoutBuilder(
//                   builder: (context, constraints) {
//                     final top = constraints.biggest.height;
//                     // parallax effect: compute image movement
//                     return FlexibleSpaceBar(
//                       background: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           _buildHeroImage(context, product),
//                           // gradient overlay for readability
//                           Positioned.fill(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.white.withOpacity(0.6),
//                                   ],
//                                   stops: [0.6, 1.0],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               /* SliverToBoxAdapter(
//             child: SizedBox(height: 380),
//           ), */
//             ],
//           ),
//           Positioned(
//             top: 400,
//             left: 0,
//             right: 0,
//             bottom: 0,
//             // to make it curve on top of the image
//             child: Container(
//               // margin: EdgeInsets.only(top: -30),
//               decoration: BoxDecoration(
//                 color: AppColors.background, // white/off-white background
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(32),
//                   topRight: Radius.circular(32),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, -3),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 // no need to side scroll bar , just smooth scroll
//                 physics: BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 25,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildHeaderSection(vm),
//                       // SizedBox(height: 12),
//                       // _buildTagPills(vm),
//                       SizedBox(height: 12),
//                       _buildWeightOptions(context, vm),
//                       /*                SizedBox(height: 16),
//                         _buildDeliveryAndLocation(vm), */
//                       SizedBox(height: 30),
//                       _buildDescription(vm),

//                       SizedBox(height: 12),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Reviews',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           IconButton(
//                             onPressed: () =>
//                                 _openWriteReviewSheet(context, product.id),
//                             icon: Icon(Icons.wifi_protected_setup_sharp),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 9),

//                       /* if (product.reviews.isEmpty)
//                         const Center(child: Text('No reviews yet')),

//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.only(bottom: 20),
//                         itemBuilder: (ctx, index) {
//                           final r = product.reviews[index];
//                           return AnimatedReviewCard(review: r, index: index);
//                         },
//                         separatorBuilder: (_, __) => const SizedBox(height: 12),
//                         itemCount: product.reviews.length,
//                       ), */
//                       if (product.allReviews.isEmpty)
//                         const Center(child: Text('No reviews yet')),

//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.only(bottom: 20),
//                         itemBuilder: (ctx, index) {
//                           final r = product.allReviews[index];
//                           return AnimatedReviewCard(review: r, index: index);
//                         },
//                         separatorBuilder: (_, __) => const SizedBox(height: 12),
//                         itemCount: product.allReviews.length,
//                       ),

//                       Center(
//                         child: CustomButton(
//                           label: 'Read More Reviews',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ReviewsPage(productid: product.id),
//                               ),
//                             );
//                           },
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 50,
//                           ),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),

//                       /*           SizedBox(height: 16),
//                         _buildProductsList(vm), */
//                       // SizedBox(height: 0), // leave space for bottom bar
//                       SizedBox(height: 90), // leave space for bottom bar
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // on bottom
//           Positioned(
//             child: StickyAddToCartBar(),
//             bottom: 15,
//             left: 15,
//             right: 15,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeroImage(BuildContext context, Product product) {
//     final vm = Provider.of<ProductViewModel>(context);
//     final imagePath = product.images[vm.selectedImageIndex];

//     Widget imageWidget;
//     // If the path exists as a file, use Image.file, otherwise fallback.
//     try {
//       /*    if (File(imagePath).existsSync()) {
//         imageWidget = Image.asset(imagePath), fit: BoxFit.cover);
//       } else {
        
//       } */
//       imageWidget = Image.asset('assets/images/teff.jpg', fit: BoxFit.cover);
//     } catch (e) {
//       imageWidget = Image.asset('assets/placeholder.jpg', fit: BoxFit.cover);
//     }

//     return Hero(
//       tag: "product_${widget.productid}",
//       child: Container(
//         color: Colors.white,
//         child: Stack(
//           children: [
//             Positioned.fill(child: imageWidget),
//             // pagination dots
//             Positioned(
//               bottom: 8,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(product.images.length, (i) {
//                   final isActive = i == vm.selectedImageIndex;
//                   return AnimatedContainer(
//                     duration: Duration(milliseconds: 300),
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: isActive ? 10 : 8,
//                     height: isActive ? 10 : 8,
//                     decoration: BoxDecoration(
//                       color: isActive ? AppColors.primary : Colors.white70,
//                       shape: BoxShape.circle,
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(ProductViewModel vm) {
//     final product = vm.product!;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 product.name,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               SizedBox(height: 6),
//               Row(
//                 children: [
//                   SizedBox(
//                     height: 15,
//                     child: ListView.separated(
//                       separatorBuilder: (context, index) {
//                         return SizedBox(width: 2);
//                       },
//                       itemCount: product.rating.toInt(),
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) =>
//                           Icon(Icons.star, color: Colors.amber, size: 18),
//                     ),
//                   ),
//                   SizedBox(width: 6),
//                   Text(
//                     '${product.rating} (${product.reviewsCount}  Reviews)',
//                     style: TextStyle(color: AppColors.textDark),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   _quantityButton(Icons.remove, () => vm.prevQuantity()),
//                   SizedBox(width: 8),
//                   Text(
//                     vm.quantity.toString(),
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(width: 8),
//                   _quantityButton(Icons.add, () => vm.nextQuantity()),
//                 ],
//               ),
//             ),
//             SizedBox(height: 12),

//             SizedBox(width: 12),
//             _buildStockPill(product.inStock),
//             /* Text(
//               'Total: \${vm.price.toStringAsFixed(2)} ETB',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//               ),
//             ), */
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStockPill(bool inStock) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       /*  decoration: BoxDecoration(
//         color: inStock ? Colors.green.shade50 : Colors.red.shade50,
//         borderRadius: BorderRadius.circular(20),
//       ), */
//       child: Text(
//         inStock ? 'Available in Stock' : 'Not Available in Stock',
//         style: TextStyle(
//           color: inStock ? Colors.green.shade800 : Colors.red.shade800,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _quantityButton(IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Icon(icon, size: 18, color: AppColors.textDark),
//       ),
//     );
//   }

//   Widget _buildTagPills(ProductViewModel vm) {
//     final tags = ['Accessories', 'Premium', 'Organic', 'Delivery'];
//     return Wrap(
//       spacing: 8,
//       children: tags
//           .map(
//             (t) => ActionChip(
//               backgroundColor: Colors.white,
//               label: Text(t, style: TextStyle(color: AppColors.textDark)),
//               onPressed: () {},
//             ),
//           )
//           .toList(),
//     );
//   }

//   // Widget _buildWeightOptions(ProductViewModel vm) {
//   //   final weights = vm.weights;
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text('Weight', style: TextStyle(fontWeight: FontWeight.bold)),
//   //       SizedBox(height: 15),
//   //       Row(
//   //         children: List.generate(weights.length + 1, (i) {
//   //           final isSelected = i == vm.selectedWeightIndex;

//   //           if (i == weights.length) {
//   //             return GestureDetector(
//   //               onTap: () => vm.selectWeight(i),
//   //               child: AnimatedContainer(
//   //                 duration: Duration(milliseconds: 250),
//   //                 margin: EdgeInsets.only(right: 8),
//   //                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//   //                 decoration: BoxDecoration(
//   //                   color: isSelected ? AppColors.primary : Colors.white,
//   //                   // to make perfect circle
//   //                   borderRadius: BorderRadius.circular(50),
//   //                   border: Border.all(color: Colors.grey.shade200),
//   //                 ),
//   //                 child: Text(
//   //                   'Custom',
//   //                   style: TextStyle(
//   //                     color: isSelected ? Colors.white : AppColors.textDark,
//   //                   ),
//   //                 ),
//   //               ),
//   //             );
//   //           }
//   //           final option = weights[i];
//   //           return GestureDetector(
//   //             onTap: () => vm.selectWeight(i),
//   //             child: AnimatedContainer(
//   //               duration: Duration(milliseconds: 250),
//   //               margin: EdgeInsets.only(right: 8),
//   //               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//   //               decoration: BoxDecoration(
//   //                 color: isSelected ? AppColors.primary : Colors.white,
//   //                 // to make perfect circle
//   //                 borderRadius: BorderRadius.circular(50),
//   //                 border: Border.all(color: Colors.grey.shade200),
//   //               ),
//   //               child: Text(
//   //                 option.label,
//   //                 style: TextStyle(
//   //                   color: isSelected ? Colors.white : AppColors.textDark,
//   //                 ),
//   //               ),
//   //             ),
//   //           );
//   //         }),
//   //       ),
//   //     ],
//   //   );
//   // }

//   Widget _buildWeightOptions(BuildContext context, ProductViewModel vm) {
//     final weights = vm.weights;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Weight', style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 15),
//         Row(
//           children: List.generate(weights.length + 1, (i) {
//             final isCustom = i == weights.length;
//             final isSelected = isCustom
//                 ? vm.selectedWeightIndex == -1
//                 : vm.selectedWeightIndex == i;

//             return GestureDetector(
//               onTap: () async {
//                 if (isCustom) {
//                   final custom = await showDialog<String>(
//                     context: context,
//                     builder: (context) {
//                       final controller = TextEditingController();
//                       return AlertDialog(
//                         backgroundColor: AppColors.background,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         title: const Text(
//                           'Custom Weight',
//                           style: TextStyle(
//                             color: AppColors.textDark,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         content: TextField(
//                           controller: controller,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             hintText: 'Enter weight in kg',
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: AppColors.textLight.withOpacity(0.3),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(color: AppColors.textLight),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () =>
//                                 Navigator.pop(context, controller.text),
//                             child: Text(
//                               'Save',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );

//                   if (custom != null && custom.isNotEmpty) {
//                     vm.selectWeight(i, customValue: custom);
//                   }
//                 } else {
//                   vm.selectWeight(i);
//                 }
//               },
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 250),
//                 margin: EdgeInsets.only(right: 8),
//                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                 decoration: BoxDecoration(
//                   color: isSelected ? AppColors.primary : Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Text(
//                   isCustom
//                       ? (vm.customWeight != null
//                             ? '${vm.customWeight} kg'
//                             : 'Custom')
//                       : weights[i].label,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : AppColors.textDark,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   // Widget _buildDeliveryAndLocation(ProductViewModel vm) {
//   //   final p = vm.product!;
//   //   return Row(
//   //     children: [
//   //       Icon(Icons.location_on_outlined, color: AppColors.primary),
//   //       SizedBox(width: 8),
//   //       Expanded(
//   //         child: Text(
//   //           p.locationInfo,
//   //           style: TextStyle(color: AppColors.textDark),
//   //         ),
//   //       ),
//   //       SizedBox(width: 12),
//   //       Icon(Icons.delivery_dining, color: AppColors.accent),
//   //       SizedBox(width: 8),
//   //       Text('Delivery', style: TextStyle(color: AppColors.textDark)),
//   //     ],
//   //   );
//   // }

//   Widget _buildDescription(ProductViewModel vm) {
//     final p = vm.product!;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         Text(
//           p.description,
//           style: TextStyle(color: AppColors.textDark.withOpacity(0.8)),
//         ),
//       ],
//     );
//   }

//   /*  Widget _buildProductsList(ProductViewModel vm) {
//     // For teff app we show related product weights or other variants
//     final p = vm.product!;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 12),
//         Container(
//           height: 120,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: vm.weights.length,
//             itemBuilder: (context, index) {
//               final w = vm.weights[index];
//               final price =
//                   (p.basePrice * w.multiplier) *
//                   (p.discountPercent != null
//                       ? (1 - p.discountPercent! / 100)
//                       : 1);
//               return GestureDetector(
//                 onTap: () => vm.selectWeight(index),
//                 child: AnimatedContainer(
//                   duration: Duration(milliseconds: 250),
//                   margin: EdgeInsets.only(right: 12),
//                   width: 200,
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 6,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             w.label,
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         '${price.toStringAsFixed(2)} ETB',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   } */
// }


// // product_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/widgets/add_to_cart.dart';
import 'package:haqmate/features/review/view/review_screen.dart';
import 'package:haqmate/features/review/widget/review_list.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:haqmate/core/widgets/custom_button.dart';

class ProductDetailPage extends StatefulWidget {
  final String productid;
  const ProductDetailPage({super.key, required this.productid});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _scrollController = ScrollController();

  void _openWriteReviewSheet(BuildContext context, String productId) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) => Padding(
        padding: MediaQuery.of(ctx).viewInsets,
        child: WriteReviewSheet(productId: productId),
      ),
    );

    if (result == 'review_success') {
      Flushbar(
        message: 'ግምገማ ተልኳል!',
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(12),
      ).show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().load(widget.productid);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    return Scaffold(
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, ProductViewModel vm) {
    // Loading state
    if (vm.loading && vm.product == null) {
      return _buildLoadingState();
    }

    // Error state
    if (vm.error != null && vm.product == null) {
      return _buildErrorState(vm);
    }

    // No product found
    if (vm.product == null) {
      return _buildEmptyState();
    }

    // Success state with product
    return _buildSuccessState(context, vm);
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
            const SizedBox(height: 16),
            Text(
              'ምርት በመጫን ላይ...',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ProductViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.accent,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'አልተሳካም!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                vm.error!,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  // textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    label: 'እንደገና ይሞክሩ',
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    onPressed: () => vm.load(widget.productid),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    label: 'ይመለሱ',
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.primary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_outlined,
                color: AppColors.textLight,
                size: 72,
              ),
              const SizedBox(height: 16),
              Text(
                'ምርት አልተገኘም',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'የተጠቀሰው ምርት አልተገኘም።',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  // textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: 'ይመለሱ',
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, ProductViewModel vm) {
    final product = vm.product!;
    final isOutOfStock = !product.inStock;

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar with refresh button
            SliverAppBar(
              backgroundColor: AppColors.background,
              expandedHeight: 500,
              pinned: true,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              actions: [
                if (vm.isRefreshing)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh, color: AppColors.textDark),
                        onPressed: () => vm.reload(widget.productid),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart_outlined, color: AppColors.textDark),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  return FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildHeroImage(context, product),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.6),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          top: 400,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(vm),
                    const SizedBox(height: 12),
                    _buildWeightOptions(context, vm),
                    const SizedBox(height: 30),
                    _buildDescription(vm),
                    const SizedBox(height: 12),
                    _buildReviewsSection(context, product),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 15,
          right: 15,
          child: StickyAddToCartBar(),
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context, Product product) {
    final vm = Provider.of<ProductViewModel>(context);
    final images = product.images;
    final currentImage = images.isNotEmpty ? images[vm.selectedImageIndex] : '';

    return Hero(
      tag: "product_${widget.productid}",
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Main image
            Positioned.fill(
              child: currentImage.isNotEmpty
                  ? Image.network(
                      currentImage,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.background,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.textLight,
                              size: 64,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.background,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textLight,
                          size: 64,
                        ),
                      ),
                    ),
            ),
            
            // Image pagination dots
            if (images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
                    final isActive = i == vm.selectedImageIndex;
                    return GestureDetector(
                      onTap: () => vm.selectImage(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 12 : 8,
                        height: isActive ? 12 : 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
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

  Widget _buildHeaderSection(ProductViewModel vm) {
    final product = vm.product!;
    final hasDiscount = product.discountPercent != null;
    final originalPrice = product.basePrice * vm.selectedWeightMultiplier * vm.quantity;
    final discountedPrice = hasDiscount
        ? originalPrice * (1 - product.discountPercent! / 100)
        : originalPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          if (index < product.rating.floor()) {
                            return Icon(Icons.star, color: Colors.amber, size: 18);
                          } else if (index < product.rating.ceil()) {
                            return Icon(Icons.star_half, color: Colors.amber, size: 18);
                          } else {
                            return Icon(Icons.star_border, color: Colors.grey.shade400, size: 18);
                          }
                        }),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${product.rating.toStringAsFixed(1)} (${product.reviewsCount} ግምገማዎች)',
                        style: TextStyle(color: AppColors.textLight, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Quantity selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _quantityButton(Icons.remove, () => vm.decrementQuantity()),
                      const SizedBox(width: 8),
                      Text(
                        vm.quantity.toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(width: 8),
                      _quantityButton(Icons.add, () => vm.incrementQuantity()),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildStockPill(product.inStock),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Price section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasDiscount)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Text(
                      '${product.discountPercent}% ቅናሽ',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${originalPrice.toStringAsFixed(2)} ብር',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${discountedPrice.toStringAsFixed(2)} ብር',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ለ${vm.selectedWeightLabel}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockPill(bool inStock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: inStock ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: inStock ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inStock ? Icons.check_circle_outlined : Icons.cancel_outlined,
            size: 14,
            color: inStock ? Colors.green.shade800 : Colors.red.shade800,
          ),
          const SizedBox(width: 4),
          Text(
            inStock ? 'በመጋዘን አለ' : 'ከመጋዘን አልቋል',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: inStock ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 16, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildWeightOptions(BuildContext context, ProductViewModel vm) {
    final weights = vm.weights;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'መጠን ይምረጡ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...weights.asMap().entries.map((entry) {
              final index = entry.key;
              final weight = entry.value;
              final isSelected = index == vm.selectedWeightIndex;

              return ChoiceChip(
                label: Text(weight.label),
                selected: isSelected,
                onSelected: (selected) => vm.selectWeight(index),
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
              );
            }).toList(),
            
            // Custom weight chip
            ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 14),
                  const SizedBox(width: 4),
                  Text('ሌላ መጠን'),
                ],
              ),
              selected: vm.selectedWeightIndex == -1,
              onSelected: (selected) async {
                if (selected) {
                  final custom = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final controller = TextEditingController(text: vm.customWeight ?? '');
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          'የራስህን መጠን አስገባ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'መጠን በኪ.ግ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.scale_outlined, color: AppColors.primary),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'ሰርዝ',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (controller.text.trim().isNotEmpty) {
                                vm.selectWeight(-1, customValue: controller.text);
                              }
                              Navigator.pop(context);
                            },
                            child: const Text('አስገባ'),
                          ),
                        ],
                      );
                    },
                  );
                  if (custom == null && vm.selectedWeightIndex == -1) {
                    vm.selectWeight(0);
                  }
                } else {
                  vm.selectWeight(0);
                }
              },
              selectedColor: AppColors.accent,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: vm.selectedWeightIndex == -1 ? Colors.white : AppColors.textDark,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: vm.selectedWeightIndex == -1 ? AppColors.accent : Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(ProductViewModel vm) {
    final p = vm.product!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'መግለጫ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            p.description,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ግምገማዎች',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
            IconButton(
              onPressed: () => _openWriteReviewSheet(context, product.id),
              icon: Icon(Icons.reviews_outlined, color: AppColors.primary),
              tooltip: 'ግምገማ ይጻፉ',
            ),
          ],
        ),
        const SizedBox(height: 9),
        if (product.allReviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.reviews_outlined,
                  color: AppColors.textLight,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'ምንም ግምገማ የለም',
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (ctx, index) {
                  final r = product.allReviews[index];
                  return AnimatedReviewCard(review: r, index: index);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: product.allReviews.length > 3 ? 3 : product.allReviews.length,
              ),
              if (product.allReviews.length > 3)
                Center(
                  child: CustomButton(
                    label: 'ተጨማሪ ግምገማዎች ይመልከቱ',
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsPage(productId: product.id),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}