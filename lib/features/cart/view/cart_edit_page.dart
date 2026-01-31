// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/cart/model/cartmodel.dart';
// import 'package:haqmate/features/cart/viewmodel/cart_edit_viewmodel.dart';
// import 'package:haqmate/core/widgets/custom_button.dart';
// import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:another_flushbar/flushbar.dart';

// class ProductOptionBottomSheet extends StatefulWidget {
//   final CartModel cartitem;
//   const ProductOptionBottomSheet({super.key, required this.cartitem});

//   @override
//   State<ProductOptionBottomSheet> createState() =>
//       _ProductOptionBottomSheetState();
// }

// class _ProductOptionBottomSheetState extends State<ProductOptionBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) {
//         final vm = ProductOptionViewModel();
//         vm.initFromCartItem(widget.cartitem);
//         vm.loadOptions(widget.cartitem.productId);
//         return vm;
//       },
//       child: Consumer<ProductOptionViewModel>(
//         builder: (context, vm, _) {
//           if (vm.isLoading || vm.options == null) {
//             return Container(
//               height: 300,
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(28),
//                   topRight: Radius.circular(28),
//                 ),
//               ),
//               child: Center(
//                 child: CircularProgressIndicator(color: AppColors.primary),
//               ),
//             );
//           }

//           final productName = vm.options!
//               .map((e) => e.id == vm.selectedTeffTypeId ? e.name : '')
//               .firstWhere((element) => element.isNotEmpty);

