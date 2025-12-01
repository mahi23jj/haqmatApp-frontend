import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/product_detail/widgets/header_section.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  @override
  void initState() {
    super.initState();
    Provider.of<CartViewModel>(context, listen: false).loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark),
        title: Text("Your Cart", style: TextStyle(color: AppColors.textDark)),
      ),
      body: Consumer<CartViewModel>(
        builder: (context, vm, _) {
          // ----------------
          // LOADING
          // ----------------
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ----------------
          // ERROR
          // ----------------
          if (vm.error != null) {
            return Center(
              child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
            );
          }

          final carts = vm.cartItems!.items;

          if (carts == null || carts.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return
          //const Center(child: Text("Your cart is not empty"));
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: carts.length,
                  itemBuilder: (context, index) {
                    final cartModel = carts[index];

                    Widget quantityButton(IconData icon, VoidCallback onTap) {
                      return GestureDetector(
                        onTap: onTap,
                        child: Icon(icon, size: 18, color: AppColors.textDark),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/teff.jpg',
                                // cartModel.imageUrl ?? ,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(width: 12),

                            // NAME + PRICE
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartModel.name,
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                   Text(
                                    '${cartModel.packaging} Kg',
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "\$${cartModel.totalprice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // + QUANTITY -
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(31, 182, 127, 26),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // 🟢 prevents overflow
                                children: [
                                  quantityButton(Icons.remove, () {
                                    if (cartModel.quantity > 1) {
                                      vm.updateQuantity(
                                        productId: cartModel.productId,
                                        quantity: cartModel.quantity - 1,
                                        packagingSize: cartModel.packaging,
                                      );
                                    }
                                  }),
                                  /*  GestureDetector(
                                    onTap: () => vm.decrement(CartModel),
                                    child: Icon(
                                      Icons.remove,
                                      size: 18,
                                      color: AppColors.textDark,
                                    ),
                                  ), */
                                  SizedBox(height: 4),

                                  Text(
                                    cartModel.quantity.toString(),
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),

                                  quantityButton(
                                    Icons.add,
                                    () => vm.updateQuantity(
                                      productId: cartModel.productId,
                                      quantity: cartModel.quantity + 1,
                                      packagingSize: cartModel.packaging,
                                    ),
                                  ),
                                  /*  GestureDetector(
                                    onTap: () => vm.increment(CartModel),
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: AppColors.textDark,
                                    ),
                                  ), */
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal Items (${carts.length})"),
                        Text("\$${vm.cartItems!.subtotal.toStringAsFixed(2)}"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax Fee"),
                        Text("\$${vm.cartItems!.tax.toStringAsFixed(2)}"),
                      ],
                    ),
                    Divider(height: 24, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "\$${vm.cartItems!.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Go to Payment",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
