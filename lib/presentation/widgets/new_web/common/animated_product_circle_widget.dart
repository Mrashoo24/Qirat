import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Animated Product Circle Widget
/// Features:
/// - Circular animated switching of products
/// - Product highlights in circular arrangement
/// - Product image on the right side
/// - Add to cart button on top right
class AnimatedProductCircleWidget extends StatefulWidget {
  final List<ProductHighlight> products;
  final Function(ProductHighlight)? onProductTap;
  final Function(ProductHighlight)? onAddToCart;
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
          height: isMobile ? 500 : 600,
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Stack(
            children: [
              // Main content
              Row(
                children: [
                  // Left side - Circular product highlights
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: _buildCircularProductHighlights(context, isMobile),
                  ),

                  if (!isMobile) const SizedBox(width: 40),

                  // Right side - Product image and details
                  Expanded(
                    flex: isMobile ? 1 : 3,
                    child: _buildProductDisplay(context, isMobile),
                  ),
                ],
              ),

              // Add to cart button (top right)
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
            final x = centerX + radius * math.cos(angle - math.pi / 2);
            final y = centerY + radius * math.sin(angle - math.pi / 2);

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
                          image: product.imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(product.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: product.imageUrl == null
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Product Image
              Container(
                height: isMobile ? 200 : 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: QiratTheme.darkSurface,
                  image: currentProduct.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(currentProduct.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: currentProduct.imageUrl == null
                    ? Center(
                        child: Icon(
                          Icons.batch_prediction_outlined,
                          size: isMobile ? 60 : 80,
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
                  fontSize: isMobile ? 24 : 28,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                currentProduct.description,
                style: QiratTheme.bodyMedium.copyWith(
                  color: QiratTheme.textSecondary,
                  fontSize: isMobile ? 14 : 16,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Price and Rating
              Row(
                children: [
                  Text(
                    '₹${currentProduct.price}',
                    style: QiratTheme.titleLarge.copyWith(
                      color: QiratTheme.qiratGold,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 20 : 24,
                    ),
                  ),
                  if (currentProduct.originalPrice != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      '₹${currentProduct.originalPrice}',
                      style: QiratTheme.bodyMedium.copyWith(
                        color: QiratTheme.textMuted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (currentProduct.rating != null) ...[
                    Icon(
                      Icons.star,
                      color: QiratTheme.qiratGold,
                      size: isMobile ? 16 : 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${currentProduct.rating}',
                      style: QiratTheme.bodyMedium.copyWith(
                        color: QiratTheme.darkOnSurface,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          widget.onProductTap?.call(currentProduct),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: QiratTheme.qiratGold,
                        side: const BorderSide(color: QiratTheme.qiratGold),
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 12 : 16,
                        ),
                      ),
                      child: Text(isMobile ? 'View' : 'View Details'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => widget.onAddToCart?.call(currentProduct),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QiratTheme.qiratGold,
                        foregroundColor: QiratTheme.darkBackground,
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 12 : 16,
                        ),
                      ),
                      child: Text(isMobile ? 'Add' : 'Add to Cart'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: QiratTheme.qiratGold,
            boxShadow: [
              BoxShadow(
                color: QiratTheme.qiratGold.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () =>
                widget.onAddToCart?.call(widget.products[_currentIndex]),
            icon: const Icon(
              Icons.add,
              color: QiratTheme.qiratBlack,
              size: 24,
            ),
            tooltip: 'Add to Cart',
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
