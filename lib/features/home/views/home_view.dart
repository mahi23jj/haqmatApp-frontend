// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:haqmate/core/bottom_nev.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/home/viewmodel/home_view_model.dart';
// import 'package:haqmate/features/home/views/SearchScreen.dart';
// import 'package:haqmate/features/home/widgets/catagory_item.dart';
// import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
// import 'package:haqmate/features/product_detail/views/product_view.dart';
// import 'package:provider/provider.dart';
// import '../widgets/banner_card.dart';
// import '../widgets/flash_sale_item.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
//   late final PageController _bannerController;
//   late final AnimationController _fadeController;

//   @override
//   void initState() {
//     super.initState();
//     _bannerController = PageController(viewportFraction: 0.92);
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _fadeController.forward();
//   }

//   @override
//   void dispose() {
//     _bannerController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<HomeViewModel>(context, listen: true);

//     print(vm.flashSale.length);

//     return Scaffold(
//       extendBody: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const Padding(
//           padding: EdgeInsets.only(left: 16.0),
//           child: Icon(Icons.location_on_outlined, color: AppColors.primary),
//         ),
//         title: const Text(
//           'Haqmat Teff',
//           style: TextStyle(color: AppColors.textDark),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: Icon(Icons.notifications_none, color: AppColors.primary),
//           ),
//         ],
//       ),

//       body: SafeArea(
//         child: vm.loading
//             ? const Center(child: CircularProgressIndicator())
//             : vm.error != null
//             ? Center(child: Text(vm.error!))
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 8),

//                     // Search bar and filter
//                     InkWell(
//                       borderRadius: BorderRadius.circular(12),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const Searchscreen(),
//                           ),
//                         );

//                          context.read<HomeViewModel>().load();
//                       },
//                       child: Container(
//                         height: 48,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 8,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(Icons.search, color: Colors.grey),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Search Furniture',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     // Banner carousel
//                     SizedBox(
//                       height: 200,
//                       child: PageView.builder(
//                         controller: _bannerController,
//                         itemCount: 1,
//                         itemBuilder: (context, index) {
//                           return FadeTransition(
//                             opacity: _fadeController.drive(
//                               CurveTween(curve: Curves.easeIn),
//                             ),
//                             child: BannerCard(
//                               // try to use asset first else fallback to local path or network
//                               imageProvider: AssetImage(
//                                 'assets/images/teff.jpg',
//                               ),
//                               /*   File(AppColors.localPreviewImage).existsSync()
//                                   ? FileImage(File(AppColors.localPreviewImage))
//                                   : const NetworkImage(
//                                           'https://picsum.photos/800/400',
//                                         )
//                                         as ImageProvider, */
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     // Category row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Category',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: const Text('See All'),
//                         ),
//                       ],
//                     ),

