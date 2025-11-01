import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Hero Section Widget - Main landing area with product showcase
class QiratHeroSectionWidget extends StatelessWidget {
  final VoidCallback? onFindScentTap;
  final VoidCallback? onExploreAllTap;

  const QiratHeroSectionWidget({
    Key? key,
    this.onFindScentTap,
    this.onExploreAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: QiratTheme.darkBackground,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: ResponsiveLayout(
          mobileLayout: _buildMobileLayout(context),
          desktopLayout: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Row(
        children: [
          // Left Content
          Expanded(
            flex: 3,
            child: _buildContent(context, false),
          ),
          const SizedBox(width: 80),
          // Right Product Circle
          Expanded(
            flex: 2,
            child: _buildProductCircle(context, false),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Product Circle (Top on mobile)
          _buildProductCircle(context, true),
          const SizedBox(height: 40),
          // Content (Bottom on mobile)
          _buildContent(context, true),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Headline
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 40 : 56,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
              height: 1.1,
              letterSpacing: -1,
            ),
            children: const [
              TextSpan(
                text: 'The Purity.\n',
                style: TextStyle(color: QiratTheme.darkOnBackground),
              ),
              TextSpan(
                text: 'The Projection.\n',
                style: TextStyle(color: QiratTheme.qiratGold),
              ),
              TextSpan(
                text: 'The Attar.',
                style: TextStyle(color: QiratTheme.darkOnBackground),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Subtitle
        Text(
          '**Mawj: The Essence of Waves.** Pure, alcohol-free attar designed for the Indian climate. Gets richer as the day gets hotter.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: QiratTheme.textSecondary,
            fontFamily: 'Inter',
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        // Action Buttons
        _buildActionButtons(context, isMobile),
        const SizedBox(height: 40),

        // Product Cards
        _buildProductCards(context, isMobile),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: onFindScentTap,
            icon: const Text('✨'),
            label: const Text('Find Your Signature Scent'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onExploreAllTap,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Explore All Attars'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onFindScentTap,
          icon: const Text('✨'),
          label: const Text('Find Your Signature Scent'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          onPressed: onExploreAllTap,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Explore All Attars'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCards(BuildContext context, bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildProductCard('Mawj (12ml)', '₹699', true),
          const SizedBox(width: 16),
          _buildProductCard('Sahar (6ml)', '₹399', false),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String price, bool isFeatured) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(
          color: isFeatured ? QiratTheme.goldBorder : QiratTheme.borderDark,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: QiratTheme.darkOnSurface,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Product Image Placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: isFeatured
                  ? QiratTheme.qiratGold.withOpacity(0.1)
                  : QiratTheme.darkSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Product Image\nPlaceholder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isFeatured
                      ? QiratTheme.qiratGold.withOpacity(0.7)
                      : QiratTheme.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCircle(BuildContext context, bool isMobile) {
    final size = isMobile ? 280.0 : 350.0;

    return SizedBox(
      height: isMobile ? 350 : 450,
      child: Center(
        child: Stack(
          children: [
            // Main Circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: QiratTheme.goldBorder,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: QiratTheme.qiratGold.withOpacity(0.2),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Qirat Attar',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: QiratTheme.qiratGold,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pure Essence. 12ml Roll-On.',
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          fontStyle: FontStyle.italic,
                          color: QiratTheme.textSecondary,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Alcohol-free, long-lasting formulation for the modern connoisseur.',
                        style: TextStyle(
                          fontSize: isMobile ? 9 : 10,
                          color: QiratTheme.textSecondary,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Product Bottle (positioned)
            Positioned(
              bottom: size * 0.15,
              right: size * 0.2,
              child: Transform.rotate(
                angle: -0.2,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    color: QiratTheme.qiratGold.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: QiratTheme.qiratGold,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'MAWJ',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: QiratTheme.qiratBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative Icons
            Positioned(
              top: size * 0.1,
              right: size * 0.15,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: QiratTheme.qiratGold.withOpacity(0.7),
                ),
                child: const Icon(
                  Icons.add,
                  color: QiratTheme.qiratBlack,
                  size: 16,
                ),
              ),
            ),

            Positioned(
              bottom: size * 0.1,
              left: size * 0.15,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: QiratTheme.qiratGold),
                ),
                child: const Icon(
                  Icons.hexagon_outlined,
                  color: QiratTheme.qiratGold,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
