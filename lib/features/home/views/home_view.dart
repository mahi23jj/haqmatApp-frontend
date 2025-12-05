import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haqmate/core/bottom_nev.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';
import 'package:haqmate/features/home/widgets/catagory_item.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/product_detail/views/product_view.dart';
import 'package:provider/provider.dart';
import '../widgets/banner_card.dart';
import '../widgets/flash_sale_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final PageController _bannerController;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context, listen: true);

    print(vm.flashSale.length);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.location_on_outlined, color: AppColors.primary),
        ),
        title: const Text(
          'New York, USA',
          style: TextStyle(color: AppColors.textDark),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: AppColors.primary),
          ),
        ],
      ),

      body: SafeArea(
        child: vm.loading
            ? const Center(child: CircularProgressIndicator())
            : vm.error != null
            ? Center(child: Text(vm.error!))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Search bar and filter
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Search Furniture',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.tune, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Banner carousel
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _bannerController,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return FadeTransition(
                            opacity: _fadeController.drive(
                              CurveTween(curve: Curves.easeIn),
                            ),
                            child: BannerCard(
                              // try to use asset first else fallback to local path or network
                              imageProvider: AssetImage(
                                'assets/images/teff.jpg',
                              ),
                              /*   File(AppColors.localPreviewImage).existsSync()
                                  ? FileImage(File(AppColors.localPreviewImage))
                                  : const NetworkImage(
                                          'https://picsum.photos/800/400',
                                        )
                                        as ImageProvider, */
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Category row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('See All'),
                        ),
                      ],
                    ),

                    /*           const SizedBox(height: 12),
                    SizedBox(
                      height: 86,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          CategoryItem(icon: Icons.weekend, label: 'Sofa'),
                          CategoryItem(icon: Icons.chair, label: 'Chair'),
                          CategoryItem(
                            icon: Icons.lightbulb_outline,
                            label: 'Lamp',
                          ),
                          CategoryItem(icon: Icons.kitchen, label: 'Cupboard'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18), */

                    // Flash sale header
                    /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Flash Sale',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'Closing in :',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 8),
                            Chip(label: Text('02 : 12 : 56')),
                          ],
                        ),
                      ],
                    ), */

                    /*         const SizedBox(height: 12),

                    // Flash sale filters
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(label: 'All', selected: false),
                          _FilterChip(label: 'Newest', selected: true),
                          _FilterChip(label: 'Popular', selected: false),
                          _FilterChip(label: 'Bedroom', selected: false),
                        ],
                      ),
                    ), */
                    const SizedBox(height: 16),

                    // make grid 2*2
                    /*   SizedBox(
                      height: 300,
                      child: GridView.builder(
                        itemCount: vm.flashSale.length ,
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1 ), 
                        itemBuilder: (context, index) {
                            final item =
                                vm.flashSale[index % vm.flashSale.length];
                            return FlashSaleItem(product: item);
                          },),
                    ), */
                    SizedBox(
                      height: 550,
                      child: GridView.builder(
                        itemCount: vm.flashSale.length,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          mainAxisSpacing: 10, // spacing between rows
                          crossAxisSpacing: 10, // spacing between columns
                          childAspectRatio:
                              1, // width/height ratio of each item
                        ),
                        itemBuilder: (context, index) {
                          final item =
                              vm.flashSale[index % vm.flashSale.length];
                          return FlashSaleItem(product: item);
                        },
                      ),
                    ),

                    /*  SizedBox(
                      height: 260,
                      child: ListView.separated(
                        // scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item =
                              vm.flashSale[index % vm.flashSale.length];
                          return FlashSaleItem(product: item);
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: vm.flashSale.length,
                      ),
                    ), */
                    // const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({Key? key, required this.label, required this.selected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textDark,
        ),
      ),
    );
  }
}
