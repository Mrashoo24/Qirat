import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../common/animated_product_circle_widget.dart';

/// Collection Section Widget - Showcasing Qirat's product collection with animated circle
class QiratCollectionSectionWidget extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final Function(String)? onProductTap;
  final Function(String)? onAddToCart;

  const QiratCollectionSectionWidget({
    Key? key,
    this.onViewAllTap,
    this.onProductTap,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: QiratTheme.darkSurfaceVariant,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            children: [
              // Section Title
              Text(
                'The Qirat Collection',
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

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Experience our premium collection in motion',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: QiratTheme.textSecondary,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Animated Product Circle
              AnimatedProductCircleWidget(
                products: _getSampleProducts(),
                onProductTap: (product) {
                  onProductTap?.call(product.id);
                },
                onAddToCart: (product) {
                  onAddToCart?.call(product.id);
                },
              ),

              const SizedBox(height: 48),

              // View All Button
              ElevatedButton(
                onPressed: onViewAllTap,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Explore The Full Attar Portfolio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sample products for demonstration
  List<ProductHighlight> _getSampleProducts() {
    return [
      const ProductHighlight(
        id: '1',
        name: 'Royal Oud',
        description:
            'Premium aged oud with rich, complex notes that evolve beautifully on the skin.',
        price: 2499,
        originalPrice: 2999,
        rating: 4.8,
        category: 'Oud',
        isFeatured: true,
      ),
      const ProductHighlight(
        id: '2',
        name: 'Rose Majesty',
        description:
            'Pure Bulgarian rose attar, capturing the essence of a thousand petals.',
        price: 1899,
        rating: 4.9,
        category: 'Rose',
        isNew: true,
      ),
      const ProductHighlight(
        id: '3',
        name: 'Sandalwood Supreme',
        description:
            'Authentic Mysore sandalwood, aged to perfection with creamy richness.',
        price: 1599,
        originalPrice: 1799,
        rating: 4.7,
        category: 'Sandalwood',
      ),
      const ProductHighlight(
        id: '4',
        name: 'Amber Nights',
        description:
            'Warm amber blend with vanilla and musk undertones for evening wear.',
        price: 1299,
        rating: 4.6,
        category: 'Amber',
      ),
      const ProductHighlight(
        id: '5',
        name: 'Jasmine Dreams',
        description:
            'Night-blooming jasmine captured at peak freshness with floral elegance.',
        price: 1199,
        rating: 4.8,
        category: 'Floral',
        isNew: true,
      ),
      const ProductHighlight(
        id: '6',
        name: 'Musk Heritage',
        description:
            'Traditional white musk blend, soft and lingering with timeless appeal.',
        price: 999,
        originalPrice: 1199,
        rating: 4.5,
        category: 'Musk',
      ),
    ];
  }
}
