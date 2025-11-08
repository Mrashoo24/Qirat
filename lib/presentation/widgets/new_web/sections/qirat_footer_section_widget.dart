import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Footer Section Widget - Final CTA and footer links
class QiratFooterSectionWidget extends StatelessWidget {
  final VoidCallback? onShopCollectionTap;
  final Function(String)? onLinkTap;

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.ak.qiratshop';
  static const String _appStoreUrl =
      'https://apps.apple.com/us/app/qirat-attars-and-perfumes/id6736781517'; // placeholder

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
                onPressed: onShopCollectionTap ??
                    () => _defaultShopCollection(context),
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
                return _buildMobileFooterLinks(context);
              } else {
                return _buildDesktopFooterLinks(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopFooterLinks(BuildContext context) {
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
          child: _buildLinkColumn(
              'Quick Links',
              [
                'Signature Scent Advisor',
                'Returns & Exchange',
                'FAQ',
              ],
              context),
        ),

        // Connect Column
        Expanded(
          child: _buildLinkColumn(
              'Connect',
              [
                'Instagram',
                'WhatsApp',
                'care@qiratshop.in',
              ],
              context),
        ),

        // Legal Column
        Expanded(
          child: _buildLinkColumn(
              'Legal',
              [
                'Privacy Policy',
                'Terms of Service',
              ],
              context),
        ),

        // Get the App Column
        Expanded(
          child: _buildLinkColumn(
              'Get the App',
              [
                'Android (Play Store)',
                'iOS (App Store)',
              ],
              context),
        ),
      ],
    );
  }

  Widget _buildMobileFooterLinks(BuildContext context) {
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
              child: _buildLinkColumn(
                  'Quick Links',
                  [
                    'Signature Scent Advisor',
                    'Returns & Exchange',
                    'FAQ',
                  ],
                  context),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _buildLinkColumn(
                  'Connect',
                  [
                    'Instagram',
                    'WhatsApp',
                    'care@qiratshop.in',
                  ],
                  context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildLinkColumn(
            'Legal',
            [
              'Privacy Policy',
              'Terms of Service',
            ],
            context),

        const SizedBox(height: 24),
        _buildLinkColumn(
            'Get the App',
            [
              'Android (Play Store)',
              'iOS (App Store)',
            ],
            context),
      ],
    );
  }

  Widget _buildLinkColumn(
      String title, List<String> links, BuildContext context) {
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
                onTap: () => _handleLinkTap(context, link),
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

  void _defaultShopCollection(BuildContext context) {
    // Navigate to Products as a sensible default
    context.push(NewWebRouter.newProducts);
  }

  void _handleLinkTap(BuildContext context, String link) {
    // Allow parent callback first (analytics, overrides)
    onLinkTap?.call(link);

    switch (link) {
      case 'Privacy Policy':
        context.push(NewWebRouter.newPrivacyPolicy);
        break;
      case 'Terms of Service':
        context.push(NewWebRouter.newTerms);
        break;
      case 'Signature Scent Advisor':
        // Route to search as an entry point; dedicated advisor modal lives on landing
        context.push(NewWebRouter.newSearch);
        break;
      case 'Returns & Exchange':
      case 'FAQ':
        // Temporary mapping to Terms until dedicated pages exist
        context.push(NewWebRouter.newTerms);
        break;
      case 'Instagram':
        _openInstagram();
        break;
      case 'WhatsApp':
        _openWhatsApp('9137029393');
        break;
      case 'info@qirat.in':
        _openEmail('info@qirat.in');
        break;
      case 'Android (Play Store)':
        _openPlayStore();
        break;
      case 'iOS (App Store)':
        _openAppStore();
        break;
      default:
        // External items like Instagram/WhatsApp/email can be handled by parent via onLinkTap
        break;
    }
  }

  // External link helpers
  Future<void> _openInstagram() async {
    final uri = Uri.parse('https://www.instagram.com/qirat_attar');
    await _launchExternal(uri);
  }

  Future<void> _openWhatsApp(String rawNumber) async {
    // Assume India if no country code provided
    final phone = _formatPhone(rawNumber);
    final uri = Uri.parse('https://wa.me/$phone');
    await _launchExternal(uri);
  }

  Future<void> _openEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Support',
      }),
    );
    await _launchExternal(uri);
  }

  Future<void> _openPlayStore() async {
    final uri = Uri.parse(_playStoreUrl);
    await _launchExternal(uri);
  }

  Future<void> _openAppStore() async {
    final uri = Uri.parse(_appStoreUrl);
    await _launchExternal(uri);
  }

  String _formatPhone(String raw) {
    var n = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (n.startsWith('+')) return n.substring(1);
    if (n.length == 10) return '91$n';
    return n; // Already includes country code digits
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _launchExternal(Uri uri) async {
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Fallback to in-app browser if external fails
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      // Silently ignore launcher errors
    }
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
