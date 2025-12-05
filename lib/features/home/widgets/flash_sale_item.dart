import 'package:flutter/material.dart';
import 'package:haqmate/features/home/models/product.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/views/product_view.dart';
import 'package:provider/provider.dart';

class FlashSaleItem extends StatelessWidget {
  final ProductModel product;
  const FlashSaleItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{

        /* await context.read<ProductViewModel>().load(product.id); */

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productid: product.id),
          ),
        );
      },
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                'assets/images/teff.jpg',
                // product.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(Icons.favorite_border),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
