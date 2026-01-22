import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:haqmate/features/checkout/viewmodel/manual_payment_viewmodel.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ManualPaymentScreen extends StatelessWidget {
  final String orderId;

  const ManualPaymentScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManualPaymentViewModel(orderId: orderId),
      child: const _ManualPaymentBody(),
    );
  }
}

class _ManualPaymentBody extends StatefulWidget {
  const _ManualPaymentBody();

  @override
  State<_ManualPaymentBody> createState() => _ManualPaymentBodyState();
}

class _ManualPaymentBodyState extends State<_ManualPaymentBody> {
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ManualPaymentViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Payment Screenshot')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload a screenshot of your payment receipt.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: vm.submitting ? null : _pickFile,
              icon: const Icon(Icons.upload_file),
              label: Text(_selectedFile == null
                  ? 'Choose screenshot'
                  : _selectedFile!.name),
            ),
            const SizedBox(height: 12),
            if (_selectedFile != null)
              Text('Selected: ${_selectedFile!.name}'),
            const Spacer(),
            CustomButton(
              width: double.infinity,
              label: 'Submit Payment',
              loading: vm.submitting,
              onPressed: (_selectedFile != null && !vm.submitting)
                  ? () => _submit(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _submit(BuildContext context) async {
    final vm = context.read<ManualPaymentViewModel>();
    final file = _selectedFile;
    if (file == null) return;

    try {
      await vm.submit(file);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment screenshot uploaded.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
