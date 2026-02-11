import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:haqmate/features/auth/view/signup_screen.dart';
import 'package:haqmate/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:haqmate/features/cart/data/cart_local_data_source.dart';
import 'package:haqmate/features/cart/view/cart_view.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/home/views/home_view.dart';
import 'package:haqmate/features/home/views/splashscreen.dart';
import 'package:haqmate/features/order_detail/data/order_detail_local_data_source.dart';
import 'package:haqmate/features/order_detail/view/order_detail_page.dart';
import 'package:haqmate/features/order_detail/viewmodel/order_viewmodel.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart' as cart_models;
import 'package:haqmate/features/order_detail/model/order_model.dart'
  as order_detail_models;
import 'package:haqmate/features/orders/data/order_local_data_source.dart';
import 'package:haqmate/features/orders/view/order_screen.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:haqmate/features/orders/model/order.dart' as order_models;
import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/views/product_view.dart';
import 'package:haqmate/features/profile/view_model/profile_viewmodel.dart';
import 'package:haqmate/features/review/service/review_service.dart';
import 'package:haqmate/features/review/view/review_screen.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';

import 'features/auth/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(cart_models.CartModelAdapter());
  Hive.registerAdapter(cart_models.LocationModelAdapter());
  Hive.registerAdapter(cart_models.CartModelListAdapter());
  Hive.registerAdapter(order_detail_models.OrderItemsAdapter());
  Hive.registerAdapter(order_detail_models.OrderTrackingStepAdapter());
  Hive.registerAdapter(order_detail_models.OrderDataAdapter());
  Hive.registerAdapter(order_detail_models.OrderStatusAdapter());
  Hive.registerAdapter(order_detail_models.PaymentStatusAdapter());
  Hive.registerAdapter(order_detail_models.DeliveryStatusAdapter());
  Hive.registerAdapter(order_detail_models.RefundStatusAdapter());
  Hive.registerAdapter(order_models.TrackingTypeAdapter());
  Hive.registerAdapter(order_models.OrderStatusAdapter());
  Hive.registerAdapter(order_models.PaymentStatusAdapter());
  Hive.registerAdapter(order_models.DeliveryStatusAdapter());
  Hive.registerAdapter(order_models.RefundStatusAdapter());
  Hive.registerAdapter(order_models.OrderModelAdapter());
  Hive.registerAdapter(order_models.OrderTrackingModelAdapter());
  Hive.registerAdapter(order_models.RefundRequestModelAdapter());

  await Hive.openBox<cart_models.CartModelList>(
    CartLocalDataSource.cartBoxName,
  );
  await Hive.openBox<List<order_models.OrderModel>>(
    OrderLocalDataSource.orderBoxName,
  );
  await Hive.openBox<order_detail_models.OrderData>(
    OrderDetailLocalDataSource.orderDetailBoxName,
  );

  await CartLocalDataSource().migrateFromSharedPrefsIfNeeded();
  await OrderLocalDataSource().migrateFromSharedPrefsIfNeeded();
  final migratedOrders = await OrderLocalDataSource().readOrders();
  await OrderDetailLocalDataSource().migrateFromSharedPrefsIfNeeded(
    migratedOrders?.map((o) => o.id).toList() ?? <String>[],
  );
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
