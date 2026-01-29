// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:haqmate/features/checkout/viewmodel/manual_payment_viewmodel.dart';
// import 'package:haqmate/core/widgets/custom_button.dart';
// import 'package:provider/provider.dart';

// class ManualPaymentScreen extends StatelessWidget {
//   final String orderId;

//   const ManualPaymentScreen({super.key, required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ManualPaymentViewModel(orderId: orderId),
//       child: const _ManualPaymentBody(),
//     );
//   }
// }

// class _ManualPaymentBody extends StatefulWidget {
//   const _ManualPaymentBody();

//   @override
//   State<_ManualPaymentBody> createState() => _ManualPaymentBodyState();
// }

// class _ManualPaymentBodyState extends State<_ManualPaymentBody> {
//   PlatformFile? _selectedFile;

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<ManualPaymentViewModel>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload Payment Screenshot')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Upload a screenshot of your payment receipt.',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             OutlinedButton.icon(
//               onPressed: vm.submitting ? null : _pickFile,
//               icon: const Icon(Icons.upload_file),
//               label: Text(_selectedFile == null
//                   ? 'Choose screenshot'
//                   : _selectedFile!.name),
//             ),
//             const SizedBox(height: 12),
//             if (_selectedFile != null)
//               Text('Selected: ${_selectedFile!.name}'),
//             const Spacer(),
//             CustomButton(
//               width: double.infinity,
//               label: 'Submit Payment',
//               loading: vm.submitting,
//               onPressed: (_selectedFile != null && !vm.submitting)
//                   ? () => _submit(context)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: kIsWeb,
//     );

//     if (result != null && result.files.isNotEmpty) {
//       setState(() => _selectedFile = result.files.first);
//     }
//   }

//   Future<void> _submit(BuildContext context) async {
//     final vm = context.read<ManualPaymentViewModel>();
//     final file = _selectedFile;
//     if (file == null) return;

//     try {
//       await vm.submit(file);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Payment screenshot uploaded.')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }
// }


// manual_payment_screen.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:haqmate/features/checkout/viewmodel/manual_payment_viewmodel.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/core/constants.dart';

class ManualPaymentScreen extends StatelessWidget {
  final String orderId;

  const ManualPaymentScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManualPaymentViewModel(orderId: orderId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'ክፍያ ያረጋግጡ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          centerTitle: true,
        ),
        body: const _ManualPaymentBody(),
      ),
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Instruction Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.primary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'ክፍያ መረጋገጫ ይላኩ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'ክፍያ ካደረጉ በኋላ የመርሀ ግብር ስክሪንሾትን ይስጡ። ትዕዛዝዎ ከመረጋገጥን በኋላ ማስተናገድ ይጀምራል።',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Bank Details
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'የባንክ ዝርዝሮች',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBankDetail('ባንክ', 'ንግድ ባንክ'),
                _buildBankDetail('መለያ ቁጥር', '10003456789'),
                _buildBankDetail('መለያ ስም', 'ሐቅማት ጤፍ አፕ'),
                _buildBankDetail('መጠቃለያ', 'ሐቅማት ጤፍ'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // File Upload Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ስክሪንሾት ይስቀሉ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GestureDetector(
                    onTap: vm.submitting ? null : _pickFile,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: _selectedFile != null ? AppColors.primary.withOpacity(0.05) : AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedFile != null ? AppColors.primary : Colors.grey.shade300,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: _selectedFile != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _selectedFile!.name,
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'አድጋለህ ለመቀየር ይንኩ',
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    color: AppColors.primary,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'ስክሪንሾት ለመስቀል ይንኩ',
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'JPG, PNG ወይም PDF',
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // File Info
                  if (_selectedFile != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'ፋይሉ በተሳካ ሁኔታ ተመርጧል። ክፍያ ለማረጋገጥ ከታች ያለውን አዝራር ይጫኑ።',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Submit Button
                  CustomButton(
                    width: double.infinity,
                    label: vm.submitting ? 'በመላክ ላይ...' : 'ክፍያ ያረጋግጡ',
                    backgroundColor: _selectedFile != null ? AppColors.secondary : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    loading: vm.submitting,
                    onPressed: (_selectedFile != null && !vm.submitting)
                        ? () => _submit(context)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    icon: vm.submitting
                        ? null
                        : const Icon(
                            Icons.send_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            ':',
            style: TextStyle(color: AppColors.textLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
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
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'ክፍያ ተረጋግጧል!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'የክፍያ ማረጋገጫው በተሳካ ሁኔታ ተልኳል። ትዕዛዝዎ በቅርብ ጊዜ ይቀርብልዎታል።',
                style: TextStyle(
                  color: AppColors.textLight,
                  // textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                width: double.infinity,
                label: 'ደህና ነው',
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to home
                },
              ),
            ],
          ),
        ),
      );
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ስህተት: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}