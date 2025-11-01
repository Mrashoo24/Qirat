import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Collection Section Widget - Showcasing Qirat's product collection with animated circle
class QiratCollectionHorizontalSectionWidget extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final Function(String)? onProductTap;
  final Function(String)? onAddToCart;

  const QiratCollectionHorizontalSectionWidget({
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
              // Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
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
              ),

              SizedBox(
                height: ResponsiveHelper.responsive(
                  context: context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 16,
                ),
              ),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Discover our signature attars and perfumes',
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
              ),

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

              SizedBox(
                height: ResponsiveHelper.responsive(
                  context: context,
                  mobile: 32,
                  tablet: 40,
                  desktop: 48,
                ),
              ),

              // View All Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    'Explore The Full Attar Portfolio',
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
            ],
          ),
        ),
      ),
    );
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
        children: _buildProductCards(false).map((card) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _buildProductCards(true).map((card) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: card,
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildProductCards(bool isMobile) {
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

    return products.map((product) => _buildProductCard(product, isMobile)).toList();
  }

  Widget _buildProductCard(Map<String, String> product, bool isMobile) {
    final cardWidth = isMobile ? 280.0 : 320.0;
    final imagHeight = isMobile ? 160.0 : 200.0;
    final cardPadding = isMobile ? 16.0 : 24.0;
    final titleSize = isMobile ? 20.0 : 24.0;

    return GestureDetector(
      onTap: () => onProductTap?.call(product['name']!),
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
            // Product Image Placeholder
            Container(
              height: imagHeight,
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
                    fontSize: isMobile ? 12 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 20),

            // Product Name
            Text(
              product['name']!,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: QiratTheme.qiratGold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              product['subtitle']!,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                fontStyle: FontStyle.italic,
                color: QiratTheme.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            Text(
              product['notes']!,
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: QiratTheme.darkOnBackground,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // View Details Link
            GestureDetector(
              onTap: () => onProductTap?.call(product['name']!),
              child: Row(
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.w500,
                      color: QiratTheme.qiratGold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: isMobile ? 14 : 16,
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
}
