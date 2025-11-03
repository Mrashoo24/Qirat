import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/category/category.dart';

/// Category Section Widget - Professional staggered grid showcase
class QiratCategorySectionWidget extends StatefulWidget {
  final List<Category> categories;
  final Function(Category)? onCategoryTap;
  final VoidCallback? onViewAllTap;


  const QiratCategorySectionWidget({
    Key? key,
    required this.categories,
    this.onCategoryTap,
    this.onViewAllTap,
  }) : super(key: key);

  @override
  State<QiratCategorySectionWidget> createState() =>
      _QiratCategorySectionWidgetState();
}

class _QiratCategorySectionWidgetState
    extends State<QiratCategorySectionWidget> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      color: QiratTheme.darkBackground,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            _buildSectionHeader(context, isMobile),

            SizedBox(height: isMobile ? 24 : 40),

            // Category Grid
            isMobile
                ? _buildMobileLayout()
                : isTablet
                    ? _buildTabletLayout()
                    : _buildDesktopLayout(),

            if (widget.onViewAllTap != null) ...[
              SizedBox(height: isMobile ? 32 : 48),
              _buildViewAllButton(context, isMobile),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop by Category',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover your perfect scent',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: QiratTheme.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          widget.categories[index],
          index,
          true,
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          widget.categories[index],
          index,
          false,
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return MasonryGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          widget.categories[index],
          index,
          false,
        );
      },
    );
  }

  Widget _buildCategoryCard(Category category, int index, bool isMobile) {
    final isHovered = _hoveredIndex == index;
    final imageUrl =
        isMobile ? (category.mobileImage ?? category.image) : category.image;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => widget.onCategoryTap?.call(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: QiratTheme.darkSurfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? QiratTheme.qiratGold
                  : QiratTheme.goldBorder.withOpacity(0.3),
              width: isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? QiratTheme.qiratGold.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
                blurRadius: isHovered ? 16 : 8,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Category Image
                _buildCategoryImage(imageUrl, category.name, isMobile),

                // Category Info
                // _buildCategoryInfo(category, isHovered, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage(String imageUrl, String name, bool isMobile) {
    return AspectRatio(
      aspectRatio: isMobile ? 1.0 : 1.2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderImage(isMobile),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImageLoader();
                  },
                )
              : _buildPlaceholderImage(isMobile),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo(Category category, bool isHovered, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Name
          Text(
            category.name,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: QiratTheme.darkOnBackground,
              fontFamily: 'Inter',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // const SizedBox(height: 8),
          //
          // // Explore Link with Animation
          // AnimatedContainer(
          //   duration: const Duration(milliseconds: 300),
          //   child: Row(
          //     children: [
          //       Text(
          //         'Explore',
          //         style: TextStyle(
          //           fontSize: isMobile ? 13 : 14,
          //           fontWeight: FontWeight.w600,
          //           color: QiratTheme.qiratGold,
          //           fontFamily: 'Inter',
          //         ),
          //       ),
          //       const SizedBox(width: 4),
          //       AnimatedContainer(
          //         duration: const Duration(milliseconds: 300),
          //         transform: Matrix4.translationValues(
          //           isHovered ? 4 : 0,
          //           0,
          //           0,
          //         ),
          //         child: Icon(
          //           Icons.arrow_forward,
          //           size: isMobile ? 14 : 16,
          //           color: QiratTheme.qiratGold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(bool isMobile) {
    return Container(
      color: QiratTheme.darkSurfaceVariant,
      child: Center(
        child: Icon(
          Icons.category,
          color: QiratTheme.qiratGold.withOpacity(0.3),
          size: isMobile ? 48 : 64,
        ),
      ),
    );
  }

  Widget _buildImageLoader() {
    return Container(
      color: QiratTheme.darkSurfaceVariant,
      child: Center(
        child: CircularProgressIndicator(
          color: QiratTheme.qiratGold,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context, bool isMobile) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: widget.onViewAllTap,
        icon: const Icon(Icons.grid_view),
        label: const Text('View All Categories'),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 32,
            vertical: isMobile ? 14 : 16,
          ),
          side: const BorderSide(
            color: QiratTheme.goldBorder,
            width: 1.5,
          ),
          foregroundColor: QiratTheme.qiratGold,
          textStyle: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
