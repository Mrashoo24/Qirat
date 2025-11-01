import 'package:flutter/material.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';

/// Signature Scent Advisor Modal Widget
class QiratScentAdvisorModal extends StatefulWidget {
  final VoidCallback? onClose;
  final Function(String)? onRecommendation;

  const QiratScentAdvisorModal({
    Key? key,
    this.onClose,
    this.onRecommendation,
  }) : super(key: key);

  @override
  State<QiratScentAdvisorModal> createState() => _QiratScentAdvisorModalState();
}

class _QiratScentAdvisorModalState extends State<QiratScentAdvisorModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _showRecommendation = false;
  bool _showError = false;
  String _recommendedAttar = '';
  String _justification = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.responsive(
              context: context,
              mobile: MediaQuery.of(context).size.width * 0.9,
              tablet: 600,
              desktop: 700,
            ),
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: QiratTheme.darkBackground,
              border: Border.all(
                color: QiratTheme.goldBorder,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: ResponsiveHelper.responsive(
                  context: context,
                  mobile: const EdgeInsets.all(24),
                  tablet: const EdgeInsets.all(32),
                  desktop: const EdgeInsets.all(40),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildContent(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Signature Scent Advisor ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: QiratTheme.qiratGold,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: '✨',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: widget.onClose,
          icon: const Icon(
            Icons.close,
            color: QiratTheme.textSecondary,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_showRecommendation) ...[
          _buildInputSection(),
        ] else ...[
          _buildRecommendationSection(),
        ],
        if (_isLoading) ...[
          const SizedBox(height: 24),
          _buildLoadingIndicator(),
        ],
        if (_showError) ...[
          const SizedBox(height: 24),
          _buildErrorBox(),
        ],
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Describe the mood, occasion, or feeling you want your attar to capture:',
          style: TextStyle(
            fontSize: 16,
            color: QiratTheme.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText:
                "E.g., 'A confident scent for a first date,' or 'Calm and earthy for a quiet evening at home.'",
            hintStyle: TextStyle(color: QiratTheme.textMuted),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _controller.text.trim().isEmpty
                ? null
                : _generateRecommendation,
            child: const Text('Get My Recommendation'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Perfect Attar:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: QiratTheme.darkOnBackground,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: QiratTheme.darkSurface,
            border: Border.all(
              color: QiratTheme.goldBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _recommendedAttar,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: QiratTheme.qiratGold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _justification,
                style: const TextStyle(
                  fontSize: 14,
                  color: QiratTheme.darkOnBackground,
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => widget.onRecommendation?.call(_recommendedAttar),
            child: Text('Secure Your Attar Now ($_recommendedAttar)'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _showRecommendation = false;
                _controller.clear();
              });
            },
            child: const Text('Try Again'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(QiratTheme.qiratGold),
          ),
          SizedBox(height: 16),
          Text(
            'Searching our archives for your signature scent...',
            style: TextStyle(
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QiratTheme.errorColor.withOpacity(0.1),
        border: Border.all(
          color: QiratTheme.errorColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'An error occurred. Please try again with a more detailed description.',
        style: TextStyle(
          color: Colors.redAccent,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  void _generateRecommendation() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showError = false;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock recommendation logic - In real implementation, this would call your Gemini API
      final recommendations = _getMockRecommendations();
      final selectedRecommendation = recommendations[
          query.toLowerCase().hashCode % recommendations.length];

      setState(() {
        _isLoading = false;
        _showRecommendation = true;
        _recommendedAttar = selectedRecommendation['name']!;
        _justification = selectedRecommendation['justification']!;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showError = true;
      });
    }
  }

  List<Map<String, String>> _getMockRecommendations() {
    return [
      {
        'name': 'Mawj',
        'justification':
            'Mawj\'s aquatic freshness and energetic projection make it perfect for building confidence. Its sea salt and mint notes provide an invigorating aura that thrives in dynamic environments.',
      },
      {
        'name': 'Sahar',
        'justification':
            'Sahar\'s gentle floral composition with white musk creates a serene, uplifting presence. Its soft, powdery notes are ideal for calm, intimate moments and daily grace.',
      },
      {
        'name': 'Moss Aura',
        'justification':
            'Moss Aura\'s earthy vetiver and oakmoss blend offers grounding stability and focus. Perfect for those seeking a connection to nature and centered mindfulness.',
      },
      {
        'name': 'Honey Lush',
        'justification':
            'Honey Lush combines warm honey nectar with vanilla for ultimate comfort and intimacy. Its cozy luxury makes it perfect for romantic and inviting atmospheres.',
      },
      {
        'name': 'Oud Majestic',
        'justification':
            'Oud Majestic delivers commanding presence with its medium oud and cardamom blend. Ideal for making powerful statements and exuding confident authority.',
      },
      {
        'name': 'Rubaie Rose',
        'justification':
            'Rubaie Rose\'s classic Indian rose with saffron embodies timeless elegance and sophistication. Perfect for traditional occasions and enduring romantic expressions.',
      },
    ];
  }
}
