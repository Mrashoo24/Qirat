import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebOurStoryView extends StatefulWidget {
  const NewWebOurStoryView({Key? key}) : super(key: key);

  @override
  State<NewWebOurStoryView> createState() => _NewWebOurStoryViewState();
}

class _NewWebOurStoryViewState extends State<NewWebOurStoryView> {
  // Removed scroll-triggered animations; sections are always visible

  @override
  Widget build(BuildContext context) {
    final pad = ResponsiveHelper.getResponsivePadding(context);
    final maxW = ResponsiveHelper.getContentMaxWidth(context);

    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(
                padding: EdgeInsets.fromLTRB(pad.left, 40, pad.right, 80),
                child: Column(
                  children: [
                    // Legal banner
                    _LegalNameBanner(),
                    // Hero
                    _ParallaxHero(
                      title: "👑 Our Story: The Philosophy of Purity and Power",
                      subtitle:
                          "The Qirat Commitment: Restoring Timeless Elegance",
                    ),

                    const SizedBox(height: 32),

                    // Section 1
                    _SectionCard(
                      heading: "The Qirat Commitment",
                      highlight: "Restoring Timeless Elegance",
                      body:
                          "At Qirat Attars & Perfumes, our mission is rooted in a fundamental belief: that true luxury in fragrance must be enduring, pure, and profound. Qirat, which speaks to elegance and perfection, is the guiding principle of our craft.\n\nIn a modern world saturated with quick, fleeting scents, our team is dedicated to restoring the authentic soul of fragrance through the Attar—an ancient oil-based essence known for its depth and longevity. We operate not as a mere business, but as custodians of a superior tradition. We offer you a signature that doesn't shout but projects—a silent, powerful statement of uncompromising quality.",
                    ),
                    const SizedBox(height: 24),

                    // Section 2 (image + copy)
                    _MediaCard(
                      title:
                          "The Craftsmanship: Time, Temperature, and Terroir",
                      body:
                          "We do not believe in shortcuts. Our process is a deliberate rejection of mass-market methods.\n\nEvery attar we release is the culmination of meticulous effort and patience:\n\n• Sourcing Excellence: Our blenders travel across regions to secure the finest Sandalwood Oil, Rose Absolutes, and rare natural musks. We never compromise on the origin or grade of our raw materials.\n\n• 100% Alcohol-Free: This is our foundational promise. Unlike alcohol-based perfumes that evaporate quickly, our pure oil essences are designed to meld with your skin's natural warmth, creating a personalized, rich, and evolving aura that is gentle on the skin.\n\n• Concentration over Volume: The deep, concentrated nature of our attars guarantees performance. Our scents don't just last; they intensify and gain character as the day progresses, a crucial advantage in the dynamic Indian climate.",
                      imageAlt: "assets/other_images/qirat_persons.png",
                    ),
                    const SizedBox(height: 24),

                    // Section 3
                    _SectionCard(
                      heading: "The Qirat Promise",
                      highlight: "A Scent That Becomes Your Signature",
                      body:
                          "When you choose Qirat, you are choosing a fragrance with intent. You are choosing a scent that performs as beautifully in the evening as it does in the morning.\n\nOur team ensures that every single bottle delivers:\n\n• Exceptional Projection: The power to create an elegant presence that precedes you—never overwhelming, always memorable.\n\n• Unrivaled Longevity: A guarantee that your fragrance will remain a constant, confident ally for 8 to 12 hours, requiring only the smallest application.\n\n• A Personal Evolution: The complex, layered formulas of attar mean the scent unfolds over time, offering a rich experience far beyond the initial notes.\n\nWe invite you to experience the difference a dedication to purity and power makes.",
                    ),
                    const SizedBox(height: 32),

                    // CTA
                    _CtaCard(
                      onShop: () => context.push(NewWebRouter.newProducts),
                      onAdvisor: () => context.push(NewWebRouter.newSearch),
                    ),
                    const SizedBox(height: 40),
                    // Contact Us / Legal Section
                    const _ContactUsSection(),

                    const SizedBox(height: 32),

                    // Download App Section
                    const _DownloadAppSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ParallaxHero extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ParallaxHero({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const y = 0.0; // static hero background
    return Container(
      height: 280,
      decoration: BoxDecoration(
        border: Border.all(color: QiratTheme.goldBorder),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            QiratTheme.darkSurface.withOpacity(0.9),
            QiratTheme.darkSurfaceVariant.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            top: y,
            child: Opacity(
              opacity: 0.25,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/other_images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: QiratTheme.qiratGold,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String heading;
  final String highlight;
  final String body;
  const _SectionCard({
    Key? key,
    required this.heading,
    required this.highlight,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(color: QiratTheme.goldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: const TextStyle(
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18)),
          const SizedBox(height: 6),
          Text(highlight,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  final String title;
  final String body;
  final String imageAlt;
  const _MediaCard({
    Key? key,
    required this.title,
    required this.body,
    required this.imageAlt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Container(
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(color: QiratTheme.goldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: isWide
          ? Row(
              children: [
                Expanded(child: _imageBox(imageAlt)),
                const SizedBox(width: 16),
                Expanded(child: _textBlock(title, body)),
              ],
            )
          : Column(
              children: [
                _imageBox(imageAlt),
                const SizedBox(height: 12),
                _textBlock(title, body),
              ],
            ),
    );
  }

  Widget _imageBox(String alt) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: QiratTheme.goldBorder),
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [QiratTheme.darkSurfaceVariant, QiratTheme.darkSurface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            alt,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _textBlock(String t, String b) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t,
              style: const TextStyle(
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18)),
          const SizedBox(height: 10),
          Text(
            b,
            style: const TextStyle(
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaCard extends StatelessWidget {
  final VoidCallback onShop;
  final VoidCallback onAdvisor;
  const _CtaCard({Key? key, required this.onShop, required this.onAdvisor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(color: QiratTheme.qiratGold),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        children: [
          const Text(
            "Ready to Define Your Elegance?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Explore Our Collection: Discover the depth of Mawj, the elegance of Rubaie Rose, and our full range of signature scents.\n\nFind Your Perfect Match: Use our Signature Scent Advisor to receive a personalized recommendation from our AI Scent Specialist.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: onShop, child: const Text("Explore Collection")),
              OutlinedButton(
                onPressed: onAdvisor,
                child: const Text("Signature Scent Advisor"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Big App Download Promotion Section
class _DownloadAppSection extends StatelessWidget {
  const _DownloadAppSection();

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.ak.qiratshop';
  static const String _appStoreUrl =
      'https://apps.apple.com/us/app/qirat-attars-and-perfumes/id6736781517'; // placeholder

  Future<void> _openUrl(String url) async {
    try {
        final uri = Uri.parse(url);
        await _launchExternal(uri);

    } catch (_) {}
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

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: QiratTheme.darkSurfaceVariant,
        border: Border.all(color: QiratTheme.qiratGold, width: 1.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: QiratTheme.qiratGold.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 40, 24, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Experience QIRAT On The Go',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 24 : 32,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Download our mobile app for faster checkout, personalized scent recommendations, order tracking and exclusive early access drops.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: QiratTheme.textSecondary,
                fontFamily: 'Inter',
                height: 1.5,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 28,
            runSpacing: 24,
            children: [
              _StoreBadge(
                imagePath: 'assets/icons/googeplay.png',
                label: 'Get it on Google Play',
                onTap: () => _openUrl(_playStoreUrl),
              ),
              _StoreBadge(
                imagePath: 'assets/icons/appstore.png',
                label: 'Download on the App Store',
                onTap: () => _openUrl(_appStoreUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreBadge extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  const _StoreBadge({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final width = isMobile ? 180.0 : 220.0;
    final heeight = isMobile ? 50.0 : 90.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width,
        height: heeight,
        decoration: BoxDecoration(
          color: QiratTheme.darkSurface,
          border: Border.all(color: QiratTheme.goldBorder),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child:    ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

// Banner highlighting legal relationship
class _LegalNameBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurfaceVariant,
        border: Border.all(color: QiratTheme.qiratGold, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'QIRAT is a brand of Qirat Enterprises',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Legal Entity: Qirat Enterprises',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Contact Us section including legal name for compliance
class _ContactUsSection extends StatelessWidget {
  const _ContactUsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(color: QiratTheme.goldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Legal Name: Qirat Enterprises\n\nIf you have any inquiries, partnership interests, or require support related to your purchases, you can reach us through the channels below. We are committed to responding promptly and professionally.',
            style: TextStyle(
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            runSpacing: 12,
            spacing: 28,
            children: const [
              _ContactLine(
                label: 'Email',
                value: 'care@qiratshop.in',
              ),
              _ContactLine(
                label: 'Phone',
                value: '+91 9137029393',
              ),
              _ContactLine(
                label: 'Website',
                value: 'qiratshop.in',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  final String label;
  final String value;
  const _ContactLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
