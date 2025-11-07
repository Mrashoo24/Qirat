import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/product/product.dart';

/// Reusable Horizontal Collection Widget
/// Can display any list of products with customizable title and actions
class QiratHorizontalCollectionWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Product> products;
  final VoidCallback? onViewAllTap;
  final Function(Product)? onProductTap;
  final Function(Product, String)? onAddToCart; // Product and priceTagId
  final Color? backgroundColor;
  final bool showViewAllButton;
  final String? viewAllButtonText;

  const QiratHorizontalCollectionWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.products,
    this.onViewAllTap,
    this.onProductTap,
    this.onAddToCart,
    this.backgroundColor,
    this.showViewAllButton = true,
    this.viewAllButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: backgroundColor ?? QiratTheme.darkSurfaceVariant,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.responsive(
              context: context,
              mobile: 40,
              tablet: 60,
              desktop: 80,
            ),
          ),
          child: Column(
            children: [
              // Section Header
              _buildSectionHeader(context),

              SizedBox(
                height: ResponsiveHelper.responsive(
                  context: context,
                  mobile: 32,
                  tablet: 40,
                  desktop: 48,
                ),
              ),

              // Horizontal Product Showcase
              _buildProductShowcase(context),

              if (showViewAllButton) ...[
                SizedBox(
                  height: ResponsiveHelper.responsive(
                    context: context,
                    mobile: 32,
                    tablet: 40,
                    desktop: 48,
                  ),
                ),
                _buildViewAllButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: QiratTheme.qiratGold,
                  fontWeight: FontWeight.w800,
                  fontSize: ResponsiveHelper.responsive(
                    context: context,
                    mobile: 28,
                    tablet: 32,
                    desktop: 36,
                  ),
                ),
            textAlign: TextAlign.center,
          ),

          if (subtitle != null) ...[
            SizedBox(
              height: ResponsiveHelper.responsive(
                context: context,
                mobile: 12,
                tablet: 16,
                desktop: 16,
              ),
            ),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: QiratTheme.textSecondary,
                    fontSize: ResponsiveHelper.responsive(
                      context: context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 16,
                    ),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductShowcase(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        final listHeight = isMobile ? 360.0 : 420.0;
        return SizedBox(
          height: listHeight,
          child: ScrollConfiguration(
            behavior: const WebScrollBehavior(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
              separatorBuilder: (_, __) => SizedBox(width: isMobile ? 16 : 32),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _buildProductCard(products[index], isMobile),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Product product, bool isMobile) {
    final cardWidth = isMobile ? 280.0 : 320.0;
    final imageHeight = isMobile ? 180.0 : 200.0;
    final cardPadding = isMobile ? 16.0 : 24.0;
    final titleSize = isMobile ? 20.0 : 24.0;

    return GestureDetector(
      onTap: () => onProductTap?.call(product),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: QiratTheme.darkBackground,
          border: Border.all(
            color: QiratTheme.goldBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(product, imageHeight, isMobile),

            SizedBox(height: isMobile ? 16 : 20),

            // Product Name
            Text(
              product.name,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: QiratTheme.qiratGold,
                fontFamily: 'Inter',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            const SizedBox(height: 12),

            // Product Description
            Text(
              product.description,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: QiratTheme.darkOnBackground,
                fontFamily: 'Inter',
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 5),

            // Price and Add to Cart
            _buildPriceSection(product, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product, double height, bool isMobile) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: QiratTheme.qiratGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: product.images.isNotEmpty
            ? Image.network(
                product.images.first,
                fit: BoxFit.fill,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(isMobile),
              )
            : _buildPlaceholder(isMobile),
      ),
    );
  }

  Widget _buildPlaceholder(bool isMobile) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        color: QiratTheme.qiratGold.withOpacity(0.5),
        size: isMobile ? 48 : 64,
      ),
    );
  }

  Widget _buildPriceSection(Product product, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        if (product.priceTags.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${product.priceTags.first.price}',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                product.priceTags.first.name,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  color: QiratTheme.textMuted,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),

        // Add to Cart Button
        if (onAddToCart != null && product.priceTags.isNotEmpty)
          IconButton(
            onPressed: () => onAddToCart!(product, product.priceTags.first.id),
            icon: Container(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              decoration: BoxDecoration(
                color: QiratTheme.qiratGold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: QiratTheme.qiratGold.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.add_shopping_cart,
                color: QiratTheme.qiratBlack,
                size: isMobile ? 12 : 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
      child: Center(
        child: ElevatedButton(
          onPressed: onViewAllTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.responsive(
                context: context,
                mobile: 24,
                tablet: 32,
                desktop: 32,
              ),
              vertical: ResponsiveHelper.responsive(
                context: context,
                mobile: 14,
                tablet: 16,
                desktop: 16,
              ),
            ),
          ),
          child: Text(
            viewAllButtonText ?? 'Explore The Full Collection',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsive(
                context: context,
                mobile: 14,
                tablet: 16,
                desktop: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Top-level custom scroll behavior (must be outside widget class)
class WebScrollBehavior extends MaterialScrollBehavior {
  const WebScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}
