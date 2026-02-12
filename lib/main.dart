import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/cart/data/cart_local_data_source.dart';
import 'features/cart/model/cartmodel.dart' as cart_models;
import 'features/cart/viewmodel/cart_viewmodel.dart';
import 'features/home/viewmodel/home_view_model.dart';
import 'features/home/views/splashscreen.dart';
import 'features/order_detail/data/order_detail_local_data_source.dart';
import 'features/order_detail/model/order_model.dart' as order_detail_models;
import 'features/order_detail/viewmodel/order_viewmodel.dart';
import 'features/orders/data/order_local_data_source.dart';
import 'features/orders/model/order.dart' as order_models;
import 'features/orders/viewmodel/order_view_model.dart';
import 'features/product_detail/service/product_detail_repo.dart';
import 'features/product_detail/viewmodel/product_viewmodel.dart';
import 'features/profile/view_model/profile_viewmodel.dart';
import 'features/review/service/review_service.dart';
import 'features/review/viewmodel/review_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppBootstrapper());
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({super.key});

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initInAppWebView());
    });
  }

  Future<void> _initializeApp() async {
    await Hive.initFlutter();
    _registerHiveAdapters();
    await _openHiveBoxes();
    await _migrateDataIfNeeded();
  }

  Future<void> _initInAppWebView() async {
    if (!kDebugMode) return;
    try {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    } catch (e) {
      debugPrint('InAppWebView init failed: $e');
    }
  }

  void _registerHiveAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(cart_models.CartModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(cart_models.LocationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(cart_models.CartModelListAdapter());
    }

    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(order_detail_models.OrderItemsAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(order_detail_models.OrderTrackingStepAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(order_detail_models.OrderDataAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(order_detail_models.OrderStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(order_detail_models.PaymentStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(order_detail_models.DeliveryStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(16)) {
      Hive.registerAdapter(order_detail_models.RefundStatusAdapter());
    }

    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(order_models.OrderModelAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(order_models.OrderTrackingModelAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(order_models.RefundRequestModelAdapter());
    }
    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(order_models.TrackingTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(order_models.OrderStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(order_models.PaymentStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(order_models.DeliveryStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(27)) {
      Hive.registerAdapter(order_models.RefundStatusAdapter());
    }
  }

  Future<void> _openHiveBoxes() async {
    if (!Hive.isBoxOpen(CartLocalDataSource.cartBoxName)) {
      await Hive.openBox<cart_models.CartModelList>(
        CartLocalDataSource.cartBoxName,
      );
    }

    if (!Hive.isBoxOpen(OrderLocalDataSource.orderBoxName)) {
      await Hive.openBox(
        OrderLocalDataSource.orderBoxName,
      );
    }

    if (!Hive.isBoxOpen(OrderDetailLocalDataSource.orderDetailBoxName)) {
      await Hive.openBox<order_detail_models.OrderData>(
        OrderDetailLocalDataSource.orderDetailBoxName,
      );
    }
  }

  Future<void> _migrateDataIfNeeded() async {
    await CartLocalDataSource().migrateFromSharedPrefsIfNeeded();
    await OrderLocalDataSource().migrateFromSharedPrefsIfNeeded();

    final migratedOrders = await OrderLocalDataSource().readOrders();
    await OrderDetailLocalDataSource().migrateFromSharedPrefsIfNeeded(
      migratedOrders?.map((o) => o.id).toList() ?? <String>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 48),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to start app',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _initFuture = _initializeApp();
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const TeffApp();
      },
    );
  }
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
        home: const SplashScreen(),
      ),
    );
  }
}
