// class OrdersViewModel extends ChangeNotifier {
//   final OrdersRepository _repo;

//   OrdersViewModel(this._repo);

//   final Map<String, bool> _cancelLoading = {};

//   bool isCancelling(String orderId) => _cancelLoading[orderId] == true;

//   // --------------------------------
//   // Cancel Order
//   // --------------------------------
//   Future<void> cancelOrder(BuildContext context, String orderId) async {
//     _cancelLoading[orderId] = true;
//     notifyListeners();

//     try {
//       // 1️⃣ Cancel order
//       await _repo.cancelOrder(orderId);

//       _cancelLoading[orderId] = false;
//       notifyListeners();

//       if (!context.mounted) return;

//       // 2️⃣ Ask for refund BEFORE refreshing list
//       final shouldRequest = await showDialog<bool>(
//         context: context,
//         barrierDismissible: false,
//         builder: (ctx) {
//           return AlertDialog(
//             title: const Text('Order Canceled'),
//             content: const Text(
//               'Your order was successfully canceled.\n\nDo you want to request a refund?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(ctx, false),
//                 child: const Text('No'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(ctx, true),
//                 child: const Text('Yes'),
//               ),
//             ],
//           );
//         },
//       );

//       if (!context.mounted) return;

//       if (shouldRequest == true) {
//         await _showRefundDialog(context, orderId);
//       }

//       // 3️⃣ Refresh AFTER dialogs complete
//       await load(refresh: true);

//     } catch (e) {
//       _cancelLoading[orderId] = false;
//       notifyListeners();

//       if (!context.mounted) return;

//       await showDialog<void>(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: const Text('Cancellation Failed'),
//           content: Text(e.toString()),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Close'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(ctx);
//                 cancelOrder(context, orderId);
//               },
//               child: const Text('Try Again'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // --------------------------------
//   // Refund Dialog
//   // --------------------------------
//   Future<void> _showRefundDialog(
//       BuildContext context, String orderId) async {

//     final accNameCtrl = TextEditingController();
//     final accNumberCtrl = TextEditingController();
//     final reasonCtrl = TextEditingController();

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) {
//         bool submitting = false;

//         return StatefulBuilder(
//           builder: (ctx, setState) {
//             return AlertDialog(
//               title: const Text('Request Refund'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: accNameCtrl,
//                       decoration:
//                           const InputDecoration(labelText: 'Account Name'),
//                     ),
//                     TextField(
//                       controller: accNumberCtrl,
//                       keyboardType: TextInputType.number,
//                       decoration:
//                           const InputDecoration(labelText: 'Account Number'),
//                     ),
//                     TextField(
//                       controller: reasonCtrl,
//                       decoration:
//                           const InputDecoration(labelText: 'Reason'),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: submitting
//                       ? null
//                       : () => Navigator.pop(ctx),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: submitting
//                       ? null
//                       : () async {
//                           if (accNameCtrl.text.trim().isEmpty ||
//                               accNumberCtrl.text.trim().isEmpty ||
//                               reasonCtrl.text.trim().isEmpty) {
//                             if (!context.mounted) return;
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content:
//                                       Text('Please fill all fields')),
//                             );
//                             return;
//                           }

//                           setState(() => submitting = true);

//                           try {
//                             await _repo.requestRefund(
//                               orderId: orderId,
//                               accountName: accNameCtrl.text.trim(),
//                               accountNumber:
//                                   accNumberCtrl.text.trim(),
//                               reason: reasonCtrl.text.trim(),
//                             );

//                             if (!context.mounted) return;

//                             Navigator.pop(ctx);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                     'Refund requested successfully'),
//                               ),
//                             );
//                           } catch (e) {
//                             setState(() => submitting = false);

//                             if (!context.mounted) return;

//                             showDialog<void>(
//                               context: context,
//                               builder: (ctx2) => AlertDialog(
//                                 title:
//                                     const Text('Refund Failed'),
//                                 content: Text(e.toString()),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () =>
//                                         Navigator.pop(ctx2),
//                                     child:
//                                         const Text('Close'),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                         },
//                   child: submitting
//                       ? const SizedBox(
//                           height: 16,
//                           width: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text('Refund'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   // --------------------------------
//   // Load Orders
//   // --------------------------------
//   Future<void> load({bool refresh = false}) async {
//     await _repo.loadOrders(refresh: refresh);
//     notifyListeners();
//   }
// }
