import 'package:flutter/material.dart';
import 'package:haqmate/core/bottom_nev.dart';
import 'package:haqmate/features/cart/view/cart_view.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:haqmate/features/orders/view/order_screen.dart';
import 'package:provider/provider.dart';

class TeffBottomNavPage extends StatefulWidget {
  const TeffBottomNavPage({Key? key}) : super(key: key);

  @override
  State<TeffBottomNavPage> createState() => _TeffBottomNavPageState();
}

class _TeffBottomNavPageState extends State<TeffBottomNavPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),      // Replace with your actual pages
    OrdersPage(),
    CartScreen(),
    HomeView()
    // ProfilePage(),
  ];

  void _onTap(int idx) {
    setState(() => _selectedIndex = idx);

    if (idx == 2) {
    // Cart tab clicked
    Future.microtask(() {
      Provider.of<CartViewModel>(context, listen: false).loadCart();
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: TeffBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
