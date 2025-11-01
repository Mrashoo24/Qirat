import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Footer Section Widget - Final CTA and footer links
class QiratFooterSectionWidget extends StatelessWidget {
  final VoidCallback? onShopCollectionTap;
  final Function(String)? onLinkTap;

  const QiratFooterSectionWidget({
    Key? key,
    this.onShopCollectionTap,
    this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: QiratTheme.darkSurfaceVariant,
      child: Column(
        children: [
          // CTA Section
          _buildCTASection(context),

          // Footer Links
          _buildFooterLinks(context),

          // Copyright
          _buildCopyright(context),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            children: [
              Text(
                'Ready to Define Your Aura?',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: QiratTheme.darkOnBackground,
                      fontWeight: FontWeight.w800,
                      fontSize: ResponsiveHelper.responsive(
                        context: context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 36,
                      ),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onShopCollectionTap,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.responsive(
                      context: context,
                      mobile: 32,
                      tablet: 40,
                      desktop: 48,
                    ),
                    vertical: ResponsiveHelper.responsive(
                      context: context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  textStyle: TextStyle(
                    fontSize: ResponsiveHelper.responsive(
                      context: context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Shop The Full Qirat Collection'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: QiratTheme.borderDark,
            width: 1,
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getContentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: ResponsiveBuilder(
            builder: (context, isMobile, isTablet, isDesktop) {
              if (isMobile) {
                return _buildMobileFooterLinks();
              } else {
                return _buildDesktopFooterLinks();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopFooterLinks() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Qirat Attars',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Luxury. Purity. Projection.',
                style: TextStyle(
                  fontSize: 14,
                  color: QiratTheme.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),

        // Quick Links Column
        Expanded(
          child: _buildLinkColumn('Quick Links', [
            'Signature Scent Advisor',
            'Returns & Exchange',
            'FAQ',
          ]),
        ),

        // Connect Column
        Expanded(
          child: _buildLinkColumn('Connect', [
            'Instagram',
            'WhatsApp',
            'info@qirat.in',
          ]),
        ),

        // Legal Column
        Expanded(
          child: _buildLinkColumn('Legal', [
            'Privacy Policy',
            'Terms of Service',
          ]),
        ),
      ],
    );
  }

  Widget _buildMobileFooterLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        const Text(
          'Qirat Attars',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: QiratTheme.qiratGold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Luxury. Purity. Projection.',
          style: TextStyle(
            fontSize: 14,
            color: QiratTheme.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 32),

        // Links Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildLinkColumn('Quick Links', [
                'Signature Scent Advisor',
                'Returns & Exchange',
                'FAQ',
              ]),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _buildLinkColumn('Connect', [
                'Instagram',
                'WhatsApp',
                'info@qirat.in',
              ]),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildLinkColumn('Legal', [
          'Privacy Policy',
          'Terms of Service',
        ]),
      ],
    );
  }

  Widget _buildLinkColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: QiratTheme.darkOnBackground,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => onLinkTap?.call(link),
                child: Text(
                  link,
                  style: const TextStyle(
                    fontSize: 14,
                    color: QiratTheme.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildCopyright(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Center(
        child: Text(
          '© 2025 Qirat Attars. All rights reserved.',
          style: const TextStyle(
            fontSize: 12,
            color: QiratTheme.textMuted,
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
