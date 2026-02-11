import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:haqmate/features/auth/view/signup_screen.dart';
import 'package:haqmate/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:haqmate/features/cart/view/cart_view.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:haqmate/features/home/views/splashscreen.dart';
import 'package:haqmate/features/order_detail/view/order_detail_page.dart';
import 'package:haqmate/features/order_detail/viewmodel/order_viewmodel.dart';
import 'package:haqmate/features/orders/view/order_screen.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/views/product_view.dart';
import 'package:haqmate/features/profile/view_model/profile_viewmodel.dart';
import 'package:haqmate/features/review/service/review_service.dart';
import 'package:haqmate/features/review/view/review_screen.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';

import 'features/auth/view/login_screen.dart';

void main() async {
  // Important: Add this line
  /* idgetsFlutterBinding.ensureInitialized();
  
  // Initialize InAppWebView
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  
  // If you're on Android, you might also need:
  if (InAppWebView == null) {
    // This will automatically initialize the platform
    var webView = InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri('about:blank')),
    );
  } */

  runApp(const TeffApp());
}

// void _initializeWebView() {
//   if (WebViewPlatform.instance == null) {
//     // Check which platform we're on and set the appropriate implementation
//     if (WebViewPlatform.instance == null) {
//       WebViewPlatform.instance = createWebViewPlatform();
//     }
//   }
// }

// WebViewPlatform createWebViewPlatform() {
//   // This should automatically use the correct platform implementation
//   // For Flutter 3.0+
//   return WebViewPlatform.instance ?? const WebViewPlatform();
// }

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
        ),

        ChangeNotifierProvider(
          create: (_) => ReviewViewModel(repository: ReviewService()),
        ),

        ChangeNotifierProvider<CartViewModel>(
          create: (_) => CartViewModel()..loadCart(),
        ),

        ChangeNotifierProvider<OrdersViewModel>(
          create: (_) => OrdersViewModel()..load(),
        ),

        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),

        ChangeNotifierProvider<OrderdetailViewModel>(
          create: (_) => OrderdetailViewModel(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
