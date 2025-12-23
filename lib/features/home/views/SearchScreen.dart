import 'package:flutter/material.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';
import 'package:haqmate/features/home/widgets/ProductSearchCard.dart';
import 'package:provider/provider.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {


@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<HomeViewModel>().clear();
  });
}


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: true,
              onChanged: vm.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search teff, quality, type...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 📦 result Area
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.error != null) {
                  return Center(child: Text(vm.error!));
                }

                if (vm.result.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: vm.result.length,
                  itemBuilder: (context, index) {
                    final product = vm.result[index];
                    return ProductSearchCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