//                     /*           const SizedBox(height: 12),
//                     SizedBox(
//                       height: 86,
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children: const [
//                           CategoryItem(icon: Icons.weekend, label: 'Sofa'),
//                           CategoryItem(icon: Icons.chair, label: 'Chair'),
//                           CategoryItem(
//                             icon: Icons.lightbulb_outline,
//                             label: 'Lamp',
//                           ),
//                           CategoryItem(icon: Icons.kitchen, label: 'Cupboard'),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 18), */

//                     // Flash sale header
//                     /*  Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Flash Sale',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Row(
//                           children: const [
//                             Text(
//                               'Closing in :',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             SizedBox(width: 8),
//                             Chip(label: Text('02 : 12 : 56')),
//                           ],
//                         ),
//                       ],
//                     ), */

//                     /*         const SizedBox(height: 12),

//                     // Flash sale filters
//                     SizedBox(
//                       height: 40,
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children: [
//                           _FilterChip(label: 'All', selected: false),
//                           _FilterChip(label: 'Newest', selected: true),
//                           _FilterChip(label: 'Popular', selected: false),
//                           _FilterChip(label: 'Bedroom', selected: false),
//                         ],
//                       ),
//                     ), */
//                     const SizedBox(height: 16),

//                     // make grid 2*2
//                     /*   SizedBox(
//                       height: 300,
//                       child: GridView.builder(
//                         itemCount: vm.flashSale.length ,
//                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1 ),
//                         itemBuilder: (context, index) {
//                             final item =
//                                 vm.flashSale[index % vm.flashSale.length];
//                             return FlashSaleItem(product: item);
//                           },),
//                     ), */
//                     SizedBox(
//                       height: 550,
//                       child: GridView.builder(
//                         itemCount: vm.flashSale.length,

//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2, // 2 columns
//                           mainAxisSpacing: 10, // spacing between rows
//                           crossAxisSpacing: 10, // spacing between columns
//                           childAspectRatio:
//                               1, // width/height ratio of each item
//                         ),
//                         itemBuilder: (context, index) {
//                           final item =
//                               vm.flashSale[index % vm.flashSale.length];
//                           return FlashSaleItem(product: item);
//                         },
//                       ),
//                     ),

//                     /*  SizedBox(
//                       height: 260,
//                       child: ListView.separated(
//                         // scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           final item =
//                               vm.flashSale[index % vm.flashSale.length];
//                           return FlashSaleItem(product: item);
//                         },
//                         separatorBuilder: (_, __) => const SizedBox(width: 12),
//                         itemCount: vm.flashSale.length,
//                       ),
//                     ), */
//                     // const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   const _FilterChip({Key? key, required this.label, required this.selected})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: ChoiceChip(
//         label: Text(label),
//         selected: selected,
//         backgroundColor: Colors.white,
//         selectedColor: AppColors.primary,
//         labelStyle: TextStyle(
//           color: selected ? Colors.white : AppColors.textDark,
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haqmate/core/bottom_nev.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';
import 'package:haqmate/features/home/views/SearchScreen.dart';
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
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  // Banner data with Amharic content
  final List<Map<String, dynamic>> _banners = [
    {
      'image': 'assets/images/teff.jpg', // You'll need to add these images
      'title': 'ከእርሻ እስከ ቤትዎ',
      'subtitle': '100% ንጹህ ኢትዮጵያዊ ጤፍ',
      'description': 'ከቀጥታ እርሻ በምንም መካከለኛ ያለማግኘት ወደ ቤትዎ ደርሰናል',
      'color': AppColors.primary,
    },
    {
      'image': 'assets/images/teff.jpg',
      'title': 'ብርቱካናማ የቤት ውስጥ ጤፍ',
      'subtitle': 'ለጤና የተሻለ',
      'description': 'በሳይንሳዊ መንገድ የተቀነባበረ እና ለጤናዎ በጣም ጠቃሚ የሆነ ጤፍ',
      'color': AppColors.secondary,
    },
    {
      'image': 'assets/images/injera.jpg',
      'title': 'ለየት ያለ ጣዕም',
      'subtitle': 'እናት እንጀራ ቅርጽ',
      'description': 'በልዩ ቴክኖሎጂ የተጠራረጠ እና ትክክለኛውን ጣዕም የያዘ ጤፍ',
      'color': AppColors.accent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController.forward();

    // Start auto slide
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentBannerIndex < _banners.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _fadeController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context, listen: true);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () {
              // Show location selector
            },
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ሐቅማት ጤፍ አፕ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'ከእርሻ እስከ ቤትዎ',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Badge(
              backgroundColor: Colors.red,
              smallSize: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.primary,
                  size: 28,
                ),
                onPressed: () {
                  // Navigate to notifications
                },
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: vm.loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : vm.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.accent,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      vm.error!,
                      style: TextStyle(color: AppColors.textLight),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => vm.load(),
                      child: const Text('እንደገና ይሞክሩ'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Search bar
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Searchscreen(),
                          ),
                        );
                        context.read<HomeViewModel>().load();
                      },
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ጤፍ ወይም ምርቶችን ይፈልጉ...',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'ፈልግ',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Banner Carousel
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _bannerController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentBannerIndex = index;
                              });
                            },
                            itemCount: _banners.length,
                            itemBuilder: (context, index) {
                              final banner = _banners[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: _BannerCard(banner: banner),
                              );
                            },
                          ),
                        ),

                        // Banner indicators
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _banners.length,
                            (index) => Container(
                              width: _currentBannerIndex == index ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == index
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 24),

                    // Categories Section
                    const SizedBox(height: 24),

                    // Featured Products Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'የተለዩ ምርቶች',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Navigate to all categories
                                },
                                child: Text(
                                  'ሁሉንም ይመልከቱ',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              /*  Icon(Icons.flash_on, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'ልዩ ቅናሽ',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ), */
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Products Grid
                    if (vm.flashSale.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1, // 🔥 FIX
                            ),
                        itemCount: vm.flashSale.length,
                        itemBuilder: (context, index) {
                          final product = vm.flashSale[index];
                          return FlashSaleItem(product: product);
                        },
                      )
                    else
                      Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.textLight,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ምርቶች አልተገኙም',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Why Choose Us Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ለምን ሐቅማት ጤፍ አፕ ይምረጡ?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            Icons.verified,
                            '100% ንጹህ',
                            'ከጭድ እርሻ ቀጥታ ወደ ቤትዎ',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            Icons.local_shipping,
                            'ፈጣን መላኪያ',
                            'በአዲስ አበባ እና ከተሞች',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            Icons.security,
                            'ደህንነት የተጠበቀ',
                            'በማረጋገጫ ምርቶች',
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            Icons.support_agent,
                            '24/7 ድጋፍ',
                            'የደንበኞች አገልግሎት',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: AppColors.textLight, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final Map<String, dynamic> banner;

  const _BannerCard({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: banner['color'].withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image with overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(banner['image']),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    banner['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: banner['color'],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  banner['subtitle'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  banner['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: banner['color'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () {
                    // Handle banner action
                  },
                  child: Text(
                    'አሁን ይግዙ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
