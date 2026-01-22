import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StickyAddToCartBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);
    final cartVm = Provider.of<CartViewModel>(context, listen: false);
    final p = vm.product!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total', style: TextStyle(color: Colors.grey.shade600)),
                  SizedBox(height: 6),
                  Text(
                    '${vm.price.toStringAsFixed(2)} ETB',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            CustomButton(
              label: vm.addingToCart ? 'Adding...' : 'Add to cart',
              loading: vm.addingToCart,
              loadingChild: Shimmer.fromColors(
                baseColor: Colors.white70,
                highlightColor: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Adding...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              onPressed: vm.addingToCart
                  ? null
                  : () => _onAddToCart(context, vm, cartVm),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddToCart(
    BuildContext context,
    ProductViewModel vm,
    CartViewModel cartVm,
  ) async {
    cartVm.clearError();

    await vm.addToCart(cartVm);

    final error = cartVm.error;

    if (error != null) {
      print('add to cart error: $error');
      _showFlushbar(
        context,
        message: error,
        background: Colors.red.shade600,
      );
      return;
    }

    _showFlushbar(
      context,
      message: 'Added ${vm.quantity} x ${vm.selectedWeightLabel} to cart',
      background: Colors.green.shade600,
    );
  }

  void _showFlushbar(
    BuildContext context, {
    required String message,
    required Color background,
  }) {
    Flushbar(
      message: message,
      backgroundColor: background,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
    ).show(context);
  }
}
