// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/order_detail/model/order_model.dart';
// import 'package:haqmate/features/orders/model/order.dart'
//     hide PaymentStatus, OrderStatus;
// import 'package:haqmate/features/orders/widgets/status_badge.dart';
// import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
// import 'package:haqmate/core/widgets/custom_button.dart';
// import 'package:provider/provider.dart';
// import '../viewmodel/order_viewmodel.dart';

// class OrderDetailPage extends StatefulWidget {
//   final String orderId;
//   const OrderDetailPage({super.key, required this.orderId});

//   @override
//   State<OrderDetailPage> createState() => _OrderDetailPageState();
// }

// class _OrderDetailPageState extends State<OrderDetailPage> {
//   @override
//   void initState() {
//     super.initState();
//     print('order id in detail page: ${widget.orderId}');
//     // Run AFTER the first frame so notifyListeners is safe
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<OrderdetailViewModel>().loadorderdetail(widget.orderId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<OrderdetailViewModel>(context);

//     if (vm.loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     // 2️⃣ NO PRODUCT FOUND
//     if (vm.order == null) {
//       return const Scaffold(body: Center(child: Text("No order found")));
//     }

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: Text("Order Details"),
//         centerTitle: true,
//         backgroundColor: AppColors.background,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: ListView(
//           children: [
//             SizedBox(height: 16),
//             _buildOrderId(vm),
//             SizedBox(height: 16),
//             _buildPaymentSection(vm),
//             SizedBox(height: 20),
//             _buildTrackingSection(vm),
//             SizedBox(height: 20),
//             _buildOrderItems(vm),
//             SizedBox(height: 20),
//             _buildRefundSection(vm),
//             SizedBox(height: 20),
//             _buildAddress(vm),
//             // SizedBox(height: 20),
//             // _buildAddress(vm),
//             SizedBox(height: 25),
//             CustomButton(
//               label: 'Contact Sellers',
//               onPressed: () {
//                 vm.callSeller('+251985272557');
//               },
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderId(OrderdetailViewModel vm) {
//     return FadeIn(
//       child: Text(
//         "Order Id - ${vm.order!.merchOrderId}",
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildTrackingSection(OrderdetailViewModel vm) {
//     return FadeIn(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: _boxDecoration(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Order Tracking",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             SizedBox(height: 18),
//             ...vm.order!.tracking.map((step) {
//               final isLast = step == vm.order!.tracking.last;
//               return _trackingTile(step, isLast);
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _trackingTile(step, last) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               width: 20,
//               height: 20,

//               child: step.completed
//                   ? Icon(
//                       Icons.check_circle,
//                       color: AppColors.secondary,
//                       size: 25,
//                     )
//                   : Icon(Icons.circle, color: AppColors.primary, size: 25),
//             ),

//             SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   step.title,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   step.date ?? '',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//           ],
//         ),

//         if (!last)
//           Container(
//             width: 2,
//             height: 40,
//             color: AppColors.primary,
//             // to be on start
//             margin: EdgeInsets.only(left: 10),
//           ),
//       ],
//     );
//   }

//   Widget _buildOrderItems(OrderdetailViewModel vm) {
//     return FadeIn(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: _boxDecoration(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Order Items",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             ...vm.order!.items.map((item) => _itemCard(item)),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "delivery fee",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 Text(
//                   "${vm.order!.deliveryFee}",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ],
//             ),
//             Divider(height: 24, thickness: 1),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 Text(
//                   "${vm.order!.totalAmount}",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _itemCard(OrderItems item) {
//     return SlideIn(
//       child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: 14),
//             decoration: _boxDecoration(),
//             child: ListTile(
//               leading: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   item.image,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               title: Text(item.name),
//               subtitle: Text("${item.packagingSize} kg\n${item.quantity} x"),
//               trailing: Text(
//                 "${item.price} ETB",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddress(OrderdetailViewModel vm) {
//     return FadeIn(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: _boxDecoration(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Delivery Address",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Text('+251 ${vm.order!.phoneNumber}'),
//             SizedBox(height: 8),
//             Text(vm.order!.location),
//             if (vm.deliveryDateFormatted != null) ...[
//               SizedBox(height: 8),
//               Text(
//                 'Scheduled delivery: ${vm.deliveryDateFormatted}',
//                 style: TextStyle(color: Colors.grey[700]),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentSection(OrderdetailViewModel vm) {
//     final order = vm.order!;
//     return FadeIn(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: _boxDecoration(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Payment Status',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Wrap(
//               spacing: 6,
//               runSpacing: 6,
//               children: [
//                 // Always show current payment status
//                 StatusBadge(label: order.paymentstatus),
//                 // TO_BE_DELIVERED: show CONFIRMED and delivery status tag
//              /*    if (vm.showConfirmedPaymentTag)
//                   StatusBadge(label: PaymentStatus.CONFIRMED.name), */
//                 if (vm.deliveryStatusTagLabel != null)
//                   StatusBadge(label: vm.deliveryStatusTagLabel!),
//                 // CANCELLED + DECLINED
//                 if (order.status == OrderStatus.CANCELLED &&
//                     order.paymentstatus == PaymentStatus.DECLINED.name)
//                   StatusBadge(label: PaymentStatus.DECLINED.name),
//                 // REFUNDED: show RefundStatus tag alongside payment tag
//                 if (vm.showRefundTag) StatusBadge(label: order.refundstatus),
//               ],
//             ),
//             if (vm.showPaymentProof) ...[
//               SizedBox(height: 12),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   order.paymentProofUrl,
//                   height: 160,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ],
//             if (vm.showDeclineReason) ...[
//               SizedBox(height: 8),
//               Text(
//                 'Reason: ${order.cancelReason}',
//                 style: TextStyle(color: Colors.grey[700]),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRefundSection(OrderdetailViewModel vm) {
//     final order = vm.order!;
//     if (!vm.showRefundTag && !vm.showRefundRejectReason)
//       return SizedBox.shrink();

//     return FadeIn(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: _boxDecoration(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Refund',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             if (vm.showRefundTag) StatusBadge(label: order.refundstatus),
//             if (vm.showRefundRejectReason) ...[
//               SizedBox(height: 8),
//               Text(
//                 'Reason: ${order.cancelReason}',
//                 style: TextStyle(color: Colors.grey[700]),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   BoxDecoration _boxDecoration() => BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(12),
//     boxShadow: [
//       BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//     ],
//   );
// }

// /// --- Animation Widgets --- ///

// class FadeIn extends StatelessWidget {
//   final Widget child;
//   FadeIn({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0, end: 1),
//       duration: Duration(milliseconds: 600),
//       builder: (context, value, _) => Opacity(opacity: value, child: child),
//     );
//   }
// }

// class SlideIn extends StatelessWidget {
//   final Widget child;
//   SlideIn({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder(
//       tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
//       duration: Duration(milliseconds: 500),
//       builder: (context, offset, _) =>
//           Transform.translate(offset: offset * 20, child: child),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/order_detail/model/order_model.dart';
import 'package:haqmate/features/orders/model/order.dart'
    hide PaymentStatus, OrderStatus;
import 'package:haqmate/features/orders/widgets/status_badge.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../viewmodel/order_viewmodel.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderdetailViewModel>().loadorderdetail(widget.orderId);
    });
  }

  // Helper method to translate English statuses to Amharic
  String _translateStatus(String status) {
    const translations = {
      'PENDING': 'በመጠባበቅ ላይ',
      'PROCESSING': 'በማቀናበር ላይ',
      'CONFIRMED': 'ተረጋግጧል',
      'SHIPPED': 'ተላክቷል',
      'DELIVERED': 'ደርሷል',
      'COMPLETED': 'ተጠናቋል',
      'CANCELLED': 'ተሰርዟል',
      'PAID': 'ተከፍሏል',
      'PENDING_PAYMENT': 'በመክፈል ላይ',
      'DECLINED': 'ተገፎታል',
      'REFUNDED': 'ተመላሽ ተደርጓል',
      'FAILED': 'አልተሳካም',
      'TO_BE_DELIVERED': 'ለመላክ',
      'DELIVERY_SCHEDULED': 'የመላኪያ ቀን ተረጋግጣል',
      'PAYMENT_CONFIRMED': 'የክፍያ ተረጋግጣል',
      'PAYMENT_SUBMITTED': 'ክፍያ ተሰጥቷል',
    };
    final key = status.toUpperCase();
    return translations[key] ?? status;
  }

  // Format date in Amharic style
  String _formatDate(Object? date) {
    if (date == null) return '';
    DateTime? parsed;
    if (date is DateTime) {
      parsed = date;
    } else if (date is String) {
      parsed = DateTime.tryParse(date);
    } else if (date is int) {
      parsed = DateTime.fromMillisecondsSinceEpoch(date);
    }
    if (parsed == null) return '';
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

    return '${parsed.day} ${monthNames[parsed.month - 1]} ${parsed.year}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderdetailViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "የትዕዛዝ ዝርዝር",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, OrderdetailViewModel vm) {
    // Loading state
    if (vm.loading) {
      return _buildLoadingState();
    }

    // Error state
    if (vm.error != null) {
      return _buildErrorState(vm);
    }

    // No order found
    if (vm.order == null) {
      return _buildEmptyState();
    }

    // Success state with data
    return _buildSuccessState(context, vm);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            'የትዕዛዝ ዝርዝር በመጫን ላይ...',
            style: TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(OrderdetailViewModel vm) {
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
              onPressed: () => vm.loadorderdetail(widget.orderId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              color: AppColors.textLight,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'ትዕዛዝ አልተገኘም',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'የተጠቀሰው ትዕዛዝ አልተገኘም።',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, OrderdetailViewModel vm) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Order ID Card
          _buildOrderIdCard(vm),

          const SizedBox(height: 16),

          // Status Timeline
          _buildStatusTimeline(vm),

          const SizedBox(height: 16),

          // Payment Section
          _buildPaymentSection(vm),

          const SizedBox(height: 16),

          // Order Items
          _buildOrderItems(vm),

          const SizedBox(height: 16),

          // Delivery Address
          _buildDeliveryAddress(vm),

          const SizedBox(height: 16),

          // Contact Button
          _buildContactButton(vm),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOrderIdCard(OrderdetailViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'የትዕዛዝ መለያ',
                  style: TextStyle(fontSize: 12, color: AppColors.textLight),
                ),
                Text(
                  vm.order!.merchOrderId,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(vm.order!.createdAt),
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(OrderdetailViewModel vm) {
    final tracking = vm.order!.tracking;
    if (tracking.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'የክትትል መረጃ አልተገኘም',
            style: TextStyle(color: AppColors.textLight),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                "የትዕዛዝ ሁኔታ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Column(
            children: List.generate(tracking.length, (index) {
              final step = tracking[index];
              final isLast = index == tracking.length - 1;
              final isCompleted = step.completed;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline dot
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),

                      // Step details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _translateStatus(step.title),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (step.date != null)
                              Text(
                                _formatDate(step.date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Connector line
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 30,
                      color: isCompleted
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      margin: const EdgeInsets.only(
                        left: 10,
                        top: 8,
                        bottom: 8,
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(OrderdetailViewModel vm) {
    final order = vm.order!;
    final paymentStatus = _translateStatus(order.paymentstatus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'የክፍያ ሁኔታ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status Badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(label: order.paymentstatus),
              if (vm.showRefundTag) StatusBadge(label: order.refundstatus),
              if (vm.deliveryStatusTagLabel != null)
                StatusBadge(label: vm.deliveryStatusTagLabel!),
            ],
          ),

          // Payment Proof
          if (vm.showPaymentProof && order.paymentProofUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'የክፍያ ማረጋገጫ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                order.paymentProofUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: AppColors.background,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: AppColors.background,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textLight,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ምስሉ ሊጫን አልቻለም',
                            style: TextStyle(color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Decline Reason
          if (vm.showDeclineReason && order.cancelReason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red.shade600,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ምክንያት: ${order.cancelReason}',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItems(OrderdetailViewModel vm) {
    final order = vm.order!;
    final items = order.items;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'የትዕዛዝ ዕቃዎች',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (items.isEmpty)
            Center(
              child: Text(
                'ምንም ዕቃዎች የሉም',
                style: TextStyle(color: AppColors.textLight),
              ),
            )
          else
            ...items.map((item) => _buildOrderItem(item)),

          const SizedBox(height: 16),

          // Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'የምርቶች ዋጋ',
                  (order.totalAmount - order.deliveryFee) as double,
                ),
                const SizedBox(height: 8),
                _buildSummaryRow('የመላኪያ ክፍያ', order.deliveryFee as double),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  'ጠቅላላ',
                  order.totalAmount as double,
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItems item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: item.image.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(item.image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.image.isEmpty
                ? Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.textLight,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.packagingSize} ኪ.ግ • ${item.quantity} ቁጥር',
                  style: TextStyle(fontSize: 12, color: AppColors.textLight),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '${item.price} ብር',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppColors.textDark : AppColors.textLight,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} ብር',
          style: TextStyle(
            color: isTotal ? AppColors.primary : AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress(OrderdetailViewModel vm) {
    final order = vm.order!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'የማድረሻ አድራሻ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    color: AppColors.textLight,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.phoneNumber,
                    style: TextStyle(color: AppColors.textDark, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.place_outlined,
                    color: AppColors.textLight,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.location,
                      style: TextStyle(color: AppColors.textDark, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Scheduled delivery
          if (vm.deliveryDateFormatted != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'የታቀደ መላኪያ: ${vm.deliveryDateFormatted}',
                      style: TextStyle(color: AppColors.textDark, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactButton(OrderdetailViewModel vm) {
    return CustomButton(
      label: 'ድርጅቱን ያነጋግሩ',
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      onPressed: () => vm.callSeller('+251985272557'),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      icon: Icon(Icons.phone_outlined, color: Colors.white, size: 20),
    );
  }
}
