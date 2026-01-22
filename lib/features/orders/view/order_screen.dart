import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/checkout/view/manual_payment_screen.dart';
import 'package:haqmate/features/order_detail/view/order_detail_page.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
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
                            final order = vm.filtered[index];
                            final config = vm.uiConfigFor(order);
                            return OrderCard(
                              order: order,
                              config: config,
                              onAction: (action) {
                                if (action == OrderAction.track) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailPage(orderId: order.id),
                                    ),
                                  );
                                } else if (action == OrderAction.pay) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManualPaymentScreen(
                                        orderId: order.id,
                                      ),
                                    ),
                                  );
                                } else {
                                  vm.handleAction(action, order);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Consumer<OrdersViewModel>(
          builder: (context, vm, child) {
            return SizedBox(
              width: 260,
              child: CustomButton(
                label: 'Contact Seller',
                borderRadius: BorderRadius.circular(14),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () => vm.contactSeller('+251985272557'),
              ),
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
