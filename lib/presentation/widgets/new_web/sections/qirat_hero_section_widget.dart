import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/entities/category/category.dart';

/// Hero Section Widget - Animated product showcase with rotating carousel
class QiratHeroSectionWidget extends StatefulWidget {
  final List<Product> topSellingProducts;
  final List<Category> categories;
  final Function(Product, String)? onAddToCart;
  final Function(Category)? onCategoryTap;
  final VoidCallback? onFindScentTap;
  final VoidCallback? onExploreAllTap;

  const QiratHeroSectionWidget({
    Key? key,
    required this.topSellingProducts,
    this.categories = const [],
    this.onAddToCart,
    this.onCategoryTap,
    this.onFindScentTap,
    this.onExploreAllTap,
  }) : super(key: key);

  @override
  State<QiratHeroSectionWidget> createState() => _QiratHeroSectionWidgetState();
}

class _QiratHeroSectionWidgetState extends State<QiratHeroSectionWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  Timer? _autoRotateTimer;
  int _currentProductIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Rotation animation for the circle (triggered on product change)
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse animation for add to cart button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Auto-rotate products every 5 seconds
    _startAutoRotate();
  }

  void _startAutoRotate() {
    _autoRotateTimer?.cancel();
    if (widget.topSellingProducts.length > 1) {
      _autoRotateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (mounted) {
          _switchToNextProduct();
        }
      });
    }
  }

  void _switchToNextProduct() {
    final nextPage =
        (_currentProductIndex + 1) % widget.topSellingProducts.length;

    // Rotate the circle while switching products
    _rotationController.forward(from: 0.0);

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    _pageController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topSellingProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: QiratTheme.darkBackground,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Column(
          children: [
            // // Categories Section (if provided)
            // if (widget.categories.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 24),
            //     child: _buildCategoriesSection(context),
            //   ),

            // Original Hero Content
            ResponsiveLayout(
              mobileLayout: _buildMobileLayout(context),
              desktopLayout: _buildDesktopLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
          child: Text(
            'Shop by Category',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: isMobile ? 100 : 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryChip(
                widget.categories[index],
                isMobile,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(Category category, bool isMobile) {
    return GestureDetector(
      onTap: () => widget.onCategoryTap?.call(category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 24,
          vertical: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: QiratTheme.darkSurfaceVariant,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: QiratTheme.goldBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  category.image,
                  width: isMobile ? 40 : 50,
                  height: isMobile ? 40 : 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.category,
                    color: QiratTheme.qiratGold,
                    size: isMobile ? 40 : 50,
                  ),
                ),
              ),
            SizedBox(width: isMobile ? 8 : 12),
            Text(
              category.name,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: QiratTheme.darkOnBackground,
                fontFamily: 'Inter',
              ),
            ),
          ],
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
          // Right Animated Product Circle
          Expanded(
            flex: 2,
            child: _buildAnimatedProductCircle(context, false),
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
          // Animated Product Circle (Top on mobile)
          _buildAnimatedProductCircle(context, true),
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
          'Pure, alcohol-free attar designed for the Indian climate. Gets richer as the day gets hotter.',
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

        // Product Navigation Dots
        _buildProductDots(isMobile),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: widget.onFindScentTap,
            icon: const Text('✨'),
            label: const Text('Find Your Signature Scent'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: QiratTheme.qiratGold,
              foregroundColor: QiratTheme.qiratBlack,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: widget.onExploreAllTap,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Explore All Attars'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: QiratTheme.goldBorder),
              foregroundColor: QiratTheme.qiratGold,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: widget.onFindScentTap,
          icon: const Text('✨'),
          label: const Text('Find Your Signature Scent'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: QiratTheme.qiratGold,
            foregroundColor: QiratTheme.qiratBlack,
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          onPressed: widget.onExploreAllTap,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Explore All Attars'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: const BorderSide(color: QiratTheme.goldBorder),
            foregroundColor: QiratTheme.qiratGold,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDots(bool isMobile) {
    return Row(
      children: List.generate(
        widget.topSellingProducts.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentProductIndex == index ? 32 : 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: _currentProductIndex == index
                ? QiratTheme.qiratGold
                : QiratTheme.goldBorder.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedProductCircle(BuildContext context, bool isMobile) {
    final size = isMobile ? 320.0 : 500.0;

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Grey circle border (static)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),

          // Rotating highlighted arcs
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: CircleArcPainter(
                    color: QiratTheme.qiratGold,
                    strokeWidth: 3,
                  ),
                ),
              );
            },
          ),

          // Product content inside circle
          Container(
            width: size * 0.75,
            height: size * 0.75,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentProductIndex = index;
                });
              },
              itemCount: widget.topSellingProducts.length,
              itemBuilder: (context, index) {
                return _buildProductContent(
                  widget.topSellingProducts[index],
                  isMobile,
                );
              },
            ),
          ),

          // Plus icon on circle (top right)
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: _buildAddToCartFloatingButton(isMobile),
          ),

        ],
      ),
    );
  }

  Widget _buildProductContent(Product product, bool isMobile) {
    return Row(
      children: [
        // Left: Product Details
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Category
                // Text(
                //   product.categories.isNotEmpty
                //       ? product.categories.first
                //       : 'Cosmetic',
                //   style: TextStyle(
                //     fontSize: isMobile ? 12 : 14,
                //     color: QiratTheme.textSecondary,
                //     fontFamily: 'Inter',
                //   ),
                // ),
                // SizedBox(height: isMobile ? 8 : 12),

                // Product Name

                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: QiratTheme.qiratGold,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 8 : 12),

                if (product.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 8.0,
                    children:product.tags
                        .map((t) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Icon(Icons.circle,
                            size: 6, color: QiratTheme.qiratGold),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            product.tags.isNotEmpty ? t : 'No Tags',
                            maxLines: 2,
                            style: TextStyle(
                              color: QiratTheme.textSecondary,
                              fontFamily: 'Inter',
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],

                SizedBox(height: isMobile ? 8 : 12),
                // Description
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    color: QiratTheme.textSecondary,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        // Right: Product Image
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: QiratTheme.qiratGold.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: product.images.isNotEmpty
                    ? Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildCircularPlaceholder(isMobile),
                      )
                    : _buildCircularPlaceholder(isMobile),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircularPlaceholder(bool isMobile) {
    return Container(
      color: QiratTheme.darkSurfaceVariant,
      child: Icon(
        Icons.image_outlined,
        size: isMobile ? 40 : 60,
        color: QiratTheme.textMuted,
      ),
    );
  }

  Widget _buildAddToCartFloatingButton(bool isMobile) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          final currentProduct =
              widget.topSellingProducts[_currentProductIndex];
          if (widget.onAddToCart != null &&
              currentProduct.priceTags.isNotEmpty) {
            widget.onAddToCart!(
                currentProduct, currentProduct.priceTags.first.id);
          }
        },
        child: Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: QiratTheme.qiratGold,
            boxShadow: [
              BoxShadow(
                color: QiratTheme.qiratGold.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            color: QiratTheme.qiratBlack,
            size: isMobile ? 24 : 28,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDisplay(Product product, bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Product Image
        Container(
          width: isMobile ? 120 : 180,
          height: isMobile ? 160 : 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: QiratTheme.qiratGold.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: product.images.isNotEmpty
                ? Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: QiratTheme.darkSurfaceVariant,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: QiratTheme.textMuted,
                      ),
                    ),
                  )
                : Container(
                    color: QiratTheme.darkSurfaceVariant,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: QiratTheme.textMuted,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Product Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: QiratTheme.darkOnBackground,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (product.priceTags.isNotEmpty)
                Text(
                  '₹${product.priceTags.first.price}',
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 28,
                    fontWeight: FontWeight.bold,
                    color: QiratTheme.qiratGold,
                    fontFamily: 'Inter',
                  ),
                ),
              const SizedBox(height: 16),

              // Add to Cart Button with Pulse Animation
              _buildAnimatedAddToCartButton(product, isMobile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedAddToCartButton(Product product, bool isMobile) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: QiratTheme.qiratGold.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            if (widget.onAddToCart != null && product.priceTags.isNotEmpty) {
              widget.onAddToCart!(product, product.priceTags.first.id);
            }
          },
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: QiratTheme.qiratBlack.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_shopping_cart,
              size: 20,
            ),
          ),
          label: const Text('Add to Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: QiratTheme.qiratGold,
            foregroundColor: QiratTheme.qiratBlack,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 32,
              vertical: isMobile ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for drawing highlighted arcs on the circle border
class CircleArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CircleArcPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw first highlighted arc (top right)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 6, // Start angle (30 degrees from top)
      math.pi / 6, // Sweep angle (30 degrees)
      false,
      paint,
    );

    // Draw second highlighted arc (bottom left)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 5 / 6, // Start angle (150 degrees from top)
      math.pi / 6, // Sweep angle (30 degrees)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleArcPainter oldDelegate) => false;
}
