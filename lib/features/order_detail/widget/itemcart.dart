import 'package:flutter/material.dart';
import 'package:haqmate/features/order_detail/model/order_model.dart';


class ItemCard extends StatelessWidget {
  final OrderItem item ;
  const ItemCard({super.key, required this.item});

    BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 14),
            decoration: _boxDecoration(),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item.name),
              subtitle: Text("${item.packagingSize} kg\n${item.quantity} x"),
              trailing: Text(
                "${item.price} ETB",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
  }
}