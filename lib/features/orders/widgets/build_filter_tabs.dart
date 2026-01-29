// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/orders/model/order.dart';
// import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
// import 'package:provider/provider.dart';

// Widget buildFilterTabs(BuildContext context) {
//   final vm = context.watch<OrdersViewModel>();

//   final filters = <OrderStatus?>[
//     null,
//     OrderStatus.pendingPayment,
//     OrderStatus.toBeDelivered,
//     OrderStatus.completed,
//     OrderStatus.cancelled,
//   ];

//   return SizedBox(
//     height: 45,
//     child: ListView.separated(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       scrollDirection: Axis.horizontal,
//       itemCount: filters.length,
//       separatorBuilder: (_, __) => SizedBox(width: 10),
//       itemBuilder: (context, i) {
//         final f = filters[i];
//         final active = vm.activeFilter == f;
//         final label = f?.label ?? 'All';

//         return GestureDetector(
//           onTap: () => vm.applyFilter(f),
//           child: AnimatedContainer(
//             duration: Duration(milliseconds: 200),
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: active ? AppColors.primary : Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: active ? Colors.white : AppColors.textDark,
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:provider/provider.dart';

Widget buildFilterTabs(BuildContext context) {
  final vm = context.watch<OrdersViewModel>();

  final filters = <OrderStatus?>[
    null,
    OrderStatus.pendingPayment,
    OrderStatus.toBeDelivered,
    OrderStatus.completed,
    OrderStatus.cancelled,
  ];

  // Map backend status to Amharic display text
  String _getFilterLabel(OrderStatus? status) {
    if (status == null) return 'ሁሉም';
    
    final Map<OrderStatus, String> translations = {
      OrderStatus.pendingPayment: 'በመክፈል ላይ',
      OrderStatus.toBeDelivered: 'ለመላክ',
      OrderStatus.completed: 'ተጠናቀቁ',
      OrderStatus.cancelled: 'ተሰርዘዋል',
    };
    
    return translations[status] ?? status.label;
  }

  return SizedBox(
    height: 50,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: filters.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, i) {
        final filter = filters[i];
        final active = vm.activeFilter == filter;
        final label = _getFilterLabel(filter);

        return GestureDetector(
          onTap: () => vm.applyFilter(filter),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: active ? AppColors.primary : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: active ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: active ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      },
    ),
  );
}