import 'package:flutter/material.dart';
import 'package:haqmate/features/checkout/model/checkout_model.dart';
import 'package:haqmate/features/checkout/viewmodel/checkout_viewmodel.dart';
import 'package:provider/provider.dart';


class CheckoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CheckoutViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Delivery Address
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(width: 8),
                        Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    DropdownButton<Address>(
                      isExpanded: true,
                      value: vm.selectedAddress,
                      items: vm.addresses
                          .map((addr) => DropdownMenuItem(
                                value: addr,
                                child: Text(addr.location),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) vm.selectAddress(value);
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: vm.selectedAddress?.detail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.edit),
                      ),
                      onChanged: (value) {
                        if (vm.selectedAddress != null) {
                          vm.selectedAddress = Address(
                              location: vm.selectedAddress!.location,
                              detail: value);
                          vm.notifyListeners();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Payment Method
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline),
                        SizedBox(width: 8),
                        Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    ...vm.paymentMethods.map((method) {
                      bool selected = vm.selectedPayment == method;
                      return GestureDetector(
                        onTap: () => vm.selectPayment(method),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected ? Colors.brown[100] : Colors.transparent,
                            border: Border.all(color: selected ? Colors.brown : Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.payment),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(method.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(method.description, style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              Spacer(),
                              if (selected)
                                Icon(Icons.check_circle, color: Colors.brown),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Spacer(),
            // Total and Pay Now
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${vm.totalAmount.toStringAsFixed(2)}'),
                    Text('Delivery: \$${vm.deliveryFee.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => vm.payNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Pay Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
