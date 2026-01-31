// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';

// class AboutUsView extends StatelessWidget {
//   const AboutUsView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('About Us'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Company Logo/Header
//             Center(
//               child: Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primary.withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.business,
//                   size: 60,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
            
//             // Story Section
//             _SectionCard(
//               icon: Icons.history,
//               title: 'Our Story',
//               content: 'Founded in 2024, our company began with a simple vision: to create meaningful solutions that empower individuals and businesses. From humble beginnings to becoming an industry leader, our journey has been fueled by innovation, dedication, and a commitment to excellence.',
//             ),
//             const SizedBox(height: 24),
            
//             // Mission Section
//             _SectionCard(
//               icon: Icons.flag,
//               title: 'Our Mission',
//               content: 'To revolutionize the way people interact with technology by delivering intuitive, secure, and powerful solutions that simplify daily tasks and drive productivity. We believe in creating tools that not only meet needs but exceed expectations.',
//             ),
//             const SizedBox(height: 24),
            
//             // Values Section
//             _SectionCard(
//               icon: Icons.star,
//               title: 'Our Values',
//               children: [
//                 _ValueItem(icon: Icons.security, title: 'Security', description: 'Your data protection is our top priority'),
//                 // _ValueItem(icon: Icons.innovation, title: 'Innovation', description: 'Continuously pushing boundaries'),
//                 _ValueItem(icon: Icons.people, title: 'Community', description: 'Building together with our users'),
//                 _ValueItem(icon: Icons.thumb_up, title: 'Excellence', description: 'Striving for perfection in everything'),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             // Contact Section
//             _SectionCard(
//               icon: Icons.contact_mail,
//               title: 'Contact Us',
//               children: [
//                 _ContactItem(
//                   icon: Icons.email,
//                   title: 'Email',
//                   value: 'support@company.com',
//                   onTap: () => _launchEmail('support@company.com'),
//                 ),
//                 _ContactItem(
//                   icon: Icons.phone,
//                   title: 'Phone',
//                   value: '+1 (555) 123-4567',
//                   onTap: () => _launchPhone('+15551234567'),
//                 ),
//                 _ContactItem(
//                   icon: Icons.location_on,
//                   title: 'Address',
//                   value: '123 Innovation Drive\nTech City, TC 12345',
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
            
//             // Developer Section
//             _SectionCard(
//               icon: Icons.developer_mode,
//               title: 'About the Developer',
//               content: 'This application was developed by a passionate team of Flutter developers dedicated to creating beautiful, functional mobile experiences. We specialize in modern UI/UX design, clean architecture, and robust backend integration.',
//             ),
//             const SizedBox(height: 32),
            
//             // Version Info
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.primary.withOpacity(0.2)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info, color: AppColors.primary),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'App Version',
//                           style: TextStyle(
//                             color: AppColors.textLight,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '1.0.0 • Build 2024.12.01',
//                           style: const TextStyle(
//                             color: AppColors.textDark,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _launchEmail(String email) {
//     // Implement email launch
//   }

//   void _launchPhone(String phone) {
//     // Implement phone launch
//   }
// }

// class _SectionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? content;
//   final List<Widget>? children;

//   const _SectionCard({
//     Key? key,
//     required this.icon,
//     required this.title,
//     this.content,
//     this.children,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: AppColors.primary),
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textDark,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           if (content != null)
//             Text(
//               content!,
//               style: TextStyle(
//                 fontSize: 16,
//                 height: 1.6,
//                 color: AppColors.textLight,
//               ),
//             ),
//           if (children != null) ...children!,
//         ],
//       ),
//     );
//   }
// }

// class _ValueItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   const _ValueItem({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.description,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColors.secondary, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textDark,
//                   ),
//                 ),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: AppColors.textLight,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ContactItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//   final VoidCallback? onTap;

//   const _ContactItem({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.value,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: AppColors.accent, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: AppColors.textLight,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       color: AppColors.textDark,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (onTap != null)
//               Icon(Icons.chevron_right, color: AppColors.primary, size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }