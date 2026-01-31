// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/profile/model/profile_model.dart';
// import 'package:haqmate/features/profile/view_model/profile_viewmodel.dart';
// import 'package:provider/provider.dart';

// class ChangePasswordView extends StatefulWidget {
//   final String userEmail;

//   const ChangePasswordView({Key? key, required this.userEmail})
//     : super(key: key);

//   @override
//   State<ChangePasswordView> createState() => _ChangePasswordViewState();
// }

// class _ChangePasswordViewState extends State<ChangePasswordView> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _codeController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _codeSent = false;
//   bool _codeVerified = false;
//   bool _passwordVisible = false;
//   bool _confirmPasswordVisible = false;

//   int _resendSeconds = 60;
//   bool _canResend = false;
//   Timer? _resendTimer;

//   void _startResendTimer() {
//     _canResend = false;
//     _resendSeconds = 60;
//     _resendTimer?.cancel();
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendSeconds == 0) {
//         timer.cancel();
//         if (mounted) {
//           setState(() => _canResend = true);
//         }
//       } else {
//         if (mounted) {
//           setState(() => _resendSeconds--);
//         } else {
//           timer.cancel();
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _emailController.text = widget.userEmail;
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _codeController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = context.watch<ProfileViewModel>();

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Change Password'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 'Secure Your Account',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Enter your email to receive a verification code',
//                 style: TextStyle(fontSize: 16, color: AppColors.textLight),
//               ),
//               const SizedBox(height: 32),

//               // Email Field
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   prefixIcon: Icon(Icons.email, color: AppColors.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//                 readOnly: _codeSent,
//               ),
//               const SizedBox(height: 20),

//               // Send Code Button
//               if (!_codeSent)
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: viewModel.isLoading
//                         ? null
//                         : () async {
//                             if (_formKey.currentState!.validate()) {
//                               try {
//                                 await viewModel.sendPasswordResetCode(
//                                   _emailController.text,
//                                 );
//                                 setState(() => _codeSent = true);
//                                 _startResendTimer();
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Verification code sent to your email',
//                                     ),
//                                     backgroundColor: Colors.green,
//                                   ),
//                                 );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text('Failed to send code: $e'),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: viewModel.isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Send Verification Code',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                   ),
//                 ),

//               // Code Verification (visible after code is sent)
//               if (_codeSent) ...[
//                 const SizedBox(height: 32),
//                 TextFormField(
//                   controller: _codeController,
//                   decoration: InputDecoration(
//                     labelText: 'Verification Code',
//                     prefixIcon: Icon(Icons.code, color: AppColors.primary),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the verification code';
//                     }
//                     if (value.length != 6) {
//                       return 'Code must be 6 digits';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 if (!_codeVerified)
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: viewModel.isLoading
//                           ? null
//                           : () async {
//                               if (_formKey.currentState!.validate()) {
//                                 final success = await viewModel.verifyOtp(
//                                   _emailController.text.trim(),
//                                   _codeController.text.trim(),
//                                 );

//                                 if (success && context.mounted) {
//                                   setState(() => _codeVerified = true);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                         'Code verified successfully',
//                                       ),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                   );
//                                 } else if (context.mounted &&
//                                     viewModel.errorMessage.isNotEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(viewModel.errorMessage),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: viewModel.isLoading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Text(
//                               'Verify Code',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                     ),
//                   ),
//                 const SizedBox(height: 12),

//                 Center(
//                   child: _canResend
//                       ? TextButton(
//                           onPressed: viewModel.isLoading
//                               ? null
//                               : () async {
//                                   await viewModel.sendPasswordResetCode(
//                                     _emailController.text.trim(),
//                                   );
//                                   _startResendTimer();

//                                   if (context.mounted) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                           "Verification code resent",
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                           child: const Text(
//                             "Resend code",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           "Resend available in $_resendSeconds s",
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                 ),

//                 if (_codeVerified) ...[
//                   const SizedBox(height: 20),

//                   // New Password Field
//                   TextFormField(
//                     controller: _newPasswordController,
//                     obscureText: !_passwordVisible,
//                     decoration: InputDecoration(
//                       labelText: 'New Password',
//                       prefixIcon: Icon(Icons.lock, color: AppColors.primary),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _passwordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: AppColors.primary,
//                         ),
//                         onPressed: () {
//                           setState(() => _passwordVisible = !_passwordVisible);
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a new password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Confirm Password Field
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: !_confirmPasswordVisible,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm New Password',
//                       prefixIcon: Icon(
//                         Icons.lock_outline,
//                         color: AppColors.primary,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _confirmPasswordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: AppColors.primary,
//                         ),
//                         onPressed: () {
//                           setState(
//                             () => _confirmPasswordVisible =
//                                 !_confirmPasswordVisible,
//                           );
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       if (value != _newPasswordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 32),

//                   // Reset Password Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: viewModel.isLoading
//                           ? null
//                           : () async {
//                               if (_formKey.currentState!.validate()) {
//                                 final request = ChangePasswordRequest(
//                                   email: _emailController.text.trim(),
//                                   code: _codeController.text.trim(),
//                                   newPassword: _newPasswordController.text,
//                                 );

//                                 final success = await viewModel.changePassword(
//                                   request,
//                                 );
//                                 if (success && context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                         'Password changed successfully!',
//                                       ),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                   );
//                                   Navigator.pop(context);
//                                 }
//                               }
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: viewModel.isLoading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Text(
//                               'Reset Password',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                     ),
//                   ),
//                 ],
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