//           return FractionallySizedBox(
//             heightFactor: 0.6,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(28),
//                   topRight: Radius.circular(28),
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Header with drag handle
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: AppColors.textLight.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Content
//                   Expanded(
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 16,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Product name header
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 16,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColors.textDark.withOpacity(0.05),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.primary.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Icon(
//                                     Icons.shopping_bag_outlined,
//                                     color: AppColors.primary,
//                                     size: 20,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     productName,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.textDark,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           // Teff Type Section
//                           _buildSectionHeader(
//                             title: "Teff Type",
//                             subtitle: "Select the type of teff",
//                           ),
//                           const SizedBox(height: 12),

//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColors.textDark.withOpacity(0.05),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 1),
//                                 ),
//                               ],
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: vm.selectedTeffTypeId,
//                                 isExpanded: true,
//                                 dropdownColor: Colors.white,
//                                 borderRadius: BorderRadius.circular(16),
//                                 icon: Icon(
//                                   Icons.keyboard_arrow_down_rounded,
//                                   color: AppColors.textLight,
//                                 ),
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: AppColors.textDark,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 items: vm.options!.map((t) {
//                                   return DropdownMenuItem(
//                                     value: t.id,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 12,
//                                       ),
//                                       child: Text(
//                                         t.name,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           color: AppColors.textDark,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) => vm.selectTeffType(value!),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           // Packaging Size Section
//                           _buildSectionHeader(
//                             title: "Packaging Size",
//                             subtitle: "Choose or customize the weight",
//                           ),
//                           const SizedBox(height: 12),

//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColors.textDark.withOpacity(0.05),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 1),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 children: [
//                                   Wrap(
//                                     spacing: 10,
//                                     runSpacing: 10,
//                                     children: List.generate(vm.weights.length + 1, (
//                                       i,
//                                     ) {
//                                       final isCustom = i == vm.weights.length;
//                                       final isSelected = isCustom
//                                           ? vm.selectedWeightIndex == -1
//                                           : vm.selectedWeightIndex == i;

//                                       final label = isCustom
//                                           ? (vm.customWeight != null
//                                                 ? '${vm.customWeight} kg'
//                                                 : 'Custom')
//                                           : vm.weights[i].label;

//                                       return _buildWeightChip(
//                                         label: label,
//                                         isSelected: isSelected,
//                                         isCustom: isCustom,
//                                         onTap: () async {
//                                           if (isCustom) {
//                                             final controller =
//                                                 TextEditingController(
//                                                   text: vm.customWeight ?? '',
//                                                 );
//                                             final custom = await showDialog<String>(
//                                               context: context,
//                                               builder: (context) {
//                                                 return AlertDialog(
//                                                   backgroundColor:
//                                                       AppColors.background,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           20,
//                                                         ),
//                                                   ),
//                                                   title: const Text(
//                                                     'Custom Weight',
//                                                     style: TextStyle(
//                                                       color: AppColors.textDark,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                   content: TextField(
//                                                     controller: controller,
//                                                     keyboardType:
//                                                         TextInputType.number,
//                                                     decoration: InputDecoration(
//                                                       hintText:
//                                                           'Enter weight in kg',
//                                                       filled: true,
//                                                       fillColor: Colors.white,
//                                                       border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               12,
//                                                             ),
//                                                         borderSide: BorderSide(
//                                                           color: AppColors
//                                                               .textLight
//                                                               .withOpacity(0.3),
//                                                         ),
//                                                       ),
//                                                       focusedBorder:
//                                                           OutlineInputBorder(
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                   12,
//                                                                 ),
//                                                             borderSide:
//                                                                 BorderSide(
//                                                                   color: AppColors
//                                                                       .primary,
//                                                                   width: 2,
//                                                                 ),
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   actions: [
//                                                     TextButton(
//                                                       onPressed: () =>
//                                                           Navigator.pop(
//                                                             context,
//                                                           ),
//                                                       child: const Text(
//                                                         'Cancel',
//                                                         style: TextStyle(
//                                                           color: AppColors
//                                                               .textLight,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TextButton(
//                                                       onPressed: () =>
//                                                           Navigator.pop(
//                                                             context,
//                                                             controller.text
//                                                                 .trim(),
//                                                           ),
//                                                       child: Text(
//                                                         'Save',
//                                                         style: TextStyle(
//                                                           color:
//                                                               AppColors.primary,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             );

//                                             if (custom != null &&
//                                                 custom.trim().isNotEmpty) {
//                                               vm.selectWeight(
//                                                 i,
//                                                 customValue: custom,
//                                               );
//                                             }
//                                           } else {
//                                             vm.selectWeight(i);
//                                           }
//                                         },
//                                       );
//                                     }),
//                                   ),
//                                   if (vm.customWeight != null &&
//                                       vm.selectedWeightIndex == -1)
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 12),
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                           vertical: 10,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.primary.withOpacity(
//                                             0.1,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                           border: Border.all(
//                                             color: AppColors.primary
//                                                 .withOpacity(0.3),
//                                             width: 1,
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const Text(
//                                               'Custom Weight:',
//                                               style: TextStyle(
//                                                 color: AppColors.textDark,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             Text(
//                                               '${vm.customWeight} kg',
//                                               style: TextStyle(
//                                                 color: AppColors.primary,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           // Quantity Section
//                           _buildSectionHeader(
//                             title: "Quantity",
//                             subtitle: "Select how many you need",
//                           ),
//                           const SizedBox(height: 12),

//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColors.textDark.withOpacity(0.05),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 1),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   _buildQuantityButton(
//                                     icon: Icons.remove,
//                                     onTap: vm.prevQuantity,
//                                     isEnabled: vm.quantity > 1,
//                                   ),
//                                   Container(
//                                     width: 60,
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       vm.quantity.toString(),
//                                       style: const TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w700,
//                                         color: AppColors.textDark,
//                                       ),
//                                     ),
//                                   ),
//                                   _buildQuantityButton(
//                                     icon: Icons.add,
//                                     onTap: vm.nextQuantity,
//                                     isEnabled: true,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 32),

//                           // Current Selection Summary
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: AppColors.primary.withOpacity(0.05),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: AppColors.primary.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Current Selection',
//                                       style: TextStyle(
//                                         color: AppColors.textLight,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       productName,
//                                       style: const TextStyle(
//                                         color: AppColors.textDark,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       '${vm.selectedPackagingSize} kg',
//                                       style: const TextStyle(
//                                         color: AppColors.textDark,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Text(
//                                       '× ${vm.quantity}',
//                                       style: TextStyle(
//                                         color: AppColors.textLight,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Apply Button Section
//                   Container(
//                     padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.textDark.withOpacity(0.1),
//                           blurRadius: 20,
//                           offset: const Offset(0, -5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Total Price',
//                               style: TextStyle(
//                                 color: AppColors.textDark,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               '\$${(widget.cartitem.totalprice * vm.quantity).toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         CustomButton(
//                           label: 'Apply Changes',
//                           width: double.infinity,
//                           height: 56,
//                           backgroundColor: AppColors.primary,
//                           borderRadius: BorderRadius.circular(16),
//                           onPressed: () async {
//                             try {
//                               await context.read<CartViewModel>().updateItem(
//                                 id: widget.cartitem.id,
//                                 productId: vm.selectedTeffTypeId,
//                                 quantity: vm.quantity,
//                                 packagingSize: vm.selectedPackagingSize,
//                               );

//                               if (!mounted) return;
//                               await Flushbar(
//                                 message: 'Cart updated successfully',
//                                 duration: const Duration(seconds: 2),
//                                 backgroundColor: Colors.green.shade600,
//                                 margin: const EdgeInsets.all(12),
//                                 borderRadius: BorderRadius.circular(12),
//                               ).show(context);

//                               if (mounted) {
//                                 Navigator.pop(context, {
//                                   "teffTypeId": vm.selectedTeffTypeId,
//                                   "weight": vm.selectedPackagingSize,
//                                   "quantity": vm.quantity,
//                                 });
//                               }
//                             } catch (e) {
//                               if (!mounted) return;
//                               Flushbar(
//                                 message: e.toString(),
//                                 duration: const Duration(seconds: 3),
//                                 backgroundColor: Colors.red.shade600,
//                                 margin: const EdgeInsets.all(12),
//                                 borderRadius: BorderRadius.circular(12),
//                               ).show(context);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSectionHeader({required String title, String? subtitle}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textDark,
//           ),
//         ),
//         if (subtitle != null) ...[
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(fontSize: 13, color: AppColors.textLight),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildWeightChip({
//     required String label,
//     required bool isSelected,
//     required bool isCustom,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppColors.primary
//               : isCustom
//               ? AppColors.accent.withOpacity(0.1)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? AppColors.primary
//                 : isCustom
//                 ? AppColors.accent.withOpacity(0.3)
//                 : AppColors.textLight.withOpacity(0.2),
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: isSelected ? Colors.white : AppColors.textDark,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuantityButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     required bool isEnabled,
//   }) {
//     return GestureDetector(
//       onTap: isEnabled ? onTap : null,
//       child: Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: isEnabled
//               ? AppColors.primary.withOpacity(0.1)
//               : AppColors.textLight.withOpacity(0.1),
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: isEnabled
//                 ? AppColors.primary.withOpacity(0.3)
//                 : AppColors.textLight.withOpacity(0.2),
//           ),
//         ),
//         child: Icon(
//           icon,
//           color: isEnabled ? AppColors.primary : AppColors.textLight,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/cart/viewmodel/cart_edit_viewmodel.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

class ProductOptionBottomSheet extends StatefulWidget {
  final CartModel cartitem;
  const ProductOptionBottomSheet({super.key, required this.cartitem});

  @override
  State<ProductOptionBottomSheet> createState() =>
      _ProductOptionBottomSheetState();
}

class _ProductOptionBottomSheetState extends State<ProductOptionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ProductOptionViewModel();
        vm.initFromCartItem(widget.cartitem);
        vm.loadOptions(widget.cartitem.productId);
        return vm;
      },
      child: Consumer<ProductOptionViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading || vm.options == null) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'ምርቶች በመጫን ላይ...',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (vm.error != null) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade600,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      vm.error!,
                      style: TextStyle(
                        color: AppColors.textDark,
                       // textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: 'እንደገና ይሞክሩ',
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      onPressed: () => vm.loadOptions(widget.cartitem.productId),
                    ),
                  ],
                ),
              ),
            );
          }

          if (vm.options!.isEmpty) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.textLight,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ምንም የማምረቻ አማራጭ አልተገኘም',
                      style: TextStyle(
                        color: AppColors.textDark,
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final productName = vm.options!
              .map((e) => e.id == vm.selectedTeffTypeId ? e.name : '')
              .firstWhere((element) => element.isNotEmpty, orElse: () => '');

          return FractionallySizedBox(
            heightFactor: 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with drag handle
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textDark.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Teff Type Section
                          _buildSectionHeader(
                            title: "የጤፍ አይነት",
                            subtitle: "የጤፉን አይነት ይምረጡ",
                          ),
                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textDark.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: vm.selectedTeffTypeId,
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textLight,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: vm.options!.map((t) {
                                  return DropdownMenuItem(
                                    value: t.id,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        t.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) => vm.selectTeffType(value!),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Packaging Size Section
                          _buildSectionHeader(
                            title: "የመጠን አሰራር",
                            subtitle: "መጠኑን ይምረጡ ወይም የራስዎን ያስገቡ",
                          ),
                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textDark.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(vm.weights.length + 1, (i) {
                                      final isCustom = i == vm.weights.length;
                                      final isSelected = isCustom
                                          ? vm.selectedWeightIndex == -1
                                          : vm.selectedWeightIndex == i;

                                      final label = isCustom
                                          ? (vm.customWeight != null
                                                ? '${vm.customWeight} ኪ.ግ'
                                                : 'ሌላ መጠን')
                                          : vm.weights[i].label;

                                      return _buildWeightChip(
                                        label: label,
                                        isSelected: isSelected,
                                        isCustom: isCustom,
                                        onTap: () async {
                                          if (isCustom) {
                                            final controller = TextEditingController(
                                              text: vm.customWeight ?? '',
                                            );
                                            final custom = await showDialog<String>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  title: Text(
                                                    'የራስህን መጠን አስገባ',
                                                    style: TextStyle(
                                                      color: AppColors.textDark,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  content: TextField(
                                                    controller: controller,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      hintText: 'መጠን በኪ.ግ',
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      prefixIcon: Icon(Icons.scale_outlined, color: AppColors.primary),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text(
                                                        'ሰርዝ',
                                                        style: TextStyle(color: AppColors.textLight),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppColors.primary,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        if (controller.text.trim().isNotEmpty) {
                                                          vm.selectWeight(i, customValue: controller.text);
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('አስገባ'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (custom != null && custom.trim().isNotEmpty) {
                                              vm.selectWeight(i, customValue: custom);
                                            }
                                          } else {
                                            vm.selectWeight(i);
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                  if (vm.customWeight != null && vm.selectedWeightIndex == -1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.primary.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'የራስህ መጠን:',
                                              style: TextStyle(
                                                color: AppColors.textDark,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${vm.customWeight} ኪ.ግ',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Quantity Section
                          _buildSectionHeader(
                            title: "ብዛት",
                            subtitle: "ስንት እንደሚፈልጉ ይምረጡ",
                          ),
                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textDark.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onTap: vm.prevQuantity,
                                    isEnabled: vm.quantity > 1,
                                  ),
                                  Container(
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: Text(
                                      vm.quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onTap: vm.nextQuantity,
                                    isEnabled: true,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Current Selection Summary
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'የተመረጠው',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      productName,
                                      style: const TextStyle(
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${vm.selectedPackagingSize} ኪ.ግ',
                                      style: const TextStyle(
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '× ${vm.quantity}',
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Apply Button Section
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textDark.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
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
                                color: AppColors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'ብር${(widget.cartitem.totalprice * vm.quantity).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          label: 'ለውጦችን አስገባ',
                          width: double.infinity,
                          height: 56,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          onPressed: () async {
                            try {
                              await context.read<CartViewModel>().updateItem(
                                id: widget.cartitem.id,
                                productId: vm.selectedTeffTypeId,
                                quantity: vm.quantity,
                                packagingSize: vm.selectedPackagingSize,
                              );

                              if (!mounted) return;
                              await Flushbar(
                                message: 'የግዢ ቋት ተዘምኗል',
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green.shade600,
                                margin: const EdgeInsets.all(12),
                                borderRadius: BorderRadius.circular(12),
                              ).show(context);

                              if (mounted) {
                                Navigator.pop(context, {
                                  "teffTypeId": vm.selectedTeffTypeId,
                                  "weight": vm.selectedPackagingSize,
                                  "quantity": vm.quantity,
                                });
                              }
                            } catch (e) {
                              if (!mounted) return;
                              Flushbar(
                                message: 'ስህተት: $e',
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red.shade600,
                                margin: const EdgeInsets.all(12),
                                borderRadius: BorderRadius.circular(12),
                              ).show(context);
                            }
                          },
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

  Widget _buildSectionHeader({required String title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
        ],
      ],
    );
  }

  Widget _buildWeightChip({
    required String label,
    required bool isSelected,
    required bool isCustom,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isCustom
                  ? AppColors.accent.withOpacity(0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isCustom
                    ? AppColors.accent.withOpacity(0.3)
                    : AppColors.textLight.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.textLight.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isEnabled
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.textLight.withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          color: isEnabled ? AppColors.primary : AppColors.textLight,
          size: 20,
        ),
      ),
    );
  }
}