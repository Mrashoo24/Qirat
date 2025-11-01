import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Heritage Section Widget - Qirat's brand story and values
class QiratHeritageSectionWidget extends StatelessWidget {
  const QiratHeritageSectionWidget({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              // Subtitle
              Text(
                'The Heritage of Qirat',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: QiratTheme.textMuted,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Main Headline
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsive(
                      context: context,
                      mobile: 32,
                      tablet: 42,
                      desktop: 48,
                    ),
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                    height: 1.2,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Distilled for the ',
                      style: TextStyle(color: QiratTheme.darkOnBackground),
                    ),
                    TextSpan(
                      text: 'Modern Indian Connoisseur.',
                      style: TextStyle(color: QiratTheme.qiratGold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Description
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Text(
                  'We are not just a fragrance; we are a statement. Qirat revives the timeless art of **attar-making**, merging traditional oil purity with scent engineering that meets the demands of contemporary life. This is luxury defined by **discretion, longevity, and purity.**',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsive(
                      context: context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: QiratTheme.darkOnBackground,
                    fontFamily: 'Inter',
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Crown Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: QiratTheme.goldBorder,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '👑',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
