import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/cart/view/cart_edit_page.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/checkout/view/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/core/widgets/cart_loading_skeleton.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CartViewModel>(context, listen: false).loadCart();
  }

  void _openProductOptionSheet(BuildContext context, CartModel cartmodel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) => Padding(
        padding: MediaQuery.of(ctx).viewInsets,
        child: ProductOptionBottomSheet(cartitem: cartmodel),
      ),
    );
  }

  Future<void> showDeliveryChoiceDialog(
    BuildContext context,
    CartModelList cart,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Order Type"),
          content: const Text("How would you like to receive your order?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CheckoutView(cart: cart, orderType: 'Pickup'),
                  ),
                );
              },
              child: const Text("Pick Up"),
            ),
            CustomButton(
              label: 'Delivery',
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CheckoutView(cart: cart, orderType: 'Delivery'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<CartViewModel>(
        builder: (context, vm, _) {
          // ----------------
          // LOADING
          // ----------------
          if (vm.loading) {
            return const CartLoadingSkeleton();
          }

          // ----------------
          // ERROR
          // ----------------
          if (vm.error != null) {
            return Center(
              child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
            );
          }

          final carts = vm.cartItems?.items;

          if (carts == null || carts.isEmpty) {
            return const _EmptyCartView();
          }

          return Stack(
            children: [
              // Main content with scrolling items
              Column(
                children: [
                  // Fixed header that scrolls with content
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                    color: AppColors.background,
                    child: const Row(
                      children: [
                        BackButton(),
                        SizedBox(width: 8),
                        Text(
                          "Your Cart",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        bottom: 260,
                      ), // Extra room so last item clears floating total
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        final cartModel = carts[index];

                        Widget quantityButton(
                          IconData icon,
                          VoidCallback onTap,
                        ) {
                          return GestureDetector(
                            onTap: onTap,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        return Dismissible(
                          key: ValueKey(cartModel.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                          onDismissed: (_) {
                            vm.removeItem(cartModel);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  _openProductOptionSheet(context, cartModel),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // IMAGE
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/teff.jpg',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // PRODUCT INFO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartModel.name,
                                            style: const TextStyle(
                                              color: AppColors.textDark,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${cartModel.packaging} Kg',
                                            style: const TextStyle(
                                              color: AppColors.textLight,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "\$${(cartModel.totalprice * cartModel.quantity).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // QUANTITY CONTROLLER
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              quantityButton(Icons.remove, () {
                                                if (cartModel.quantity > 1) {
                                                  vm.updateQuantityDebounced(
                                                    productId:
                                                        cartModel.productId,
                                                    quantity:
                                                        cartModel.quantity - 1,
                                                    packagingSize:
                                                        cartModel.packaging,
                                                  );
                                                }
                                              }),
                                              const SizedBox(width: 12),
                                              Text(
                                                cartModel.quantity.toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textDark,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              quantityButton(
                                                Icons.add,
                                                () =>
                                                    vm.updateQuantityDebounced(
                                                      productId:
                                                          cartModel.productId,
                                                      quantity:
                                                          cartModel.quantity +
                                                          1,
                                                      packagingSize:
                                                          cartModel.packaging,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Text(
                                        //   "\$${(cartModel.totalprice * cartModel.quantity).toStringAsFixed(2)}",
                                        //   style: const TextStyle(
                                        //     color: AppColors.textDark,
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.w500,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Floating total section at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _FloatingTotalSection(
                  totalPrice: (vm.cartItems?.totalPrice ?? 0).toDouble(),
                  onCheckout: () {
                    if (vm.cartItems != null) {
                      showDeliveryChoiceDialog(context, vm.cartItems!);
                    }
                  },
                  itemCount: carts.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FloatingTotalSection extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckout;
  final int itemCount;

  const _FloatingTotalSection({
    required this.totalPrice,
    required this.onCheckout,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subtotal",
                style: TextStyle(color: AppColors.textLight, fontSize: 14),
              ),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shipping",
                style: TextStyle(color: AppColors.textLight, fontSize: 14),
              ),
              Text(
                "Calculated at checkout",
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    "$itemCount item${itemCount > 1 ? 's' : ''}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checkout button
          CustomButton(
            label: 'Proceed to Checkout',
            width: double.infinity,
            height: 56,
            borderRadius: BorderRadius.circular(12),
            onPressed: onCheckout,
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                "Add some delicious items to get started!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Start Shopping',
              width: 200,
              height: 50,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
