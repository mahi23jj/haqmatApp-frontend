import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/loading_state.dart';
import 'package:haqmate/features/checkout/view/manual_payment_screen.dart';
import 'package:haqmate/features/order_detail/view/order_detail_page.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/orders/widgets/build_filter_tabs.dart';
import 'package:haqmate/features/orders/widgets/order_card.dart';
import 'package:haqmate/core/widgets/bilingual_title.dart';
import 'package:haqmate/l10n/gen/app_localizations.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      /* appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "የእኔ ትዕዛዞች",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ), */
      body: Consumer<OrdersViewModel>(
        builder: (context, vm, child) {
          // Loading state
          if (vm.loading) {
            return const LoadingState();
          }

          // Error state
          if (vm.error != null) {
            return _buildErrorState(vm);
          }

          // Success state with data
          return _buildSuccessState(context, vm);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<OrdersViewModel>(
        builder: (context, vm, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: CustomButton(
              label: 'ድርጅቱን ያነጋግሩ',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.symmetric(vertical: 16),
              onPressed: () => vm.contactSeller('+251985272557'),
            ),
          );
        },
      ),
    );
  }

  /*  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'ትዕዛዞች በመጫን ላይ...',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
 */
  Widget _buildErrorState(OrdersViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.accent, size: 64),
            const SizedBox(height: 16),
            Text(
              'አልተሳካም!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vm.error!,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                // textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'እንደገና ይሞክሩ',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => vm.load(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(OrdersViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.textLight,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'ምንም ትዕዛዝ የለም',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vm.activeFilter == null
                  ? 'እስካሁን ምንም ትዕዛዝ አላቀረቡም።'
                  : 'በዚህ ሁኔታ ምንም ትዕዛዝ የለም።',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                // textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            if (vm.activeFilter != null)
              CustomButton(
                label: 'ሁሉንም ትዕዛዞች ይመልከቱ',
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                onPressed: () => vm.applyFilter(null),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, OrdersViewModel vm) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          color: AppColors.background,
          child: Row(
            children: [
              /* IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ), */
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/logo2.png',
                  height: 60,
                  width: 60,
                ),
              ),

              const SizedBox(width: 10),
              Expanded(
                child: BilingualTitle(
                  amharic: l10n.ordersTitleAm,
                  english: l10n.ordersTitleEn,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: AppColors.primary),
                onPressed: () => vm.load(),
                tooltip: 'አደስ',
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // 🔥 FILTER TABS
        buildFilterTabs(context),

        const SizedBox(height: 12),

        // Order count indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${vm.filtered.length} ትዕዛዝ${vm.filtered.length == 1 ? '' : 'ዎች'} ተገኝተዋል',
                style: TextStyle(color: AppColors.textLight, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 🔥 ORDER LIST / EMPTY STATE
        Expanded(
          child: vm.filtered.isEmpty
              ? _buildEmptyState(vm)
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await vm.load();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    itemCount: vm.filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = vm.filtered[index];
                      final config = vm.uiConfigFor(order);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailPage(orderId: order.id),
                            ),
                          );
                        },
                        child: OrderCard(
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
                                  builder: (context) =>
                                      ManualPaymentScreen(orderId: order.id),
                                ),
                              );
                            } else {
                              vm.handleAction(action, order);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
