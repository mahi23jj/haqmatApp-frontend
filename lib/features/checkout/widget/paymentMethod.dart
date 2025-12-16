import 'package:flutter/material.dart';

class PaymentMethodCard extends StatefulWidget {
  final Function(String) onSelected;

  const PaymentMethodCard({super.key, required this.onSelected});

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Chapa
            RadioListTile<String>(
              value: "Chapa",
              groupValue: selectedMethod,
              title: const Text("Chapa"),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
                widget.onSelected(value!);
              },
            ),

            // Telebirr
            RadioListTile<String>(
              value: "Telebirr",
              groupValue: selectedMethod,
              title: const Text("Telebirr"),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
                widget.onSelected(value!);
              },
            ),

            // Send Screenshot
            RadioListTile<String>(
              value: "Send Screenshot",
              groupValue: selectedMethod,
              title: const Text("Send Screenshot"),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
                widget.onSelected(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
