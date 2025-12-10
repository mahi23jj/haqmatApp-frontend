// checkout_view.dart
import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/checkout/service/checkout_service.dart';
import 'package:haqmate/features/checkout/viewmodel/checkout_viewmodel.dart';
import 'package:provider/provider.dart';



class CheckoutView extends StatelessWidget {
  /// Pass cart snapshot from Cart page
  final CartModelList cart;


  const CheckoutView({
    Key? key,
    required this.cart,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutViewModel>(
      create: (_) {},
      child: Consumer<CheckoutViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Checkout'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Location + search-as-you-type
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on_outlined),
                                SizedBox(width: 8),
                                Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // search field
                            TextField(
                              decoration: InputDecoration(
                                hintText: vm.selectedLocation?.name ?? 'Search location...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                suffixIcon: vm.loadingSuggestions ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                                ) : null,
                              ),
                              onChanged: vm.searchLocations,
                            ),
                            // suggestions list
                            if (vm.suggestions.isNotEmpty)
                              Container(
                                constraints: const BoxConstraints(maxHeight: 150),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: vm.suggestions.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (_, idx) {
                                    final loc = vm.suggestions[idx];
                                    return ListTile(
                                      title: Text(loc.name),
                                      subtitle: Text('Delivery: ${loc.deliveryFee}'),
                                      onTap: () => vm.selectLocation(loc),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 8),
                            // show chosen location and allow editing detail (optional)
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: vm.selectedLocation?.name,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Selected location',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: vm.cart.phoneNumber,
                                    decoration: InputDecoration(
                                      labelText: 'Phone number',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onChanged: vm.updatePhone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: vm.saveAsDefault,
                                  onChanged: (v) => vm.toggleSaveAsDefault(v ?? false),
                                ),
                                const Text('Save as my default for future orders'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Items summary
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Order items', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: vm.cart.items.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final it = vm.cart.items[index];
                                    return ListTile(
                                      leading: it.imageUrl.isNotEmpty
                                          ? Image.network(it.imageUrl, width: 56, height: 56, fit: BoxFit.cover)
                                          : Container(width: 56, height: 56, color: Colors.grey[200]),
                                      title: Text(it.name),
                                      subtitle: Text('Pack: ${it.packaging} • Qty: ${it.quantity}'),
                                      trailing: Text('${it.totalprice}'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

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
                                Text('Delivery: ${vm.deliveryFee}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                Text('Total: ${vm.total}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: vm.processingOrder
                                  ? null
                                  : () async {
                                    /*   final ok = await vm.placeOrder();
                                      if (ok) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Order placed successfully')),
                                        );
                                        // navigate away or clear cart as needed
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(vm.errorMessage ?? 'Failed to place order')),
                                        );
                                      } */
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: vm.processingOrder ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Place Order'),
                            ),
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
