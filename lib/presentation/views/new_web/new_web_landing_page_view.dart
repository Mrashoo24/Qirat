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
import '../../blocs/cart/cart_bloc.dart';
import '../../../domain/entities/cart/cart_item.dart';
import '../../../core/services/services_locator.dart' as di;
import '../../../core/services/config_service.dart';

/// New Web Landing Page - Complete Qirat website experience
class NewWebLandingPageView extends StatefulWidget {
  const NewWebLandingPageView({Key? key}) : super(key: key);

  @override
  State<NewWebLandingPageView> createState() => _NewWebLandingPageViewState();
}

class _NewWebLandingPageViewState extends State<NewWebLandingPageView> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = true;
  // Removed unused state: selected category now handled via navigation/filter

  // Dummy top-selling products
  late final List<Product> _topSellingProducts;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _topSellingProducts = _createDummyProducts();
    // Ensure products are loaded for dynamic promotional sections
    final productState = context.read<ProductBloc>().state;
    if (productState.products.isEmpty) {
      context.read<ProductBloc>().add(const GetProducts(FilterProductParams()));
    }
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
                    showBackButton: false,
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
                        final heroId = di.sl<ConfigService>().heroCategoryId;
                        final products = productState.products.isNotEmpty
                            ? productState.products
                                .where((e) => e.categories.contains(heroId))
                            : _topSellingProducts;

                        return QiratHeroSectionWidget(
                          topSellingProducts: products.toList(),
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
                            categories: categoryState.categories
                                .where((c) => c.location == 'main')
                                .toList(),
                            onCategoryTap: _handleCategoryTap,
                            onViewAllTap: _handleViewAllCategories,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Differences Section
                    const QiratDifferencesSectionWidget(),

                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, categoryState) {
                        if (categoryState is CategoryLoaded ||
                            categoryState is CategoryCacheLoaded) {
                          final heroId =
                              di.sl<ConfigService>().featured_collection_id;

                          final promotionCategories = categoryState.categories
                              .where((c) => c.id == heroId)
                              .toList();

                          // Return regular RenderBox children (Column) instead of a SliverList
                          // to avoid placing a sliver inside a non-sliver parent.
                          return Column(
                            children:
                                promotionCategories.map((currentCategory) {
                              return BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, productState) {
                                  final topSellingProducts = productState
                                          .products.isNotEmpty
                                      ? productState.products.where((p) {
                                          final cats = p.categories;
                                          // Support both cases where product.categories may be a list of Category objects
                                          // or a list of category names (String).
                                          return cats
                                                  .contains(currentCategory) ||
                                              cats.contains(currentCategory.id);
                                        }).toList()
                                      : _topSellingProducts;

                                  return QiratHorizontalCollectionWidget(
                                    title: currentCategory.name,
                                    subtitle: currentCategory.body,
                                    products: topSellingProducts,
                                    onProductTap: _handleProductTap,
                                    onAddToCart: _handleAddToCart,
                                    onViewAllTap: _handleViewAllProductsTap,
                                    viewAllButtonText:
                                        'Explore All ${currentCategory.name}',
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    // Heritage Section
                    const QiratHeritageSectionWidget(),

                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, productState) {
                        final heroId = di.sl<ConfigService>().premiumCategoryId;
                        final products = productState.products.isNotEmpty
                            ? productState.products
                                .where((e) => e.categories.contains(heroId))
                            : _topSellingProducts;

                        return
                            // Animated Collection Section
                            QiratCollectionSectionWidget(
                          products: products.toList(),
                          onViewAllTap: _handleViewAllpremiumProductsTap,
                          onProductTap: _handleProductTap,
                          onAddToCart: _handleAddToCart,
                        );
                      },
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
    final targetCategoryId = 'v856hO8j5qQHsrCqLq75';
    Category? category;
    final catState = context.read<CategoryBloc>().state;
    if (catState is CategoryLoaded) {
      final matches =
          catState.categories.where((c) => c.id == targetCategoryId).toList();
      if (matches.isNotEmpty) category = matches.first;
    } else if (catState is CategoryCacheLoaded) {
      final matches =
          catState.categories.where((c) => c.id == targetCategoryId).toList();
      if (matches.isNotEmpty) category = matches.first;
    }

    if (category != null) {
      context.read<FilterCubit>().update(category: category);
      context.push(NewWebRouter.newProducts, extra: {'category': category});
    } else {
      // Fallback if categories not ready yet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading category…')),
      );
      context.push(NewWebRouter.newProducts,
          extra: {'categoryId': targetCategoryId});
    }
  }

  void _handleViewAllProductsTap() {
    final targetCategoryId = di.sl<ConfigService>().featured_collection_id;
    Category? category;
    final catState = context.read<CategoryBloc>().state;
    if (catState is CategoryLoaded) {
      final matches =
          catState.categories.where((c) => c.id == targetCategoryId).toList();
      if (matches.isNotEmpty) category = matches.first;
    } else if (catState is CategoryCacheLoaded) {
      final matches =
          catState.categories.where((c) => c.id == targetCategoryId).toList();
      if (matches.isNotEmpty) category = matches.first;
    }

    if (category != null) {
      context.read<FilterCubit>().update(category: category);
      context.push(NewWebRouter.newProducts, extra: {'category': category});
    } else {
      // Fallback if categories not ready yet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading category…')),
      );
      context.push(NewWebRouter.newProducts,
          extra: {'categoryId': targetCategoryId});
    }
  }

  void _handleViewAllpremiumProductsTap() {
    final targetCategoryId = di.sl<ConfigService>().premiumCategoryId;
    Category? category;
    final catState = context.read<CategoryBloc>().state;
    if (catState is CategoryLoaded) {
      final matches =
          catState.categories.where((c) => c.id == targetCategoryId).toList();
      if (matches.isNotEmpty) category = matches.first;
    } else if (catState is CategoryCacheLoaded) {
      final matches =
          catState.categories.where((c) => c.id == targetCategoryId).toList();
      if (matches.isNotEmpty) category = matches.first;
    }

    if (category != null) {
      context.read<FilterCubit>().update(category: category);
      context.push(NewWebRouter.newProducts, extra: {'category': category});
    } else {
      // Fallback if categories not ready yet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading category…')),
      );
      context.push(NewWebRouter.newProducts,
          extra: {'categoryId': targetCategoryId});
    }
  }

  void _handleProductTap(Product product) {
    context.push(NewWebRouter.newProductDetails, extra: product);
  }

  void _handleShopCollectionTap() {
    context.push(NewWebRouter.newProducts);
  }

  void _handleFooterLinkTap(String linkName) {
    // TODO: Handle footer link navigation
    debugPrint('Footer link tapped: $linkName');
  }

  void _handleProductRecommendation(String attarName) {
// Navigate to the recommended product from the live ProductBloc list
    final name = attarName.trim();
    if (name.isEmpty) return;

    final state = context.read<ProductBloc>().state;
    final products = state.products;

    if (products.isEmpty) {
// Trigger load and inform the user
      context.read<ProductBloc>().add(const GetProducts(FilterProductParams()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading products… please try again in a moment.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Product? found;

// Exact match (case-insensitive)
    final exact = products.where(
      (p) => p.name.trim().toLowerCase() == name.toLowerCase(),
    );
    if (exact.isNotEmpty) {
      found = exact.first;
    } else {
// Starts-with, then contains
      found = products.firstWhere(
        (p) => p.name.toLowerCase().startsWith(name.toLowerCase()),
        orElse: () => products.firstWhere(
          (p) => p.name.toLowerCase().contains(name.toLowerCase()),
          orElse: () => products.first,
        ),
      );
    }

    if (found != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigating to ${found.name}…'),
          backgroundColor: QiratTheme.qiratGold,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.push(NewWebRouter.newProductDetails, extra: found);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not find "$attarName" in our catalog.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleAddToCart(Product product, String priceTagId) {
    // Resolve selected priceTag; fallback to first if not found
    final priceTag = product.priceTags.firstWhere(
      (pt) => pt.id == priceTagId,
      // orElse: () => product.priceTags.first,
    );

    // Dispatch to CartBloc (use guest uid '1' if not logged)
    context.read<CartBloc>().add(
          AddProduct(
            cartItem: CartItem(
              id: 'tmp-${product.id}-${priceTag.id}',
              product: product,
              priceTag: priceTag,
              quantity: 1,
              uid: '1',
            ),
          ),
        );

    // Show confirmation with quick link to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: QiratTheme.qiratGold,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: QiratTheme.qiratBlack,
          onPressed: () => context.push(NewWebRouter.newCart),
        ),
      ),
    );
  }

  void _handleCategoryTap(Category category) {
    // Update filter cubit
    context.read<FilterCubit>().update(category: category);
    context.push(NewWebRouter.newProducts);
  }

  void _handleViewAllCategories() {
    context.push(NewWebRouter.newCategories);
  }
}
