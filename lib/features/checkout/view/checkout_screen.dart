// checkout_view.dart
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

class CheckoutView extends StatefulWidget {
  final CartModelList cart;
  final String orderrecived;
  const CheckoutView({
    super.key,
    required this.cart,
    required this.orderrecived,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  // final CheckoutService service;

  String selectedPayment = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutViewModel>(
      create: (_) => CheckoutViewModel()..initFromCart(widget.cart),
      child: Consumer<CheckoutViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Location + search-as-you-type
                    if (widget.orderrecived == 'Delivery')
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              TextField(
                                controller: vm.locationController,
                                decoration: InputDecoration(
                                  hintText: 'Search location...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: vm.loadingSuggestions
                                      ? const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                onChanged: vm.searchLocations,
                              ),

                              // 🔽 SUGGESTION DROP-DOWN
                              if (vm.suggestions.isNotEmpty)
                                Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 150,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: vm.suggestions.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 1),
                                    itemBuilder: (_, idx) {
                                      final loc = vm.suggestions[idx];
                                      return ListTile(
                                        title: Text(loc.name),
                                        subtitle: Text(
                                          'Delivery: ${loc.deliveryFee}',
                                        ),
                                        onTap: () => vm.selectLocation(loc),
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: 16),

                              // 📱 PHONE NUMBER
                              TextFormField(
                                controller: vm.phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // 💾 SAVE DEFAULT
                              CustomButton(
                                width: double.infinity,
                                label: 'Save as my default for future orders',
                                onPressed: () {
                                  vm.saveDefault(
                                    vm.selectedLocation?.id ?? '',
                                    vm.phoneController.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Items summary
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order items',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              itemCount: vm.cart.items.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final it = vm.cart.items[index];
                                return ListTile(
                                  leading: it.imageUrl.isNotEmpty
                                      ? Image.network(
                                          it.imageUrl,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey[200],
                                        ),
                                  title: Text(it.name),
                                  subtitle: Text(
                                    'Pack: ${it.packaging} • Qty: ${it.quantity}',
                                  ),
                                  trailing: Text('${it.totalprice}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                   /*  Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: 
                        
                        
                



                      ),
                    ), */

                    const SizedBox(height: 12),

                    PaymentMethodCard(
                      onSelected: (method) {
                        setState(() {
                          selectedPayment = method;
                        });
                        print("Selected payment: $method");
                      },
                    ),

                    // total + place order
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Subtotal: ${vm.subtotal}'),
                                Text(
                                  'Delivery: ${vm.deliveryFee}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'Total: ${vm.total}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            CustomButton(
                              label: 'Place Order',
                              onPressed: () async {
                                final products = vm.cart.items
                                    .map<Map<String, dynamic>>((e) => {
                                          "productId": e.productId,
                                          "quantity": e.quantity,
                                          "packagingsize": e.packaging,
                                        })
                                    .toList();

                                final paymentIntent = await context
                                    .read<CheckoutViewModel>()
                                    .createorder(
                                      products,
                                      vm.selectedLocation!.id,
                                      vm.phoneController.text.trim(),
                                      widget.orderrecived,
                                      selectedPayment,
                                    );

                                final orderId = paymentIntent?.id;

                                if (orderId != null && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ManualPaymentScreen(
                                        orderId: orderId,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),

                            /*  ElevatedButton(
                              onPressed: () async {
                                final List<Map<String, dynamic>> products = vm
                                    .cart
                                    .items
                                    .map<Map<String, dynamic>>((e) {
                                      return {
                                        "productId": e.productId,
                                        "quantity": e.quantity,
                                        "packagingsize": e.packaging,
                                      };
                                    })
                                    .toList();
                                final id = await context
                                    .read<OrdersViewModel>()
                                    .createorder(
                                      products,
                                      vm.selectedLocation!.id,
                                      vm.phoneController.text,
                                      widget.orderrecived,
                                      selectedPayment,
                                    );

                                // final vms = context.read<PaymentViewModel>();

                                // await vms.createChapaPayment(orderId: id);

                                // if (vm.chapaIntent != null) {
                                //   final checkoutUrl =
                                //       vm.chapaIntent!.clientSecret;

                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (_) => WebViewPaymentScreen(
                                //         url: checkoutUrl,
                                //       ),
                                //     ),
                                //   );
                                // }

                                if (vm.error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Order placed successfully ',
                                      ),
                                    ),
                                  );
                                  // navigate away or clear cart as needed
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        vm.error ?? 'Failed to place order',
                                      ),
                                    ),
                                  );
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child:
                                  /* vm.processingOrder
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  :  */
                                  const Text('Place Order'),
                            ), */
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
