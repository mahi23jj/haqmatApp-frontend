import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/home/viewmodel/home_view_model.dart';
import 'package:haqmate/features/home/widgets/ProductSearchCard.dart';
import 'package:provider/provider.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'የተፍ ፍለጋ',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontFamily: 'Ethiopia',
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/images/logo2.png', // Add your app logo
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Modern Search Header with Gradient
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.accent.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ምግብ ቤትዎ ውስጥ ከማሳል እስከ ቤትዎ',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    fontFamily: 'Ethiopia',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'የተፍ ፍለጋ',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Ethiopia',
                  ),
                ),
                const SizedBox(height: 16),

                // Modern Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: vm.onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'የተፍ፣ ጥራት፣ ዓይነት... ይፈልጉ',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontFamily: 'Ethiopia',
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            vm.clear();
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            color: AppColors.textLight,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Search Filters Chips
               /*  SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('ሁሉም', true),
                      const SizedBox(width: 8),
                      _buildFilterChip('ነጩ የተፍ', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('ቀዩ የተፍ', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('ቅባይ', false),
                      const SizedBox(width: 8),
                      _buildFilterChip('ጥራት 1', false),
                    ],
                  ),
                ), */
              ],
            ),
          ),

          // 📦 Search Results Area
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.loading) {
                  return _buildLoadingState();
                }

                if (vm.error != null) {
                  return _buildErrorState(vm.error!);
                }

                if (_searchController.text.isEmpty && vm.result.isEmpty) {
                  return _buildEmptySearchState();
                }

                if (vm.result.isEmpty && _searchController.text.isNotEmpty) {
                  return _buildNoResultsState(_searchController.text);
                }

                return _buildResultsList(vm);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.textDark,
          fontFamily: 'Ethiopia',
          fontSize: 12,
        ),
      ),
      selected: isActive,
      onSelected: (_) {},
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ምርቶች በመጫን ላይ...',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontFamily: 'Ethiopia',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'እባክዎ ይጠብቁ',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    String userFriendlyError = _translateError(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'አንድ ስህተት ተከስቷል',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Ethiopia',
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                userFriendlyError,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<HomeViewModel>().clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'እንደገና ሞክር',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Ethiopia',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    color: AppColors.primary,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'የትኛውን የተፍ ዓይነት ትፈልጋለህ?',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Ethiopia',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'የሚፈልጉትን የተፍ ዓይነት፣ ጥራት ወይም መለያ ለመፈለግ ከላይ ባለው የፍለጋ ሳጥን ውስጥ ይፃፉ።',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
               /*  Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildPopularSearch('ነጩ የተፍ'),
                    _buildPopularSearch('ቀዩ የተፍ'),
                    _buildPopularSearch('ቅባይ'),
                    _buildPopularSearch('ጥራት 1'),
                    _buildPopularSearch('ኦርጋኒክ'),
                    _buildPopularSearch('ፍራፍሬ ያለበት'),
                  ],
                ), */
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResultsState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.sentiment_dissatisfied_rounded,
                color: AppColors.primary,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Ethiopia',
                ),
                children: [
                  const TextSpan(text: '"'),
                  TextSpan(
                    text: query,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const TextSpan(text: '"'),
                  const TextSpan(text: ' ላይ ምንም ውጤት አልተገኘም'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'ሌላ ቃል ይሞክሩ ወይም ከታች ባሉት ታዋቂ ፍለጋዎች ይመልከቱ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
           /*  SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAlternativeSearch('ነጩ የተፍ'),
                  const SizedBox(width: 12),
                  _buildAlternativeSearch('ቀዩ የተፍ'),
                  const SizedBox(width: 12),
                  _buildAlternativeSearch('ጥራት 1'),
                  const SizedBox(width: 12),
                  _buildAlternativeSearch('ኦርጋኒክ'),
                ],
              ),
            ), */
          ],
        ),
      ),
    );
  }

  /* Widget _buildPopularSearch(String term) {
    return GestureDetector(
      onTap: () {
        _searchController.text = term;
        context.read<HomeViewModel>().onSearchChanged(term);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          term,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Ethiopia',
          ),
        ),
      ),
    );
  } */

  Widget _buildAlternativeSearch(String term) {
    return ElevatedButton(
      onPressed: () {
        _searchController.text = term;
        context.read<HomeViewModel>().onSearchChanged(term);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        term,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Ethiopia',
        ),
      ),
    );
  }

  Widget _buildResultsList(HomeViewModel vm) {
    return Column(
      children: [
        // Results Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.background.withOpacity(0.5)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'የተገኙ ምርቶች (${vm.result.length})',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Ethiopia',
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
                    Icon(
                      Icons.filter_list_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ማጣሪያ',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontFamily: 'Ethiopia',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: vm.result.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = vm.result[index];
              return ProductSearchCard(product: product);
            },
          ),
        ),
      ],
    );
  }

  String _translateError(String error) {
    // Translate common error messages to user-friendly Amharic
    if (error.contains('network') || error.contains('internet')) {
      return 'የኢንተርኔት ግንኙነት የለም። እባክዎ ኢንተርኔትዎን ያረጋግጡ እና እንደገና ይሞክሩ።';
    } else if (error.contains('timeout')) {
      return 'ጥያቄው ረዘም ስለሚወስድ ተሰርዟል። እባክዎ እንደገና ይሞክሩ።';
    } else if (error.contains('server')) {
      return 'አገልጋዩ ችግር አለበት። እባክዎ ትንሽ ቆይተው እንደገና ይሞክሩ።';
    } else {
      return 'አንድ ችግር ተከስቷል። እባክዎ እንደገና ይሞክሩ።';
    }
  }
}
