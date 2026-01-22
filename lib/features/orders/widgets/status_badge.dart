import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  // Optional: kept for compatibility with older calls that pass `status`.
  final String? status;

  const StatusBadge({required this.label, this.status});

  Color get bg {
    final normalized = _normalize(label);
    if (_any(normalized, ['COMPLETED', 'DELIVERED', 'CONFIRMED', 'APPROVED'])) {
      return Colors.green.shade100;
    }
    if (_any(normalized, [
      'PENDING',
      'PENDING_PAYMENT',
      'NOT_SCHEDULED',
      'NOT_STARTED',
    ])) {
      return Colors.orange.shade100;
    }
    if (_any(normalized, ['SCREENSHOT_SENT', 'SCHEDULED'])) {
      return Colors.blue.shade100;
    }
    if (_any(normalized, ['FAILED', 'DECLINED', 'CANCELLED', 'REJECTED'])) {
      return Colors.red.shade100;
    }
    return Colors.grey.shade200;
  }

  Color get fg {
    final normalized = _normalize(label);
    if (_any(normalized, ['COMPLETED', 'DELIVERED', 'CONFIRMED', 'APPROVED'])) {
      return Colors.green.shade700;
    }
    if (_any(normalized, [
      'PENDING',
      'PENDING_PAYMENT',
      'NOT_SCHEDULED',
      'NOT_STARTED',
    ])) {
      return Colors.orange.shade700;
    }
    if (_any(normalized, ['SCREENSHOT_SENT', 'SCHEDULED'])) {
      return Colors.blue.shade700;
    }
    if (_any(normalized, ['FAILED', 'DECLINED', 'CANCELLED', 'REJECTED'])) {
      return Colors.red.shade700;
    }
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: fg)),
    );
  }

  static String _normalize(String value) {
    return value.trim().replaceAll('-', '_').replaceAll(' ', '_').toUpperCase();
  }

  static bool _any(String normalized, List<String> options) {
    return options.contains(normalized);
  }
}
