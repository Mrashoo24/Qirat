import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/category/category.dart';

/// Category Header Widget - Horizontal scrollable category list
class QiratCategoryHeaderWidget extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category)? onCategoryTap;
  final VoidCallback? onViewAllTap;

  const QiratCategoryHeaderWidget({
    Key? key,
    required this.categories,
    this.selectedCategory,
    this.onCategoryTap,
    this.onViewAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      color: QiratTheme.darkSurface,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 12 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: QiratTheme.qiratGold,
                    fontFamily: 'Inter',
                  ),
                ),
                if (onViewAllTap != null)
                  TextButton(
                    onPressed: onViewAllTap,
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: QiratTheme.qiratGold,
                            fontSize: isMobile ? 14 : 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          color: QiratTheme.qiratGold,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: isMobile ? 50 : 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory?.id == category.id;

                return _buildCategoryItem(
                  category,
                  isSelected,
                  isMobile,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    Category category,
    bool isSelected,
    bool isMobile,
  ) {
    return GestureDetector(
      onTap: () => onCategoryTap?.call(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? QiratTheme.qiratGold : QiratTheme.darkSurfaceVariant,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? QiratTheme.qiratGold
                : QiratTheme.goldBorder.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: QiratTheme.qiratGold.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            category.name,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? QiratTheme.qiratBlack
                  : QiratTheme.darkOnBackground,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
