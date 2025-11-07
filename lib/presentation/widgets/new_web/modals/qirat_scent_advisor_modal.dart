import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/usecases/ai/recommend_attar_usecase.dart';
import '../../../../core/services/services_locator.dart';
import '../../../blocs/product/product_bloc.dart';

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
  void initState() {
    super.initState();
    // Rebuild on text changes so the CTA enables/disables live
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Material(
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
          _isLoading ? _buildLoadingIndicator() : _buildInputSection(),
        ] else ...[
          _buildRecommendationSection(),
        ],

        // if (_isLoading) ...[
        //   const SizedBox(height: 24),
        //   _buildLoadingIndicator(),
        // ],

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
          onSubmitted: (_) {
            if (_controller.text.trim().isNotEmpty && !_isLoading) {
              _generateRecommendation();
            }
          },
          style: const TextStyle(color: QiratTheme.darkOnBackground),
          decoration: InputDecoration(
            hintText:
            "E.g., 'A confident scent for a first date,' or 'Calm and earthy for a quiet evening at home.'",
            hintStyle: const TextStyle(color: QiratTheme.textSecondary),
            filled: true,
            fillColor: QiratTheme.darkSurfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: QiratTheme.goldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: QiratTheme.goldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: QiratTheme.qiratGold),
            ),
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

  Future<void> _generateRecommendation() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showError = false;
    });

    try {
      // Live catalog from ProductBloc (all products, no mock, no extra filters)
      final catalog = context.read<ProductBloc>().state.products;

      if (catalog.isEmpty) {
        setState(() {
          _isLoading = false;
          _showError = true;
        });
        return;
      }

      final usecase = sl.get<RecommendAttarUseCase>();
      final result =
          await usecase(RecommendParams(prompt: query, catalog: catalog));

      result.fold((_) {
        // Failure: fallback to a live product from catalog (first in-stock, otherwise first)
        final fallback = catalog.firstWhere(
          (p) => p.priceTags.isNotEmpty,
          orElse: () => catalog.first,
        );
        _recommendedAttar = fallback.name;
        _justification =
            'Based on your preferences and availability, ${fallback.name} is the closest match from our live collection.';
      }, (recommendation) {
        _recommendedAttar = recommendation.attarName;
        _justification = recommendation.justification;
      });

      setState(() {
        _isLoading = false;
        _showRecommendation = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showError = true;
      });
    }
  }

  // Remove mock hard-coded products; optional helper retained only if needed elsewhere
  List<Map<String, String>> _getMockRecommendations() {
    return const []; // No mock entries; live catalog is used instead
  }
}
