import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/features/orders/widgets/status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final OrderUiConfig config;
  final ValueChanged<OrderAction> onAction;

  const OrderCard({
    required this.order,
    required this.config,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final otherActions = config.actions
        .where((action) => action != OrderAction.track)
        .toList();

    final tags = <String>[
      ...config.paymentTags,
      ...config.deliveryTags,
      if (config.refundStatus != null) config.refundStatus!.label,
    ];

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
          _buildImages(),

          SizedBox(height: 14),

          // ORDER DETAILS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.merchOrderId,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              StatusBadge(label: order.status.label, status: ''),
            ],
          ),

          SizedBox(height: 4),
          Text(
            "${order.totalAmount.toStringAsFixed(0)} ETB",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),

          SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((label) => StatusBadge(label: label)).toList(),
          ),

          /*        if (config.declineReason != null) ...[
            SizedBox(height: 8),
            Text(
              'Reason: ${config.declineReason}',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
            ),
          ], */
          SizedBox(height: 12),

          if (otherActions.isNotEmpty) ...[
            Row(
              children: otherActions.map((action) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: action != otherActions.last ? 10 : 0,
                    ),
                    child: _secondaryActionButton(action),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
          ],

          // SizedBox(height: 12),
          // if (otherActions.isNotEmpty) ...[
          //   Wrap(
          //     spacing: 10,
          //     runSpacing: 10,
          //     children: otherActions
          //         .map((action) => _secondaryActionButton(action))
          //         .toList(),
          //   ),
          //   SizedBox(height: 10),
          // ],

          /*  _primaryButton(
            label: 'Track Order',
            onPressed: () => onAction(OrderAction.track),
          ), */
        ],
      ),
    );
  }

  Widget _buildImages() {
    final images = order.items.map((item) => item.image).toList();
    if (images.isEmpty) return SizedBox.shrink();

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (context, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[i],
              width: 95,
              height: 95,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      width: double.infinity,
      height: 45,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _secondaryActionButton(OrderAction action) {
    final label = _actionLabel(action);
    final isPrimary = action == OrderAction.pay;

    return OutlinedButton(
      onPressed: () => onAction(action),
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppColors.primary.withOpacity(0.15)
            : Colors.transparent,
        foregroundColor: AppColors.secondary,
        side: BorderSide(color: AppColors.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label),
    );
  }

  String _actionLabel(OrderAction action) {
    switch (action) {
      case OrderAction.pay:
        return 'Pay';
      case OrderAction.cancel:
        return 'Cancel';
      case OrderAction.track:
        return 'Track';
    }
  }
}
