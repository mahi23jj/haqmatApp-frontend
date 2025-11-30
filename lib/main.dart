import 'package:flutter/material.dart';
import 'package:haqmate/features/auth/view/signup_screen.dart';
import 'package:haqmate/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:haqmate/features/cart/view/cart_view.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:haqmate/features/order_detail/view/order_detail_page.dart';
import 'package:haqmate/features/order_detail/viewmodel/order_viewmodel.dart';
import 'package:haqmate/features/orders/view/order_screen.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/views/product_view.dart';
import 'package:haqmate/features/review/service/review_service.dart';
import 'package:haqmate/features/review/view/review_screen.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';

import 'features/auth/view/login_screen.dart';

void main() {
  runApp(const TeffApp());
}

class TeffApp extends StatelessWidget {
  const TeffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        ChangeNotifierProvider<HomeViewModel>(create: (_) => HomeViewModel()),

        ChangeNotifierProvider(
          create: (_) => ProductViewModel(ProductDetailRepo()),
          child: ProductDetailPage(),
        ),

        /*       ChangeNotifierProvider(
          create: (_) => ProductViewModel(FakeRepository())..load('teff-1'),
          child: CartScreen(),
        ), */
        ChangeNotifierProvider(
          create: (_) => ReviewViewModel(
            repository: ReviewRepository(service: FakeReviewService()),
          )..loadReviews(),
          child: ReviewsPage(),
        ),
        ChangeNotifierProvider<CartViewModel>(create: (_) => CartViewModel()),

        ChangeNotifierProvider<OrdersViewModel>(
          create: (_) => OrdersViewModel(),
        ),

        ChangeNotifierProvider<OrderdetailViewModel>(
          create: (_) => OrderdetailViewModel(),
        ),
        // You can add more providers here:
        // ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}
