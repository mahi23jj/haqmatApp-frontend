import 'package:flutter/material.dart';
import 'package:haqmate/features/home/models/product.dart';

class ProductSearchCard extends StatelessWidget {
  final ProductModel product;

  const ProductSearchCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image_not_supported),
        title: Text(product.name),
       /*  subtitle: Text(
          '${product.}${product.quality != null ? ' • ${product.quality}' : ''}',
        ), */
        trailing: Text(
          '${product.price} ETB',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Navigate to product details
        },
      ),
    );
  }
}
