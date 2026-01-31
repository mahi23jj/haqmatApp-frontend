// checkout_view.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/checkout/service/checkout_service.dart';
import 'package:haqmate/features/checkout/view/chapa_webview.dart';
import 'package:haqmate/features/checkout/view/manual_payment_screen.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/checkout/viewmodel/chapa_viewmodel.dart';
import 'package:haqmate/features/checkout/viewmodel/checkout_viewmodel.dart';
import 'package:haqmate/features/checkout/widget/paymentMethod.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:haqmate/core/constants.dart';

class CheckoutView extends StatefulWidget {
  final CartModelList cart;
  final String orderType;
  const CheckoutView({super.key, required this.cart, required this.orderType});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPayment = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutViewModel>(
      create: (_) => CheckoutViewModel()..initFromCart(widget.cart),
      child: Consumer<CheckoutViewModel>(
        builder: (context, vm, _) {
          final deliveryFee =
              widget.orderType == 'Delivery' ? vm.deliveryFee : 0;
          final total = widget.orderType == 'Delivery'
              ? vm.total
              : vm.subtotal;

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
                'የግዢ ሂደት',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Progress Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    color: AppColors.primary.withOpacity(0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStep(1, 'አድራሻ', true),
                        _buildStepDivider(),
                        _buildStep(2, 'ትዕዛዝ', false),
                        _buildStepDivider(),
                        _buildStep(3, 'ክፍያ', false),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Delivery/Pickup Info
                          Container(
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
                                    widget.orderType == 'Delivery'
                                        ? Icons.delivery_dining
                                        : Icons.store,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.orderType == 'Delivery'
                                            ? 'ወደ አድራሻዎ እንደሚደርስ'
                                            : 'ከሱቅ ትወስዳለህ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        widget.orderType == 'Delivery'
                                            ? 'የመላኪያ ክፍያ ይታከላል'
                                            : 'ነፃ መውሰድ',
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
                          ),

                          const SizedBox(height: 20),

                          // Location Section for Delivery
                          if (widget.orderType == 'Delivery')
                            _buildDeliverySection(vm),

                          const SizedBox(height: 20),

                          // Order Items
                          _buildOrderItems(vm),

                          const SizedBox(height: 20),

                          // Payment Method
                          PaymentMethodCard(
                            onSelected: (method) {
                              setState(() {
                                selectedPayment = method;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          // Order Summary
                          _buildOrderSummary(vm, deliveryFee, total),
                        ],
                      ),
                    ),
                  ),

                  // Place Order Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ጠቅላላ ዋጋ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textLight,
                              ),
                            ),
                            Text(
                              'ብር${total}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          width: double.infinity,
                          label: vm.loading ? 'በመላክ ላይ...' : 'ትዕዛዝ አረጋግጥ',
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          loading: vm.loading,
                          onPressed: selectedPayment.isEmpty || vm.loading
                              ? null
                              : () => _placeOrder(context, vm),
                          borderRadius: BorderRadius.circular(12),
                          icon: vm.loading
                              ? null
                              : const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep(int number, String title, bool active) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: active ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? AppColors.primary : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Container(width: 40, height: 2, color: Colors.grey.shade300);
  }

  Widget _buildDeliverySection(CheckoutViewModel vm) {
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
              Icon(Icons.location_on_outlined, color: AppColors.primary),
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

          // Location Search
          TextField(
            controller: vm.locationController,
            decoration: InputDecoration(
              hintText: 'ከተማ ወይም አካባቢ ይፈልጉ...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: vm.loadingSuggestions
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            onChanged: vm.searchLocations,
          ),

          // Location Suggestions
          if (vm.suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: vm.suggestions.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (_, idx) {
                  final loc = vm.suggestions[idx];
                  return ListTile(
                    leading: Icon(
                      Icons.place_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(loc.name),
                    /* subtitle: Text(
                      'የመላኪያ ክፍያ: ብር${loc.deliveryFee}',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ), */
                    onTap: () => vm.selectLocation(loc),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          // Phone Number
          TextFormField(
            controller: vm.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'ስልክ ቁጥር',
              labelStyle: TextStyle(color: AppColors.textLight),
              hintText: '+251XXXXXXXXX',
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Save Default Button
          CustomButton(
            width: double.infinity,
            label: 'ለወደፊት ትዕዛዞች እንደ ነባር አድራሻ አስቀምጥ',
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.primary,
            onPressed: () {
              if (vm.selectedLocation != null &&
                  vm.phoneController.text.isNotEmpty) {
                vm.saveDefault(
                  vm.selectedLocation!.id,
                  vm.phoneController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('አድራሻ ተስተካክሏል'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(CheckoutViewModel vm) {
    final items = vm.cart.items;

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
              Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'የትዕዛዝ ዝርዝር',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.background,
                        image: item.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(item.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: item.imageUrl.isEmpty
                          ? Icon(
                              Icons.image_outlined,
                              color: Colors.grey.shade400,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ብዛት: ${item.quantity} • አሰራር: ${item.packaging}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'ብር${item.totalprice}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          /// 🔑 NON-SCROLLABLE LIST + FADE
          /*  ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0.0, 0.7, 0.85, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: 
          ), */
        ],
      ),
    );
  }

  // Widget _buildOrderItems(CheckoutViewModel vm) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
  //             const SizedBox(width: 8),
  //             Text(
  //               'የትዕዛዝ ዝርዝር',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.textDark,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),

  //         SizedBox(
  //           height: 220,
  //           child: ListView.separated(
  //             itemCount: vm.cart.items.length,
  //             separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),
  //             itemBuilder: (context, index) {
  //               final item = vm.cart.items[index];
  //               return Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: 60,
  //                       height: 60,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(12),
  //                         color: AppColors.background,
  //                         image: item.imageUrl.isNotEmpty
  //                             ? DecorationImage(
  //                                 image: NetworkImage(item.imageUrl),
  //                                 fit: BoxFit.cover,
  //                               )
  //                             : null,
  //                       ),
  //                       child: item.imageUrl.isEmpty
  //                           ? Icon(
  //                               Icons.image_outlined,
  //                               color: Colors.grey.shade400,
  //                             )
  //                           : null,
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             item.name,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               color: AppColors.textDark,
  //                             ),
  //                             maxLines: 2,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             'ብዛት: ${item.quantity} • አሰራር: ${item.packaging}',
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: AppColors.textLight,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Text(
  //                       'ብር${item.totalprice}',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColors.textDark,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOrderSummary(
    CheckoutViewModel vm,
    int deliveryFee,
    int total,
  ) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('የምርቶች ዋጋ', style: TextStyle(color: AppColors.textLight)),
              Text(
                'ብር${vm.subtotal}',
                style: TextStyle(color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('የመላኪያ ክፍያ', style: TextStyle(color: AppColors.textLight)),
              Text(
                'ብር${deliveryFee}',
                style: TextStyle(color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (widget.orderType != 'Delivery')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ነፃ መውሰድ', style: TextStyle(color: Colors.green)),
                Text('ብር0.00', style: TextStyle(color: Colors.green)),
              ],
            ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ጠቅላላ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'ብር${total}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context, CheckoutViewModel vm) async {
    if (widget.orderType == 'Delivery' && vm.selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('እባክዎ አድራሻ ይምረጡ'), backgroundColor: Colors.red),
      );
      return;
    }

    if (vm.phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('እባክዎ ስልክ ቁጥር ያስገቡ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedPayment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('እባክዎ የክፍያ ዘዴ ይምረጡ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final products = vm.cart.items
        .map<Map<String, dynamic>>(
          (e) => {
            "productId": e.productId,
            "quantity": e.quantity,
            "packagingsize": e.packaging,
          },
        )
        .toList();

    try {
      final paymentIntent = await vm.createorder(
        products,
        vm.selectedLocation?.id ?? '',
        vm.phoneController.text.trim(),
        widget.orderType,
        selectedPayment,
      );

      final orderId = paymentIntent?.id;

      if (orderId != null && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ManualPaymentScreen(orderId: orderId),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ትዕዛዝ ላለማቅረብ ስህተት: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
