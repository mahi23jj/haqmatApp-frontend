import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

// class TeffBottomNav extends StatefulWidget {
//   const TeffBottomNav({Key? key}) : super(key: key);

//   @override
//   State<TeffBottomNav> createState() => _TeffBottomNavState();
// }

// class _TeffBottomNavState extends State<TeffBottomNav>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onTap(int idx) {
//     setState(() => _selectedIndex = idx);
//     _controller.forward(from: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       height: 72,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 16,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _NavItem(
//             icon: Icons.home,
//             label: 'Home',
//             active: _selectedIndex == 0,
//             onTap: () => _onTap(0),
//           ),
//           _NavItem(
//             icon: Icons.shopping_bag_outlined,
//             label: 'Bag',
//             active: _selectedIndex == 1,
//             onTap: () => _onTap(1),
//           ),
//           _NavItem(
//             icon: Icons.favorite_border,
//             label: 'Wishlist',
//             active: _selectedIndex == 2,
//             onTap: () => _onTap(2),
//           ),
//           _NavItem(
//             icon: Icons.person_outline,
//             label: 'Profile',
//             active: _selectedIndex == 3,
//             onTap: () => _onTap(3),
//           ),
//         ],
//       ),
//     );
//   }
// }




class TeffBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const TeffBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... existing UI code ...

      margin: const EdgeInsets.all(12),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'ቤት',
            active: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.receipt_long_outlined,
            label: 'ትእዛዞች',
            active: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.shopping_cart_outlined,
            label: 'ቋት',
            active: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'መገለጫ',
            active: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? AppColors.primary : AppColors.textDark),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
