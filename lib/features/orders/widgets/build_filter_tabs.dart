import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:provider/provider.dart';

Widget buildFilterTabs(BuildContext context) {
  final vm = context.watch<OrdersViewModel>();

  final filters = ["All",  "PENDING_PAYMENT", "TO_BE_DELIVERED" , "COMPLETED ", "CANCELLED" ];

  return SizedBox(
    height: 45,
    child: ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: filters.length,
      separatorBuilder: (_, __) => SizedBox(width: 10),
      itemBuilder: (context, i) {
        final f = filters[i];
        final active = vm.activeFilter == f;

        return GestureDetector(
          onTap: () => vm.applyFilter(f),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              f,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      },
    ),
  );
}
