import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/new_web_router.dart';
import '../../../core/theme/qirat_theme.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../domain/entities/product/price_tag.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/entities/category/category.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/filter/filter_cubit.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';
import '../../widgets/new_web/common/qirat_header_widget.dart';
import '../../widgets/new_web/common/qirat_horizontal_collection_widget.dart';
import '../../widgets/new_web/sections/qirat_category_section_widget.dart';
import '../../widgets/new_web/sections/qirat_hero_section_widget.dart';
import '../../widgets/new_web/sections/qirat_differences_section_widget.dart';
import '../../widgets/new_web/sections/qirat_collection_section_widget.dart';
import '../../widgets/new_web/sections/qirat_heritage_section_widget.dart';
import '../../widgets/new_web/sections/qirat_footer_section_widget.dart';
import '../../widgets/new_web/modals/qirat_scent_advisor_modal.dart';

/// New Web Landing Page - Complete Qirat website experience
class NewWebLandingPageView extends StatefulWidget {
  const NewWebLandingPageView({Key? key}) : super(key: key);

  @override
  State<NewWebLandingPageView> createState() => _NewWebLandingPageViewState();
}

class _NewWebLandingPageViewState extends State<NewWebLandingPageView> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = true;
  Category? _selectedCategory;

  // Dummy top-selling products
  late final List<Product> _topSellingProducts;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _topSellingProducts = _createDummyProducts();
  }

  List<Product> _createDummyProducts() {
    return [
      Product(
        id: '1',
        name: 'Royal Oud Supreme',
        description:
            'Premium aged oud with rich, complex notes that evolve beautifully throughout the day. Perfect for special occasions.',
        images: [],
        priceTags: [
          PriceTag(
            id: 'pt1',
            name: '12ml',
            price: 2499,
          ),
        ],
        categories: ['Oud', 'Premium'],
        tags: ['bestseller', 'featured'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'Musk Heritage',
        description:
            'Traditional white musk blend, soft and lingering with timeless appeal. A signature scent for daily wear.',
        images: [],
        priceTags: [
          PriceTag(
            id: 'pt2',
            name: '12ml',
            price: 999,
          ),
        ],
        categories: ['Musk', 'Classic'],
        tags: ['popular', 'everyday'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '3',
        name: 'Rose Majesty',
        description:
            'Pure Bulgarian rose attar, capturing the essence of a thousand petals. Elegant and unforgettable.',
        images: [],
        priceTags: [
          PriceTag(
            id: 'pt3',
            name: '12ml',
            price: 1899,
          ),
        ],
        categories: ['Rose', 'Floral'],
        tags: ['new', 'luxury'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '4',
        name: 'Sandalwood Supreme',
        description:
            'Authentic Mysore sandalwood, aged to perfection with creamy richness. A meditative and calming fragrance.',
        images: [],
        priceTags: [
          PriceTag(
            id: 'pt4',
            name: '12ml',
            price: 1599,
          ),
        ],
        categories: ['Sandalwood', 'Premium'],
        tags: ['bestseller', 'calming'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '5',
        name: 'Amber Nights',
        description:
            'Warm amber blend with vanilla and musk undertones for evening wear. Sophisticated and alluring.',
        images: [],
        priceTags: [
          PriceTag(
            id: 'pt5',
            name: '12ml',
            price: 1299,
          ),
        ],
        categories: ['Amber', 'Oriental'],
        tags: ['evening', 'warm'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    // Hide scroll indicator after user starts scrolling
    if (_scrollController.offset > 100 && _showScrollIndicator) {
      setState(() {
        _showScrollIndicator = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Fixed Header
                SliverAppBar(
                  pinned: true,
                  toolbarHeight: 80,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: QiratHeaderWidget(
                    onCartTap: _handleCartTap,
                    onMenuTap: _handleMenuTap,
                  ),
                ),

                // Page Content
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Hero Section with Top Selling Products
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, productState) {
                        final products = productState.products.isNotEmpty
                            ? productState.products
                            : _topSellingProducts;

                        return QiratHeroSectionWidget(
                          topSellingProducts: products.take(5).toList(),
                          onAddToCart: _handleAddToCart,
                          onFindScentTap: _showScentAdvisorModal,
                          onExploreAllTap: _handleExploreAllTap,
                        );
                      },
                    ),

                    // Tagline Section
                    _buildTaglineSection(),

                    // Category Section
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, categoryState) {
                        if (categoryState is CategoryLoaded ||
                            categoryState is CategoryCacheLoaded) {
                          return QiratCategorySectionWidget(
                            categories: categoryState.categories,
                            onCategoryTap: _handleCategoryTap,
                            onViewAllTap: _handleViewAllCategories,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Differences Section
                    const QiratDifferencesSectionWidget(),

                    // Top Selling Products Collection
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, productState) {
                        final topSellingProducts
                        =
                        // productState
                        //         .products.isNotEmpty
                        //     ? productState.products
                        //         .where((p) => p.tags.contains('top-selling'))
                        //         .toList()
                        //     :
                        //
                        _topSellingProducts;

                        return QiratHorizontalCollectionWidget(
                          title: 'Top Selling Attars',
                          subtitle:
                              'Discover our most popular fragrances loved by connoisseurs',
                          products: topSellingProducts,
                          onProductTap: _handleProductTap,
                          onAddToCart: _handleAddToCart,
                          onViewAllTap: _handleViewAllProductsTap,
                          viewAllButtonText: 'View All Top Sellers',
                        );
                      },
                    ),
                    // Heritage Section
                    const QiratHeritageSectionWidget(),
                    // Animated Collection Section
                    QiratCollectionSectionWidget(
                      onViewAllTap: _handleViewAllProductsTap,
                      onProductTap: _handleProductTap,
                    ),



                    // Footer Section
                    QiratFooterSectionWidget(
                      onShopCollectionTap: _handleShopCollectionTap,
                      onLinkTap: _handleFooterLinkTap,
                    ),
                  ]),
                ),
              ],
            ),

            // Scroll Indicator
            if (_showScrollIndicator && !ResponsiveHelper.isMobile(context))
              _buildScrollIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaglineSection() {
    return Container(
      color: QiratTheme.darkBackground,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            children: [
              Text(
                'Traditional Purity. Modern Elegance.',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: QiratTheme.qiratGold,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.responsive(
                        context: context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 36,
                      ),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Qirat bridges authentic heritage with high-projection scents for the discerning Indian Connoisseur.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: QiratTheme.textMuted,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.2,
      right: 8,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: 2,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(1),
        ),
        child: Stack(
          children: [
            // Progress indicator
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: 0,
              child: Container(
                width: 4,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  color: QiratTheme.qiratGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Labels
            const Positioned(
              top: -8,
              right: 12,
              child: Text(
                '01',
                style: TextStyle(
                  fontSize: 12,
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const Positioned(
              bottom: -8,
              right: 12,
              child: Text(
                '05',
                style: TextStyle(
                  fontSize: 12,
                  color: QiratTheme.textMuted,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // Down arrow
            Positioned(
              bottom: -30,
              right: -2,
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: QiratTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _handleCartTap() {
    // TODO: Navigate to cart page
    debugPrint('Cart tapped');
  }

  void _handleMenuTap() {
    // TODO: Show mobile menu
    debugPrint('Menu tapped');
  }

  void _showScentAdvisorModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => QiratScentAdvisorModal(
        onClose: () => Navigator.of(context).pop(),
        onRecommendation: (attarName) {
          Navigator.of(context).pop();
          _handleProductRecommendation(attarName);
        },
      ),
    );
  }

  void _handleExploreAllTap() {
    // TODO: Navigate to products page
    debugPrint('Explore all attars tapped');
  }

  void _handleViewAllProductsTap() {
    // TODO: Navigate to collection page
    debugPrint('View all products tapped');
  }

  void _handleProductTap(Product productName) {
    // TODO: Navigate to product details page
    debugPrint('Product tapped: $productName');
  }

  void _handleShopCollectionTap() {
    // TODO: Navigate to shop page
    debugPrint('Shop collection tapped');
  }

  void _handleFooterLinkTap(String linkName) {
    // TODO: Handle footer link navigation
    debugPrint('Footer link tapped: $linkName');
  }

  void _handleProductRecommendation(String attarName) {
    // TODO: Navigate to specific product page
    debugPrint('Product recommendation: $attarName');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $attarName product page...'),
        backgroundColor: QiratTheme.qiratGold,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAddToCart(Product product, String priceTagId) {
    // TODO: Add product to cart
    debugPrint('Adding to cart: ${product.name} with price tag: $priceTagId');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: QiratTheme.qiratGold,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: QiratTheme.qiratBlack,
          onPressed: _handleCartTap,
        ),
      ),
    );
  }

  void _handleCategoryTap(Category category) {
    setState(() {
      _selectedCategory = category;
    });

    // Update filter cubit
    context.read<FilterCubit>().update(category: category);
    context.go(NewWebRouter.newProducts);
  }

  void _handleViewAllCategories() {}
}
