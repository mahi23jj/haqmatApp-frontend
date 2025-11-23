import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';



Widget _buildStockPill(bool inStock) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: inStock ? Colors.green.shade50 : Colors.red.shade50,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      inStock ? '🟢 OPEN' : '🔴 CLOSED',
      style: TextStyle(
        color: inStock ? Colors.green.shade800 : Colors.red.shade800,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget quantityButton(IconData icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Icon(icon, size: 18, color: AppColors.textDark),
    ),
  );
}

Widget _buildWeightOptions(ProductViewModel vm) {
  final weights = vm.product!.weights;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Row(
        children: List.generate(weights.length, (i) {
          final option = weights[i];
          final isSelected = i == vm.selectedWeightIndex;
          return GestureDetector(
            onTap: () => vm.selectWeight(i),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                option.label,
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

Widget _buildDeliveryAndLocation(ProductViewModel vm) {
  final p = vm.product!;
  return Row(
    children: [
      Icon(Icons.location_on_outlined, color: AppColors.primary),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          p.locationInfo,
          style: TextStyle(color: AppColors.textDark),
        ),
      ),
      SizedBox(width: 12),
      Icon(Icons.delivery_dining, color: AppColors.accent),
      SizedBox(width: 8),
      Text('Delivery', style: TextStyle(color: AppColors.textDark)),
    ],
  );
}

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

Widget _buildProductsList(ProductViewModel vm) {
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
          itemCount: p.weights.length,
          itemBuilder: (context, index) {
            final w = p.weights[index];
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
}
