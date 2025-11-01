import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Differences Section Widget - Highlighting Qirat's unique value propositions
class QiratDifferencesSectionWidget extends StatelessWidget {
  const QiratDifferencesSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: QiratTheme.darkBackground,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            children: [
              // Section Header
              _buildSectionHeader(context),
              const SizedBox(height: 48),

              // Features Grid
              ResponsiveBuilder(
                builder: (context, isMobile, isTablet, isDesktop) {
                  if (isMobile) {
                    return _buildMobileLayout();
                  } else {
                    return _buildDesktopLayout();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'The Qirat Difference',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: QiratTheme.qiratGold,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                fontSize: 16,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          'Purity is the new projection.',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: QiratTheme.darkOnBackground,
                fontWeight: FontWeight.w800,
                fontSize: ResponsiveHelper.responsive(
                  context: context,
                  mobile: 36,
                  tablet: 42,
                  desktop: 48,
                ),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(child: _buildFeatureCard(0)),
        const SizedBox(width: 32),
        Expanded(child: _buildFeatureCard(1)),
        const SizedBox(width: 32),
        Expanded(child: _buildFeatureCard(2)),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildFeatureCard(0),
        const SizedBox(height: 24),
        _buildFeatureCard(1),
        const SizedBox(height: 24),
        _buildFeatureCard(2),
      ],
    );
  }

  Widget _buildFeatureCard(int index) {
    final features = [
      {
        'emoji': '💧',
        'title': 'Traditional Purity',
        'description':
            'Every attar is **100% alcohol-free**, adhering to authentic, sacred preparation methods for a cleaner, richer oil base.',
      },
      {
        'emoji': '⏳',
        'title': 'Exceptional Longevity',
        'description':
            'Concentrated oils mean your signature scent lasts all day, evolving gracefully from morning to night.',
      },
      {
        'emoji': '🔊',
        'title': 'Intimate Projection',
        'description':
            'High-grade ingredients ensure a compelling projection that draws others in without overwhelming the space.',
      },
    ];

    final feature = features[index];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface.withOpacity(0.5),
        border: Border.all(
          color: QiratTheme.goldBorder,
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
          // Emoji Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: QiratTheme.qiratGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                feature['emoji'] as String,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            feature['title'] as String,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: QiratTheme.darkOnBackground,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            feature['description'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
