import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/cart/viewmodel/cart_edit_viewmodel.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductOptionBottomSheet extends StatefulWidget {
  final CartModel cartitem;
  const ProductOptionBottomSheet({super.key, required this.cartitem});

  @override
  State<ProductOptionBottomSheet> createState() =>
      _ProductOptionBottomSheetState();
}

class _ProductOptionBottomSheetState extends State<ProductOptionBottomSheet> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Provider.of<ProductOptionViewModel>(context, listen: false).initFromCartItem(widget.cartitem);
  //   // Provider.of<ProductOptionViewModel>(context, listen: false).loadOptions(widget.cartitem.productId);
  // }

  // const ProductOptionBottomSheet({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ProductOptionViewModel();
        vm.initFromCartItem(widget.cartitem); // 👈 Initialize here
        vm.loadOptions(widget.cartitem.productId); // 👈 Also load here
        return vm;
      },
      child: Consumer<ProductOptionViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading || vm.options == null) {
            return SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final productname = vm.options!
              .map((e) => e.id == vm.selectedTeffTypeId ? e.name : '')
              .firstWhere((element) => element.isNotEmpty);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // display original product name
                Text(
                  productname,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                // 🔥 TEFF TYPE DROPDOWN
                Text(
                  "Teff Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                DropdownButton<String>(
                  value: vm.selectedTeffTypeId,
                  isExpanded: true,
                  items: vm.options!.map((t) {
                    return DropdownMenuItem(value: t.id, child: Text(t.name));
                  }).toList(),
                  onChanged: (value) => vm.selectTeffType(value!),
                ),

                const SizedBox(height: 20),

                // 🔥 PACKAGING SIZE (weight options)
                Text(
                  "Packaging Size",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  children: vm.weights.asMap().entries.map((entry) {
                    final index = entry.key;
                    final w = entry.value;

                    final isSelected = vm.selectedWeightIndex == index;

                    return ChoiceChip(
                      label: Text(w.label),
                      selected: isSelected,
                      onSelected: (_) => vm.selectWeight(index),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 🔥 QUANTITY
                Text(
                  "Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    IconButton(
                      onPressed: vm.prevQuantity,
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      vm.quantity.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: vm.nextQuantity,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 🔥 APPLY BUTTON
                CustomButton(
                  label: 'Apply Changes',
                  onPressed: () async {
                    await context.read<CartViewModel>().updateItem(
                      id: widget.cartitem.id,
                      productId: vm.selectedTeffTypeId,
                      quantity: vm.quantity,
                      packagingSize:
                          vm.weights[vm.selectedWeightIndex].multiplier,
                    );

                    Navigator.pop(context, {
                      "teffTypeId": vm.selectedTeffTypeId,
                      "weight": vm.weights[vm.selectedWeightIndex].multiplier,
                      "quantity": vm.quantity,
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
