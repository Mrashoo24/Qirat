import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/theme/qirat_theme.dart';

/// Base template for all new web views
/// Provides consistent layout and responsive behavior
abstract class NewWebBaseView extends StatelessWidget {
  /// Title shown in app bar (optional)
  final String? title;

  /// Whether to show the navigation bar
  final bool showNavBar;

  /// Whether to show the footer
  final bool showFooter;

  /// Background color (optional)
  final Color? backgroundColor;

  const NewWebBaseView({
    Key? key,
    this.title,
    this.showNavBar = true,
    this.showFooter = true,
    this.backgroundColor,
  }) : super(key: key);

  /// Build the main content of the view
  Widget buildContent(BuildContext context);

  /// Build mobile-specific content (optional override)
  Widget buildMobileContent(BuildContext context) => buildContent(context);

  /// Build desktop-specific content (optional override)
  Widget buildDesktopContent(BuildContext context) => buildContent(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? QiratTheme.darkBackground,
      body: ResponsiveLayout(
        mobileLayout: _buildMobileLayout(context),
        desktopLayout: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        if (showNavBar) _buildMobileNavBar(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildMobileContent(context),
                if (showFooter) _buildFooter(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        if (showNavBar) _buildDesktopNavBar(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getContentMaxWidth(context),
                  ),
                  child: buildDesktopContent(context),
                ),
                if (showFooter) _buildFooter(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Mobile Navigation Bar
  Widget _buildMobileNavBar(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo/Brand
          Text(
            'Qirat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: QiratTheme.qiratGold,
            ),
          ),
          const Spacer(),
          // Mobile Menu Button
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // TODO: Show mobile menu
            },
          ),
        ],
      ),
    );
  }

  /// Desktop Navigation Bar
  Widget _buildDesktopNavBar(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo/Brand
          Text(
            'Qirat Attars & Perfume',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: QiratTheme.qiratGold,
            ),
          ),
          const Spacer(),
          // Navigation Links
          _buildNavLink('Home'),
          const SizedBox(width: 32),
          _buildNavLink('Products'),
          const SizedBox(width: 32),
          _buildNavLink('Categories'),
          const SizedBox(width: 32),
          _buildNavLink('About'),
          const SizedBox(width: 32),
          // Search Bar
          SizedBox(
            width: 300,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Actions
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Navigate to wishlist
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Navigate to profile/login
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text) {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to respective pages
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: QiratTheme.darkOnSurface,
        ),
      ),
    );
  }

  /// Footer
  Widget _buildFooter(BuildContext context) {
    return Container(
      color: QiratTheme.darkBackground,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          ResponsiveBuilder(
            builder: (context, isMobile, isTablet, isDesktop) {
              if (isMobile) {
                return _buildMobileFooter();
              } else {
                return _buildDesktopFooter();
              }
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            '© 2025 Qirat Attars & Perfume. All rights reserved.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFooter() {
    return const Column(
      children: [
        Text(
          'Qirat Attars & Perfume',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          '20 Years of Fragrance Excellence',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Qirat Attars & Perfume',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '20 Years of Fragrance Excellence',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Links',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildFooterLink('Home'),
              _buildFooterLink('Products'),
              _buildFooterLink('Categories'),
              _buildFooterLink('About Us'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Service',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildFooterLink('Contact Us'),
              _buildFooterLink('FAQ'),
              _buildFooterLink('Returns'),
              _buildFooterLink('Shipping'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
