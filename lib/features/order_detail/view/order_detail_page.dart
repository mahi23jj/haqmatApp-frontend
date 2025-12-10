import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/order_detail/model/order_model.dart';
import 'package:haqmate/features/orders/viewmodel/order_view_model.dart';
import 'package:provider/provider.dart';
import '../viewmodel/order_viewmodel.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    print('order id in detail page: ${widget.orderId}');
    // Run AFTER the first frame so notifyListeners is safe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderdetailViewModel>().loadorderdetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderdetailViewModel>(context);

    if (vm.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 2️⃣ NO PRODUCT FOUND
    if (vm.order == null) {
      return const Scaffold(body: Center(child: Text("No order found")));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Order Details"),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            _buildOrderId(vm),
            SizedBox(height: 20),
            _buildTrackingSection(vm),
            SizedBox(height: 20),
            _buildOrderItems(vm),
            SizedBox(height: 20),
            _buildAddress(vm),
            // SizedBox(height: 20),
            // _buildAddress(vm),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                vm.callSeller('+251985272557');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                child: Text(
                  "Contact Sellers",
                  style: TextStyle(color: AppColors.background, fontSize: 17),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderId(OrderdetailViewModel vm) {
    return FadeIn(
      child: Text(
        "Order Id - ${vm.order!.orderId}",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTrackingSection(OrderdetailViewModel vm) {
    return FadeIn(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Tracking",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 18),
            ...vm.order!.tracking.map((step) {
              final isLast = step == vm.order!.tracking.last;
              return _trackingTile(step, isLast);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _trackingTile(step, last) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 20,
              height: 20,

              child: step.completed
                  ? Icon(
                      Icons.check_circle,
                      color: AppColors.secondary,
                      size: 25,
                    )
                  : Icon(Icons.circle, color: AppColors.primary, size: 25),
            ),

            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  step.date,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),

        if (!last)
          Container(
            width: 2,
            height: 40,
            color: AppColors.primary,
            // to be on start
            margin: EdgeInsets.only(left: 10),
          ),
      ],
    );
  }

  Widget _buildOrderItems(OrderdetailViewModel vm) {
    return FadeIn(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Items",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            ...vm.order!.items.map((item) => _itemCard(item)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "delivery fee",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "${vm.order!.deliveryFee}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "${vm.order!.totalAmount}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(OrderItem item) {
    return SlideIn(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 14),
            decoration: _boxDecoration(),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item.name),
              subtitle: Text("${item.packagingSize} kg\n${item.quantity} x"),
              trailing: Text(
                "${item.price} ETB",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(OrderdetailViewModel vm) {
    return FadeIn(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text('+251 ${vm.order!.phoneNumber}'),
            Text(vm.order!.address),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
    ],
  );
}

/// --- Animation Widgets --- ///

class FadeIn extends StatelessWidget {
  final Widget child;
  FadeIn({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600),
      builder: (context, value, _) => Opacity(opacity: value, child: child),
    );
  }
}

class SlideIn extends StatelessWidget {
  final Widget child;
  SlideIn({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
      duration: Duration(milliseconds: 500),
      builder: (context, offset, _) =>
          Transform.translate(offset: offset * 20, child: child),
    );
  }
}
