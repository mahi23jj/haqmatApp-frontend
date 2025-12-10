import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/order_detail/view/order_detail_page.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/features/orders/widgets/order_progress.dart';
import 'package:haqmate/features/orders/widgets/status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGES
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: order.imageUrls.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (context, i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    order.imageUrls[i],
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 14),

          // ORDER STAGE
          OrderProgress(stage: order.status),

          SizedBox(height: 14),

          // ORDER DETAILS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderid,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              StatusBadge(status: order.status),
            ],
          ),

          SizedBox(height: 4),
          Text(
            "${order.amount.toStringAsFixed(0)} ETB",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),

          SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailPage(orderId: order.id),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("Track Order", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
