// import 'package:flutter/material.dart';

// class StatusBadge extends StatelessWidget {
//   final String label;
//   // Optional: kept for compatibility with older calls that pass `status`.
//   final String? status;

//   const StatusBadge({required this.label, this.status});

//   Color get bg {
//     final normalized = _normalize(label);
//     if (_any(normalized, ['COMPLETED', 'DELIVERED', 'CONFIRMED', 'APPROVED'])) {
//       return Colors.green.shade100;
//     }
//     if (_any(normalized, [
//       'PENDING',
//       'PENDING_PAYMENT',
//       'NOT_SCHEDULED',
//       'NOT_STARTED',
//     ])) {
//       return Colors.orange.shade100;
//     }
//     if (_any(normalized, ['SCREENSHOT_SENT', 'SCHEDULED'])) {
//       return Colors.blue.shade100;
//     }
//     if (_any(normalized, ['FAILED', 'DECLINED', 'CANCELLED', 'REJECTED'])) {
//       return Colors.red.shade100;
//     }
//     return Colors.grey.shade200;
//   }

//   Color get fg {
//     final normalized = _normalize(label);
//     if (_any(normalized, ['COMPLETED', 'DELIVERED', 'CONFIRMED', 'APPROVED'])) {
//       return Colors.green.shade700;
//     }
//     if (_any(normalized, [
//       'PENDING',
//       'PENDING_PAYMENT',
//       'NOT_SCHEDULED',
//       'NOT_STARTED',
//     ])) {
//       return Colors.orange.shade700;
//     }
//     if (_any(normalized, ['SCREENSHOT_SENT', 'SCHEDULED'])) {
//       return Colors.blue.shade700;
//     }
//     if (_any(normalized, ['FAILED', 'DECLINED', 'CANCELLED', 'REJECTED'])) {
//       return Colors.red.shade700;
//     }
//     return Colors.grey.shade600;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(label, style: TextStyle(fontSize: 12, color: fg)),
//     );
//   }

//   static String _normalize(String value) {
//     return value.trim().replaceAll('-', '_').replaceAll(' ', '_').toUpperCase();
//   }

//   static bool _any(String normalized, List<String> options) {
//     return options.contains(normalized);
//   }
// }


import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final String? status;

  const StatusBadge({required this.label, this.status});

  // Map backend statuses to Amharic labels
  String get _translatedLabel {
    const translations = {
      // Backend statuses remain in English, we translate display
      'PENDING_PAYMENT': 'በመክፈል ላይ',
      'TO_BE_DELIVERED': 'ለመላክ',
      'DELIVERED': 'ደርሷል',
      'COMPLETED': 'ተጠናቋል',
      'CANCELLED': 'ተሰርዟል',
      'PENDING': 'በመጠባበቅ ላይ',
      'PAID': 'ተከፍሏል',
      'PROCESSING': 'በማቀናበር ላይ',
      'SHIPPED': 'ተላክቷል',
      'REFUNDED': 'ተመላሽ ተደርጓል',
      'FAILED': 'አልተሳካም',
      'CONFIRMED': 'ተረጋግጧል',
      'APPROVED': 'ተፅድቋል',
      'REJECTED': 'ተገፎታል',
      'SCREENSHOT_SENT': 'ስክሪንሾት ተልኳል',
      'NOT_STARTED': 'አልተጀመረም',
      'NOT_SCHEDULED': 'አልተዘጋጀም',
      'SCHEDULED': 'ተዘጋጅቷል',
      'DECLINED': 'ተገፎታል',
    };

    final englishLabel = label.toUpperCase().replaceAll(' ', '_');
    return translations[englishLabel] ?? label;
  }

  Color get bg {
    final normalized = label.toUpperCase().replaceAll(' ', '_');
    
    // Success states
    if (['COMPLETED', 'DELIVERED', 'CONFIRMED', 'APPROVED', 'PAID']
        .contains(normalized)) {
      return Colors.green.shade100;
    }
    
    // Pending states
    if (['PENDING', 'PENDING_PAYMENT', 'NOT_SCHEDULED', 'NOT_STARTED', 'SCREENSHOT_SENT']
        .contains(normalized)) {
      return Colors.orange.shade100;
    }
    
    // Processing states
    if (['PROCESSING', 'SCHEDULED', 'TO_BE_DELIVERED']
        .contains(normalized)) {
      return Colors.blue.shade100;
    }
    
    // Failed/Cancelled states
    if (['FAILED', 'DECLINED', 'CANCELLED', 'REJECTED']
        .contains(normalized)) {
      return Colors.red.shade100;
    }
    
    return Colors.grey.shade200;
  }

  Color get fg {
    final normalized = label.toUpperCase().replaceAll(' ', '_');
    
    // Success states
    if (['COMPLETED', 'DELIVERED', 'CONFIRMED', 'APPROVED', 'PAID']
        .contains(normalized)) {
      return Colors.green.shade800;
    }
    
    // Pending states
    if (['PENDING', 'PENDING_PAYMENT', 'NOT_SCHEDULED', 'NOT_STARTED', 'SCREENSHOT_SENT']
        .contains(normalized)) {
      return Colors.orange.shade800;
    }
    
    // Processing states
    if (['PROCESSING', 'SCHEDULED', 'TO_BE_DELIVERED']
        .contains(normalized)) {
      return Colors.blue.shade800;
    }
    
    // Failed/Cancelled states
    if (['FAILED', 'DECLINED', 'CANCELLED', 'REJECTED']
        .contains(normalized)) {
      return Colors.red.shade800;
    }
    
    return Colors.grey.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _translatedLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}