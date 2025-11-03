import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/product/product.dart';

/// Animated Product Circle Widget
/// Features:
/// - Circular animated switching of products
/// - Product highlights in circular arrangement
/// - Product image on the right side
/// - Add to cart button on top right
class AnimatedProductCircleWidget extends StatefulWidget {
  final List<Product> products;
  final Function(Product)? onProductTap;
  final Function(Product)? onAddToCart;
  final Duration animationDuration;
  final Duration switchDuration;

  const AnimatedProductCircleWidget({
    Key? key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.animationDuration = const Duration(seconds: 1),
    this.switchDuration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<AnimatedProductCircleWidget> createState() =>
      _AnimatedProductCircleWidgetState();
}

class _AnimatedProductCircleWidgetState
    extends State<AnimatedProductCircleWidget> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Timer _switchTimer;

  int _currentIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Rotation animation for the circle
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Fade animation for product switching
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    // Pulse animation for add to cart button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _switchTimer = Timer.periodic(widget.switchDuration, (timer) {
      if (!_isAnimating) {
        _switchToNext();
      }
    });
  }

  void _switchToNext() {
    if (widget.products.isEmpty) return;

    setState(() {
      _isAnimating = true;
    });

    _fadeController.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.products.length;
      });

      _rotationController.forward().then((_) {
        _rotationController.reset();
        _fadeController.forward().then((_) {
          setState(() {
            _isAnimating = false;
          });
        });
      });
    });
  }

  void _selectProduct(int index) {
    if (_isAnimating || index == _currentIndex) return;

    setState(() {
      _isAnimating = true;
    });

    _fadeController.reverse().then((_) {
      setState(() {
        _currentIndex = index;
      });

      _fadeController.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _switchTimer.cancel();
    _rotationController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const Center(
        child: Text('No products available'),
      );
    }

    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        return Container(
          height: isMobile ? null : 600,
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Stack(
            children: [
              // Main content
              isMobile
                  ? Column(
                      children: [
                        // Top - Circular product highlights
                        _buildCircularProductHighlights(context, isMobile),

                        const SizedBox(height: 24),

                        // Bottom - Product image and details
                        _buildProductDisplay(context, isMobile),
                      ],
                    )
                  : Row(
                      children: [
                        // Left side - Circular product highlights
                        Expanded(
                          flex: 2,
                          child: _buildCircularProductHighlights(
                              context, isMobile),
                        ),

                        const SizedBox(width: 40),

                        // Right side - Product image and details
                        Expanded(
                          flex: 3,
                          child: _buildProductDisplay(context, isMobile),
                        ),
                      ],
                    ),

              // Add to cart button (top right)
              if (!isMobile)
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildAddToCartButton(context),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularProductHighlights(BuildContext context, bool isMobile) {
    final radius = isMobile ? 120.0 : 180.0;
    final centerX = radius + 40;
    final centerY = radius + 40;

    return Container(
      width: (radius + 40) * 2,
      height: (radius + 40) * 2,
      child: Stack(
        children: [
          // Center circle with current product info
          Positioned(
            left: centerX - 60,
            top: centerY - 60,
            child: AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeController.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: QiratTheme.qiratGold.withOpacity(0.1),
                      border: Border.all(
                        color: QiratTheme.qiratGold,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: QiratTheme.qiratGold,
                          size: isMobile ? 24 : 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Featured',
                          style: QiratTheme.titleMedium.copyWith(
                            color: QiratTheme.qiratGold,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Product highlights in circle
          ...widget.products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            final angle = (2 * math.pi / widget.products.length) * index;

            return AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                final rotationAngle = _rotationController.value * 2 * math.pi;
                final adjustedX = centerX +
                    radius * math.cos(angle - math.pi / 2 + rotationAngle);
                final adjustedY = centerY +
                    radius * math.sin(angle - math.pi / 2 + rotationAngle);

                return Positioned(
                  left: adjustedX - 30,
                  top: adjustedY - 30,
                  child: GestureDetector(
                    onTap: () => _selectProduct(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentIndex
                            ? QiratTheme.qiratGold
                            : QiratTheme.darkSurface,
                        border: Border.all(
                          color: QiratTheme.qiratGold,
                          width: index == _currentIndex ? 3 : 1,
                        ),
                        boxShadow: index == _currentIndex
                            ? [
                                BoxShadow(
                                  color: QiratTheme.qiratGold.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: product.images.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(product.images.last),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: product.images.isNotEmpty
                            ? Icon(
                                Icons.batch_prediction_outlined,
                                color: index == _currentIndex
                                    ? QiratTheme.darkBackground
                                    : QiratTheme.qiratGold,
                                size: isMobile ? 20 : 24,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProductDisplay(BuildContext context, bool isMobile) {
    final currentProduct = widget.products[_currentIndex];

    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeController.value,
          child: isMobile
              ? _buildMobileProductDisplay(currentProduct, isMobile)
              : _buildDesktopProductDisplay(currentProduct, isMobile),
        );
      },
    );
  }

  Widget _buildMobileProductDisplay(
      Product currentProduct, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Product Image
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: QiratTheme.darkSurface,
            border: Border.all(color: QiratTheme.qiratGold.withOpacity(0.3)),
            image: currentProduct.images.last != null
                ? DecorationImage(
                    image: NetworkImage(currentProduct.images.last!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: currentProduct.images.last == null
              ? Center(
                  child: Icon(
                    Icons.batch_prediction_outlined,
                    size: 60,
                    color: QiratTheme.qiratGold,
                  ),
                )
              : null,
        ),

        const SizedBox(height: 24),

        // Product Details
        Text(
          currentProduct.name,
          style: QiratTheme.headlineMedium.copyWith(
            color: QiratTheme.darkOnSurface,
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          currentProduct.description,
          style: QiratTheme.bodyMedium.copyWith(
            color: QiratTheme.textSecondary,
            fontSize: 14,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 16),

        // Price and Rating
        Row(
          children: [
            Text(
              '₹${currentProduct.priceTags.first.price}',
              style: QiratTheme.titleLarge.copyWith(
                color: QiratTheme.qiratGold,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (currentProduct.priceTags.first.price != null) ...[
              const SizedBox(width: 12),
              Text(
                '₹${currentProduct.priceTags.first.price}',
                style: QiratTheme.bodyMedium.copyWith(
                  color: QiratTheme.textMuted,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            const Spacer(),
            // if (currentProduct.rating != null) ...[
            //   Icon(
            //     Icons.star,
            //     color: QiratTheme.qiratGold,
            //     size: 16,
            //   ),
            //   const SizedBox(width: 4),
            //   Text(
            //     '${currentProduct.rating}',
            //     style: QiratTheme.bodyMedium.copyWith(
            //       color: QiratTheme.darkOnSurface,
            //     ),
            //   ),
            // ],
          ],
        ),

        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => widget.onProductTap?.call(currentProduct),
                style: OutlinedButton.styleFrom(
                  foregroundColor: QiratTheme.qiratGold,
                  side: const BorderSide(color: QiratTheme.qiratGold),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => widget.onAddToCart?.call(currentProduct),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QiratTheme.qiratGold,
                  foregroundColor: QiratTheme.darkBackground,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopProductDisplay(
      Product currentProduct, bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Product Details
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge for featured/new products
              // if (currentProduct.isFeatured || currentProduct.isNew)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: QiratTheme.qiratGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: QiratTheme.qiratGold),
                  ),
                  child: Text(
                    // currentProduct.isFeatured ? 'FEATURED' :
                    'NEW',
                    style: QiratTheme.bodyMedium.copyWith(
                      color: QiratTheme.qiratGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Product Name
              Text(
                currentProduct.name,
                style: QiratTheme.headlineMedium.copyWith(
                  color: QiratTheme.darkOnSurface,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Category
              // if (currentProduct.category != null)
              //   Text(
              //     currentProduct.category!.toUpperCase(),
              //     style: QiratTheme.bodyMedium.copyWith(
              //       color: QiratTheme.qiratGold.withOpacity(0.7),
              //       fontSize: 14,
              //       letterSpacing: 2,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),

              const SizedBox(height: 16),

              // Description
              Text(
                currentProduct.description,
                style: QiratTheme.bodyMedium.copyWith(
                  color: QiratTheme.textSecondary,
                  fontSize: 16,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 24),

              // Price and Rating Row
              Row(
                children: [
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRICE',
                        style: QiratTheme.bodyMedium.copyWith(
                          color: QiratTheme.textSecondary,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${currentProduct.priceTags.first.price}',
                            style: QiratTheme.titleLarge.copyWith(
                              color: QiratTheme.qiratGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          if (currentProduct.priceTags != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              '₹${currentProduct.priceTags.first.price}',
                              style: QiratTheme.bodyMedium.copyWith(
                                color: QiratTheme.textMuted,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  // Rating
                  // if (currentProduct.rating != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RATING',
                          style: QiratTheme.bodyMedium.copyWith(
                            color: QiratTheme.textSecondary,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: QiratTheme.qiratGold,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${math.Random(5).nextInt(5)}/5.0',
                              style: QiratTheme.titleLarge.copyWith(
                                color: QiratTheme.darkOnSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          widget.onProductTap?.call(currentProduct),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: QiratTheme.qiratGold,
                        side: const BorderSide(
                            color: QiratTheme.qiratGold, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Text(
                        'VIEW DETAILS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => widget.onAddToCart?.call(currentProduct),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QiratTheme.qiratGold,
                        foregroundColor: QiratTheme.darkBackground,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        'ADD TO CART',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 40),

        // Right: Product Image
        Expanded(
          flex: 2,
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: QiratTheme.darkSurface,
              border: Border.all(
                color: QiratTheme.qiratGold.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: QiratTheme.qiratGold.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
              image: currentProduct.images.last != null
                  ? DecorationImage(
                      image: NetworkImage(currentProduct.images.last!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: currentProduct.images.last == null
                ? Center(
                    child: Icon(
                      Icons.batch_prediction_outlined,
                      size: 100,
                      color: QiratTheme.qiratGold,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeController, _pulseController]),
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.15);
        final pulseOpacity = 0.3 + (_pulseController.value * 0.3);

        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: QiratTheme.qiratGold,
              boxShadow: [
                BoxShadow(
                  color: QiratTheme.qiratGold.withOpacity(pulseOpacity),
                  blurRadius: 15 + (_pulseController.value * 10),
                  spreadRadius: 3 + (_pulseController.value * 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () =>
                  widget.onAddToCart?.call(widget.products[_currentIndex]),
              icon: const Icon(
                Icons.add_shopping_cart,
                color: QiratTheme.qiratBlack,
                size: 24,
              ),
              tooltip: 'Add to Cart',
            ),
          ),
        );
      },
    );
  }
}

/// Product Highlight Model
class ProductHighlight {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final double? rating;
  final String? category;
  final bool isNew;
  final bool isFeatured;

  const ProductHighlight({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.rating,
    this.category,
    this.isNew = false,
    this.isFeatured = false,
  });
}
