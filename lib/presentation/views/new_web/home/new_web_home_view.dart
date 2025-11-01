import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../base/new_web_base_view.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// New Web Home View - Example implementation
/// This demonstrates how to use the NewWebBaseView
class NewWebHomeView extends NewWebBaseView {
  const NewWebHomeView({Key? key}) : super(key: key);

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        _buildHeroSection(context),
        _buildFeaturedProducts(context),
        _buildCategories(context),
        _buildAboutSection(context),
      ],
    );
  }

  @override
  Widget buildMobileContent(BuildContext context) {
    return Column(
      children: [
        _buildMobileHeroSection(context),
        _buildMobileFeaturedProducts(context),
        _buildMobileCategories(context),
        _buildMobileAboutSection(context),
      ],
    );
  }

  /// Hero Section for Desktop
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [QiratTheme.qiratGold, QiratTheme.qiratGoldVariant],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getContentMaxWidth(context),
          ),
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '20 Years of\nFragrance Excellence',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Discover our exquisite collection of premium attars and perfumes, crafted with passion and tradition.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate to products
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: QiratTheme.qiratGold,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Text('Shop Now'),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () {
                              // TODO: Navigate to about
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Text('Learn More'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hero Section for Mobile
  Widget _buildMobileHeroSection(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [QiratTheme.qiratGold, QiratTheme.qiratGoldVariant],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '20 Years of\nFragrance Excellence',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Discover our exquisite collection of premium attars and perfumes.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to products
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: QiratTheme.qiratGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Shop Now'),
            ),
          ],
        ),
      ),
    );
  }

  /// Featured Products Section
  Widget _buildFeaturedProducts(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Text(
            'Featured Products',
            style: QiratTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridColumns(context),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.8,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildProductCard(context, index);
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildMobileFeaturedProducts(BuildContext context) {
    return _buildFeaturedProducts(context);
  }

  Widget _buildProductCard(BuildContext context, int index) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product ${index + 1}',
                    style: QiratTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${(index + 1) * 100}',
                    style: QiratTheme.titleLarge.copyWith(
                      color: QiratTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Categories Section
  Widget _buildCategories(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Text(
            'Shop by Category',
            style: QiratTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.responsive(
                context: context,
                mobile: 2,
                tablet: 3,
                desktop: 4,
              ),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildCategoryCard(context, index);
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildMobileCategories(BuildContext context) {
    return _buildCategories(context);
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    final categories = [
      'Attars',
      'Perfumes',
      'Essential Oils',
      'Gift Sets',
      'Accessories',
      'New Arrivals'
    ];

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: QiratTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.category,
                  color: QiratTheme.primaryColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                categories[index],
                style: QiratTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// About Section
  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Text(
            'Why Choose Qirat?',
            style: QiratTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ResponsiveBuilder(
            builder: (context, isMobile, isTablet, isDesktop) {
              if (isMobile) {
                return Column(
                  children: _buildAboutItems(),
                );
              } else {
                return Row(
                  children: _buildAboutItems()
                      .map((item) => Expanded(child: item))
                      .toList(),
                );
              }
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildMobileAboutSection(BuildContext context) {
    return _buildAboutSection(context);
  }

  List<Widget> _buildAboutItems() {
    final items = [
      {
        'icon': Icons.verified,
        'title': 'Authentic',
        'description': 'Genuine products with quality assurance'
      },
      {
        'icon': Icons.local_shipping,
        'title': 'Fast Delivery',
        'description': 'Quick and secure shipping nationwide'
      },
      {
        'icon': Icons.support_agent,
        'title': '24/7 Support',
        'description': 'Always here to help you'
      },
    ];

    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: QiratTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: QiratTheme.primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item['title'] as String,
              style: QiratTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              item['description'] as String,
              style: QiratTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }).toList();
  }
}
