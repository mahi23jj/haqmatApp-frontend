import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haqmate/features/checkout/service/manual_payment_service.dart';

class ManualPaymentViewModel extends ChangeNotifier {
  final String orderId;
  final ManualPaymentService _service = ManualPaymentService();

  bool submitting = false;
  String? error;

  ManualPaymentViewModel({required this.orderId});

  Future<void> submit(PlatformFile file) async {
    if (submitting) return;
    submitting = true;
    error = null;
    notifyListeners();

    try {
      await _service.uploadPayment(orderId: orderId, file: file);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
