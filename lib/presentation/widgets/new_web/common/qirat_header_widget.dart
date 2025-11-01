import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Fixed Header Navigation Bar for Qirat Website
class QiratHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showShadow;
  final VoidCallback? onCartTap;
  final VoidCallback? onMenuTap;

  const QiratHeaderWidget({
    Key? key,
    this.showShadow = true,
    this.onCartTap,
    this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: QiratTheme.darkBackground,
        border: Border(
          bottom: BorderSide(
            color: QiratTheme.borderDark,
            width: 1,
          ),
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.responsive(
            context: context,
            mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: ResponsiveLayout(
            mobileLayout: _buildMobileLayout(context),
            desktopLayout: _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Row(
      children: [
        // Logo
        _buildLogo(),
        const Spacer(),
        // Cart Icon
        IconButton(
          onPressed: onCartTap,
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: QiratTheme.darkOnSurface,
            size: 24,
          ),
        ),
        // Menu Icon
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(
            Icons.menu,
            color: QiratTheme.qiratGold,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Logo
        _buildLogo(),
        const Spacer(),
        // Navigation Links
        _buildNavigation(context),
        const SizedBox(width: 32),
        // Cart Icon
        IconButton(
          onPressed: onCartTap,
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: QiratTheme.darkOnSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Qirat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
              letterSpacing: 1.2,
            ),
          ),
          TextSpan(
            text: ' Attars',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: QiratTheme.darkOnSurface,
              fontFamily: 'Inter',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Row(
      children: [
        _buildNavItem('Home', true),
        const SizedBox(width: 32),
        _buildNavItem('Products', false),
        const SizedBox(width: 32),
        _buildNavItem('Our Story', false),
        const SizedBox(width: 32),
        _buildNavItem('Contact', false),
      ],
    );
  }

  Widget _buildNavItem(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: isActive
          ? BoxDecoration(
              color: QiratTheme.darkSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isActive ? QiratTheme.qiratGold : QiratTheme.darkOnSurface,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
