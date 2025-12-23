import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/widgets/add_to_cart.dart';
import 'package:haqmate/features/review/view/review_screen.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/review_list.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String productid;
  const ProductDetailPage({super.key, required this.productid});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _scrollController = ScrollController();

  void _openWriteReviewSheet(BuildContext context, String productId) {
    showModalBottomSheet(
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
  }

  @override
  void initState() {
    super.initState();
    print('product id in detail page: ${widget.productid}');
    // Run AFTER the first frame so notifyListeners is safe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().load(widget.productid);
    });
  }

  // dispose()
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    // 1️⃣ LOADING SCREEN
    if (vm.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 2️⃣ NO PRODUCT FOUND
    if (vm.product == null) {
      return const Scaffold(body: Center(child: Text("No product found")));
    }

    // 3️⃣ SAFE — product is guaranteed non-null here
    final product = vm.product!;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background,
                expandedHeight: 500,
                pinned: true,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: BackButton(color: AppColors.textDark),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColors.textDark,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final top = constraints.biggest.height;
                    // parallax effect: compute image movement
                    return FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildHeroImage(context, product),
                          // gradient overlay for readability
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
                                  stops: [0.6, 1.0],
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
              /* SliverToBoxAdapter(
            child: SizedBox(height: 380),
          ), */
            ],
          ),
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            bottom: 0,
            // to make it curve on top of the image
            child: Container(
              // margin: EdgeInsets.only(top: -30),
              decoration: BoxDecoration(
                color: AppColors.background, // white/off-white background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                // no need to side scroll bar , just smooth scroll
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(vm),
                      // SizedBox(height: 12),
                      // _buildTagPills(vm),
                      SizedBox(height: 12),
                      _buildWeightOptions(context, vm),
                      /*                SizedBox(height: 16),
                        _buildDeliveryAndLocation(vm), */
                      SizedBox(height: 30),
                      _buildDescription(vm),

                      SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () =>
                                _openWriteReviewSheet(context, product.id),
                            icon: Icon(Icons.wifi_protected_setup_sharp),
                          ),
                        ],
                      ),

                      SizedBox(height: 9),

                      /* if (product.reviews.isEmpty)
                        const Center(child: Text('No reviews yet')),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (ctx, index) {
                          final r = product.reviews[index];
                          return AnimatedReviewCard(review: r, index: index);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: product.reviews.length,
                      ), */
                      if (product.allReviews.isEmpty)
                        const Center(child: Text('No reviews yet')),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (ctx, index) {
                          final r = product.allReviews[index];
                          return AnimatedReviewCard(review: r, index: index);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: product.allReviews.length,
                      ),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            /*   context.read<ReviewViewModel>().loadReviews(
                              product.id,
                            ); */

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewsPage(productid: product.id),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 50,
                            ),
                            child: Text(
                              "Read More Reviews",
                              style: TextStyle(
                                color: AppColors.background,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /*           SizedBox(height: 16),
                        _buildProductsList(vm), */
                      // SizedBox(height: 0), // leave space for bottom bar
                      SizedBox(height: 90), // leave space for bottom bar
                    ],
                  ),
                ),
              ),
            ),
          ),
          // on bottom
          Positioned(
            child: StickyAddToCartBar(),
            bottom: 15,
            left: 15,
            right: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, Product product) {
    final vm = Provider.of<ProductViewModel>(context);
    final imagePath = product.images[vm.selectedImageIndex];

    Widget imageWidget;
    // If the path exists as a file, use Image.file, otherwise fallback.
    try {
      /*    if (File(imagePath).existsSync()) {
        imageWidget = Image.asset(imagePath), fit: BoxFit.cover);
      } else {
        
      } */
      imageWidget = Image.asset('assets/images/teff.jpg', fit: BoxFit.cover);
    } catch (e) {
      imageWidget = Image.asset('assets/placeholder.jpg', fit: BoxFit.cover);
    }

    return Hero(
      tag: "product_${widget.productid}",
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

  Widget _buildHeaderSection(ProductViewModel vm) {
    final product = vm.product!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(
                    height: 15,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 2);
                      },
                      itemCount: product.rating.toInt(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '${product.rating} (${product.reviewsCount}  Reviews)',
                    style: TextStyle(color: AppColors.textDark),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _quantityButton(Icons.remove, () => vm.prevQuantity()),
                  SizedBox(width: 8),
                  Text(
                    vm.quantity.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  _quantityButton(Icons.add, () => vm.nextQuantity()),
                ],
              ),
            ),
            SizedBox(height: 12),

            SizedBox(width: 12),
            _buildStockPill(product.inStock),
            /* Text(
              'Total: \${vm.price.toStringAsFixed(2)} ETB',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ), */
          ],
        ),
      ],
    );
  }

  Widget _buildStockPill(bool inStock) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      /*  decoration: BoxDecoration(
        color: inStock ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ), */
      child: Text(
        inStock ? 'Available in Stock' : 'Not Available in Stock',
        style: TextStyle(
          color: inStock ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildTagPills(ProductViewModel vm) {
    final tags = ['Accessories', 'Premium', 'Organic', 'Delivery'];
    return Wrap(
      spacing: 8,
      children: tags
          .map(
            (t) => ActionChip(
              backgroundColor: Colors.white,
              label: Text(t, style: TextStyle(color: AppColors.textDark)),
              onPressed: () {},
            ),
          )
          .toList(),
    );
  }

  // Widget _buildWeightOptions(ProductViewModel vm) {
  //   final weights = vm.weights;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Weight', style: TextStyle(fontWeight: FontWeight.bold)),
  //       SizedBox(height: 15),
  //       Row(
  //         children: List.generate(weights.length + 1, (i) {
  //           final isSelected = i == vm.selectedWeightIndex;

  //           if (i == weights.length) {
  //             return GestureDetector(
  //               onTap: () => vm.selectWeight(i),
  //               child: AnimatedContainer(
  //                 duration: Duration(milliseconds: 250),
  //                 margin: EdgeInsets.only(right: 8),
  //                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //                 decoration: BoxDecoration(
  //                   color: isSelected ? AppColors.primary : Colors.white,
  //                   // to make perfect circle
  //                   borderRadius: BorderRadius.circular(50),
  //                   border: Border.all(color: Colors.grey.shade200),
  //                 ),
  //                 child: Text(
  //                   'Custom',
  //                   style: TextStyle(
  //                     color: isSelected ? Colors.white : AppColors.textDark,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //           final option = weights[i];
  //           return GestureDetector(
  //             onTap: () => vm.selectWeight(i),
  //             child: AnimatedContainer(
  //               duration: Duration(milliseconds: 250),
  //               margin: EdgeInsets.only(right: 8),
  //               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //               decoration: BoxDecoration(
  //                 color: isSelected ? AppColors.primary : Colors.white,
  //                 // to make perfect circle
  //                 borderRadius: BorderRadius.circular(50),
  //                 border: Border.all(color: Colors.grey.shade200),
  //               ),
  //               child: Text(
  //                 option.label,
  //                 style: TextStyle(
  //                   color: isSelected ? Colors.white : AppColors.textDark,
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildWeightOptions(BuildContext context, ProductViewModel vm) {
    final weights = vm.weights;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Weight', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Row(
          children: List.generate(weights.length + 1, (i) {
            final isCustom = i == weights.length;
            final isSelected = isCustom
                ? vm.selectedWeightIndex == -1
                : vm.selectedWeightIndex == i;

            return GestureDetector(
              onTap: () async {
                if (isCustom) {
                  final custom = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final controller = TextEditingController();
                      return AlertDialog(
                        title: Text('Enter custom weight (kg)'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'e.g., 100'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, controller.text),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );

                  if (custom != null && custom.isNotEmpty) {
                    vm.selectWeight(i, customValue: custom);
                  }
                } else {
                  vm.selectWeight(i);
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  isCustom
                      ? (vm.customWeight != null
                            ? '${vm.customWeight} kg'
                            : 'Custom')
                      : weights[i].label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Widget _buildDeliveryAndLocation(ProductViewModel vm) {
  //   final p = vm.product!;
  //   return Row(
  //     children: [
  //       Icon(Icons.location_on_outlined, color: AppColors.primary),
  //       SizedBox(width: 8),
  //       Expanded(
  //         child: Text(
  //           p.locationInfo,
  //           style: TextStyle(color: AppColors.textDark),
  //         ),
  //       ),
  //       SizedBox(width: 12),
  //       Icon(Icons.delivery_dining, color: AppColors.accent),
  //       SizedBox(width: 8),
  //       Text('Delivery', style: TextStyle(color: AppColors.textDark)),
  //     ],
  //   );
  // }

  Widget _buildDescription(ProductViewModel vm) {
    final p = vm.product!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(
          p.description,
          style: TextStyle(color: AppColors.textDark.withOpacity(0.8)),
        ),
      ],
    );
  }

  /*  Widget _buildProductsList(ProductViewModel vm) {
    // For teff app we show related product weights or other variants
    final p = vm.product!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vm.weights.length,
            itemBuilder: (context, index) {
              final w = vm.weights[index];
              final price =
                  (p.basePrice * w.multiplier) *
                  (p.discountPercent != null
                      ? (1 - p.discountPercent! / 100)
                      : 1);
              return GestureDetector(
                onTap: () => vm.selectWeight(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.only(right: 12),
                  width: 200,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            w.label,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${price.toStringAsFixed(2)} ETB',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  } */
}
