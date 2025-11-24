import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({required this.status});

  Color get bg {
    switch (status) {
      case "Delivered":
        return Colors.green.shade100;
      case "Processing":
        return Colors.orange.shade100;
      case "Shipped":
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color get fg {
    switch (status) {
      case "Delivered":
        return Colors.green.shade700;
      case "Processing":
        return Colors.orange.shade700;
      case "Shipped":
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, color: fg),
      ),
    );
  }
}
