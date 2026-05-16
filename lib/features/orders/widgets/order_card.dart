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
    ];

    // Format date in Amharic style
    final dateText = _formatDate(order.createdAt);

    return Container(
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
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Images
          _buildImages(),

          const SizedBox(height: 16),

          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.merchOrderId,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      dateText,
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: order.status.label),
            ],
          ),

          const SizedBox(height: 12),

          // Order Price
          Text(
            "${order.totalAmount.toStringAsFixed(0)} ብር",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.secondary,
            ),
          ),

          const SizedBox(height: 12),

          // Tags
          if (tags.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((label) => StatusBadge(label: label)).toList(),
            ),

          const SizedBox(height: 16),

          // Action Buttons
          if (otherActions.isNotEmpty) ...[
            Row(
              children: otherActions.map((action) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: action != otherActions.last ? 10 : 0,
                    ),
                    child: _actionButton(action),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],

          // Track Button
          /*     if (config.actions.contains(OrderAction.track))
            _trackButton(), */
        ],
      ),
    );
  }

  Widget _buildImages() {
    final images = order.items
        .map((item) => item.image)
        .where((img) => img.isNotEmpty)
        .toList();
    if (images.isEmpty) {
      return Container(
        height: 95,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.textLight,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'ምርቶች',
                style: TextStyle(color: AppColors.textLight, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[i],
              width: 95,
              height: 95,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 95,
                  height: 95,
                  color: AppColors.background,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 95,
                  height: 95,
                  color: AppColors.background,
                  child: const Center(
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton(OrderAction action) {
    final Map<OrderAction, Map<String, dynamic>> buttonConfigs = {
      OrderAction.pay: {
        'label': 'ክፍያ',
        'bgColor': AppColors.primary,
        'textColor': Colors.white,
        'icon': Icons.payment_outlined,
      },
    };

    final config =
        buttonConfigs[action] ??
        {
          'label': _getActionLabel(action),
          'bgColor': Colors.grey.shade100,
          'textColor': AppColors.textDark,
          'icon': Icons.more_horiz,
        };

    return OutlinedButton.icon(
      onPressed: () => onAction(action),
      style: OutlinedButton.styleFrom(
        backgroundColor: config['bgColor'],
        foregroundColor: config['textColor'],
        side: BorderSide(color: config['textColor']!.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      icon: Icon(config['icon'], size: 18),
      label: Text(
        config['label'],
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Widget _trackButton() {
  //   return CustomButton(
  //     label: 'ትዕዛዝ ይከታተሉ',
  //     backgroundColor: AppColors.secondary,
  //     foregroundColor: Colors.white,
  //     onPressed: () => onAction(OrderAction.track),
  //     borderRadius: BorderRadius.circular(12),
  //     icon: Icon(Icons.track_changes_outlined, size: 18),
  //   );
  // }

  String _getActionLabel(OrderAction action) {
    switch (action) {
      case OrderAction.track:
        return 'ከታተል';
      case OrderAction.pay:
        return 'ክፍያ';
    }
  }

  String _formatDate(DateTime date) {
    final monthNames = [
      'ጃንዋሪ',
      'ፈብርዋሪ',
      'ማርች',
      'ኤፕሪል',
      'ሜይ',
      'ጁን',
      'ጁላይ',
      'ኦገስት',
      'ሴፕቴምበር',
      'ኦክቶበር',
      'ኖቬምበር',
      'ዲሴምበር',
    ];

    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }
}
