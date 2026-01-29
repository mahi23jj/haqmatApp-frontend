// import 'package:flutter/material.dart';

// class PaymentMethodCard extends StatefulWidget {
//   final Function(String) onSelected;

//   const PaymentMethodCard({super.key, required this.onSelected});

//   @override
//   State<PaymentMethodCard> createState() => _PaymentMethodCardState();
// }

// class _PaymentMethodCardState extends State<PaymentMethodCard> {
//   String? selectedMethod;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Payment Method",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 12),

//             // Chapa
//             /* RadioListTile<String>(
//               value: "Chapa",
//               groupValue: selectedMethod,
//               title: const Text("Chapa"),
//               onChanged: (value) {
//                 setState(() {
//                   selectedMethod = value;
//                 });
//                 widget.onSelected(value!);
//               },
//             ),

//             // Telebirr
//             RadioListTile<String>(
//               value: "Telebirr",
//               groupValue: selectedMethod,
//               title: const Text("Telebirr"),
//               onChanged: (value) {
//                 setState(() {
//                   selectedMethod = value;
//                 });
//                 widget.onSelected(value!);
//               },
//             ), */

//             // Send Screenshot
//             RadioListTile<String>(
//               value: "Send Screenshot",
//               groupValue: selectedMethod,
//               title: const Text("Send Screenshot"),
//               onChanged: (value) {
//                 setState(() {
//                   selectedMethod = value;
//                 });
//                 widget.onSelected(value!);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// payment_method_card.dart
import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class PaymentMethodCard extends StatefulWidget {
  final Function(String) onSelected;

  const PaymentMethodCard({super.key, required this.onSelected});

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  String? selectedMethod;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'bank_transfer',
      'title': 'ወደ ባንክ ማስተላለፍ',
      'description': 'በባንክ ተለዋዋጭ ክፍያ',
      'icon': Icons.account_balance_outlined,
      'color': AppColors.primary,
    },
    {
      'id': 'telebirr',
      'title': 'ቴሌብር',
      'description': 'በሞባይል ማንኛውንም ስፍራ',
      'icon': Icons.phone_android_outlined,
      'color': AppColors.secondary,
    },
    {
      'id': 'cash_on_delivery',
      'title': 'በመድረሻ ክፍያ',
      'description': 'ትዕዛዙ በደረሰ ጊዜ ይክፈሉ',
      'icon': Icons.money_outlined,
      'color': AppColors.accent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment_outlined, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  "የክፍያ ዘዴ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Payment Methods
            ..._paymentMethods.map((method) {
              final isSelected = selectedMethod == method['id'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMethod = method['id'];
                  });
                  widget.onSelected(method['title']);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? method['color'].withOpacity(0.1)
                      : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? method['color'] : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: method['color'].withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          method['icon'],
                          color: method['color'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method['description'],
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: method['id'],
                        groupValue: selectedMethod,
                        activeColor: method['color'],
                        onChanged: (value) {
                          setState(() {
                            selectedMethod = value;
                          });
                          widget.onSelected(method['title']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 8),
            
            // Payment Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outlined, color: AppColors.accent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ሁሉም ክፍያዎች ደህንነታቸው የተጠበቀ ነው። የባንክ ዝርዝሮችን ከማስገባት በኋላ ያገኛሉ።',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}