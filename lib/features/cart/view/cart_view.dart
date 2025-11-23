import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:haqmate/features/product_detail/widgets/header_section.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textDark),
          title: Text("Your Cart", style: TextStyle(color: AppColors.textDark)),
        ),
        body: Consumer<CartViewModel>(
          builder: (context, vm, _) => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: vm.CartModels.length,
                  itemBuilder: (context, index) {
                    final CartModel = vm.CartModels[index];
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
                                CartModel.imageUrl,
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
                                    CartModel.name,
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "\$${CartModel.price}",
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
                                  quantityButton(
                                    Icons.remove,
                                    () => vm.decrement(CartModel),
                                  ),
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
                                    CartModel.quantity.toString(),
                                    style: TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),

                                  quantityButton(
                                    Icons.add,
                                    () => vm.increment(CartModel),
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

                    /*          Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: 
                        
                        
                        ListTile(
                          leading: Image.asset(
                            CartModel.imageUrl,
                            width: 100,
                            height: 100,
                          ),
                          title: Text(
                            CartModel.name,
                            style: TextStyle(color: AppColors.textDark),
                          ),
                          subtitle: Text(
                            "\$${CartModel.price.toStringAsFixed(2)}",
                            style: TextStyle(color: AppColors.textDark),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () => vm.decrement(CartModel),
                                ),
                                Text(
                                  CartModel.quantity.toString(),
                                  style: TextStyle(color: AppColors.textDark),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => vm.increment(CartModel),
                                ),
                              ],
                            ),
                          ),
                        ),



                      ),
                    ); */
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
                        Text("Subtotal Items (${vm.CartModels.length})"),
                        Text("\$${vm.subtotal.toStringAsFixed(2)}"),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Fee"),
                        Text("\$${vm.deliveryFee.toStringAsFixed(2)}"),
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
                          "\$${vm.total.toStringAsFixed(2)}",
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
          ),
        ),
      ),
    );
  }
}
