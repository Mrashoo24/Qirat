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
        description: 'Premium aged oud with rich, complex notes that evolve beautifully on the skin.',
        price: 2499,
        originalPrice: 2999,
        rating: 4.8,
        category: 'Oud',
        isFeatured: true,
      ),
      const ProductHighlight(
        id: '2',
        name: 'Rose Majesty',
        description: 'Pure Bulgarian rose attar, capturing the essence of a thousand petals.',
        price: 1899,
        rating: 4.9,
        category: 'Rose',
        isNew: true,
      ),
      const ProductHighlight(
        id: '3',
        name: 'Sandalwood Supreme',
        description: 'Authentic Mysore sandalwood, aged to perfection with creamy richness.',
        price: 1599,
        originalPrice: 1799,
        rating: 4.7,
        category: 'Sandalwood',
      ),
      const ProductHighlight(
        id: '4',
        name: 'Amber Nights',
        description: 'Warm amber blend with vanilla and musk undertones for evening wear.',
        price: 1299,
        rating: 4.6,
        category: 'Amber',
      ),
      const ProductHighlight(
        id: '5',
        name: 'Jasmine Dreams',
        description: 'Night-blooming jasmine captured at peak freshness with floral elegance.',
        price: 1199,
        rating: 4.8,
        category: 'Floral',
        isNew: true,
      ),
      const ProductHighlight(
        id: '6',
        name: 'Musk Heritage',
        description: 'Traditional white musk blend, soft and lingering with timeless appeal.',
        price: 999,
        originalPrice: 1199,
        rating: 4.5,
        category: 'Musk',
      ),
    ];
  }
  }

  Widget _buildProductShowcase(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        if (isMobile) {
          return _buildMobileShowcase();
        } else {
          return _buildDesktopShowcase();
        }
      },
    );
  }

  Widget _buildDesktopShowcase() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildProductCards().map((card) {
          return Padding(
            padding: const EdgeInsets.only(right: 32),
            child: card,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileShowcase() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildProductCards().map((card) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: card,
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildProductCards() {
    final products = [
      {
        'name': 'Moss Aura',
        'subtitle': 'Earthy, Green, Grounding',
        'notes': 'Key Notes: Vetiver, Oakmoss, Cedarwood.',
        'image': 'Moss Aura Image',
      },
      {
        'name': 'Mawj',
        'subtitle': 'Aquatic, Fresh, Energetic',
        'notes': 'Key Notes: Sea Salt, Mint, Amber.',
        'image': 'Mawj Image',
      },
      {
        'name': 'Sahar',
        'subtitle': 'Soft, Floral, Uplifting',
        'notes': 'Key Notes: Rose Petals, White Musk.',
        'image': 'Sahar Image',
      },
      {
        'name': 'Rubaie Rose',
        'subtitle': 'Classic, Deep, Elegant',
        'notes': 'Key Notes: Indian Rose, Saffron, Sandalwood.',
        'image': 'Rubaie Rose Image',
      },
      {
        'name': 'Honey Lush',
        'subtitle': 'Warm, Sweet, Intimate',
        'notes': 'Key Notes: Honey Nectar, Vanilla Pod, Benzoin.',
        'image': 'Honey Lush Image',
      },
      {
        'name': 'Oud Majestic',
        'subtitle': 'Medium Oud, Commanding',
        'notes': 'Key Notes: Oud, Cardamom, Musk.',
        'image': 'Oud Majestic Image',
      },
    ];

    return products.map((product) => _buildProductCard(product)).toList();
  }

  Widget _buildProductCard(Map<String, String> product) {
    return GestureDetector(
      onTap: () => {},
          // onProductTap?.call(product['name']!),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
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
            // Product Image Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: QiratTheme.qiratGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  product['image']!,
                  style: TextStyle(
                    color: QiratTheme.qiratGold.withOpacity(0.7),
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product Name
            Text(
              product['name']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: QiratTheme.qiratGold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              product['subtitle']!,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: QiratTheme.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            Text(
              product['notes']!,
              style: const TextStyle(
                fontSize: 14,
                color: QiratTheme.darkOnBackground,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // View Details Link
            GestureDetector(
              onTap: () => {},
                  // onProductTap?.call(product['name']!),
              child: Row(
                children: [
                  Text(
                    'View Details',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: QiratTheme.qiratGold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: QiratTheme.qiratGold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

