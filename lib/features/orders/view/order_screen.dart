import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/features/orders/widgets/build_filter_tabs.dart';
import 'package:haqmate/features/orders/widgets/order_card.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            "My Orders",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<OrdersViewModel>(
          builder: (context, vm, child) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                SizedBox(height: 10),

                // 🔥 FILTER TABS
                buildFilterTabs(context),

                SizedBox(height: 12),

                // 🔥 ORDER LIST
                Expanded(
                  child: vm.filtered.isEmpty
                      ? Center(child: Text("No orders found"))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: vm.filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return OrderCard(order: vm.filtered[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),

        /*  body: Consumer<OrdersViewModel>(
          builder: (context, vm, child) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = vm.orders[index];
                return OrderCard(order: order);
              },
            );
          },
        ), */
      ),
    );
  }
}
