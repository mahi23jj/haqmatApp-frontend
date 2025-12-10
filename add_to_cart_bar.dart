import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

class StickyAddToCartBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                /* foregroundColor: AppColors.accent, */
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.shopping_bag_outlined  , color: Colors.white,),
              label: Text('Add to cart' , style: TextStyle(color: Colors.white),) ,
              onPressed: () => _onAddToCart(context, vm),
            ),
          ],
        ),
      ),
    );
  }


void _onAddToCart(BuildContext context, ProductViewModel vm) async {
  // Convert weight label to int safely
  final packagingSize = int.parse(vm.weights[vm.selectedWeightIndex].label);

  await context.read<CartViewModel>().addToCart(
    productId: vm.product!.id,
    quantity: vm.quantity,
    packagingSize: packagingSize,
  );

  final snack = SnackBar(
    content: Text(
      'Added ${vm.quantity} x ${vm.weights[vm.selectedWeightIndex].label} to cart',
    ),
    backgroundColor: AppColors.primary,
  );

  ScaffoldMessenger.of(context).showSnackBar(snack);
}

}
