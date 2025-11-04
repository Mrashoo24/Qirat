import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../../core/error/exceptions.dart';
import '../../../core/services/gemini_client.dart';
import '../../models/ai/recommendation_model.dart';
import '../../../domain/entities/product/product.dart';

abstract class AiRemoteDataSource {
  Future<RecommendationModel> recommendAttar(
      String prompt, List<Product> catalog);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final GeminiClient client;
  AiRemoteDataSourceImpl(this.client);

  static const Map<String, dynamic> _jsonSchema = {
    'type': 'OBJECT',
    'properties': {
      'attarName': {
        'type': 'STRING',
        'description':
            'The name of the suggested Qirat Attar from the provided live product list.'
      },
      'justification': {
        'type': 'STRING',
        'description': "3-4 sentence explanation in Qirat's brand tone."
      }
    },
    'propertyOrdering': ['attarName', 'justification']
  };

  String _systemPrompt(String dynamicProductData) =>
      'You are the Chief Scent Advisor for Qirat Attars, a premium, luxury, alcohol-free fragrance house. '
      'Recommend ONE specific attar from the product list that best matches the user need. '
      'Always return JSON with keys "attarName" and "justification". Adhere strictly to the list. '
      'Be specific and authoritative.\n$dynamicProductData';

  String _buildProductData(List<Product> products) {
    if (products.isEmpty) return 'Product List: (empty)';
    final lines = <String>['Product List:'];
    for (final p in products) {
      final tags = (p.tags.isNotEmpty) ? p.tags.join(', ') : 'No tags';
      final categories = (p.categories.isNotEmpty)
          ? p.categories.map((c) => c.toString()).join(', ')
          : 'Uncategorized';
      final hasPrice = p.priceTags.isNotEmpty;
      final minPrice = hasPrice
          ? p.priceTags.map((e) => e.price).reduce((a, b) => a < b ? a : b)
          : null;
      final priceStr = hasPrice ? 'From ₹$minPrice' : 'Price N/A';
      // Treat presence of priceTags as "in stock"
      final stock = hasPrice ? 'In Stock' : 'Out of Stock';
      lines.add(
          '- ${p.name}: $priceStr • $stock • Tags: $tags • Categories: $categories.');
    }
    return lines.join('\n');
  }

  @override
  Future<RecommendationModel> recommendAttar(
      String prompt, List<Product> catalog) async {
    if (!client.isConfigured) throw ServerException();

    const maxRetries = 5;
    var delay = const Duration(milliseconds: 900);
    Exception? lastError;

    final productData = _buildProductData(
      catalog.where((p) => p.priceTags.isNotEmpty).toList(), // in-stock only
    );
    final sysPrompt = _systemPrompt(productData);

    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final result = await client.generateContent(
          userPrompt: prompt,
          systemPrompt: sysPrompt,
          responseSchema: _jsonSchema,
        );

        final candidates = result['candidates'] as List<dynamic>? ?? const [];
        final content =
            candidates.isNotEmpty ? candidates.first['content'] : null;
        final parts = content != null
            ? (content['parts'] as List<dynamic>? ?? const [])
            : const [];
        final text =
            parts.isNotEmpty ? (parts.first['text'] as String? ?? '') : '';

        if (text.isEmpty) throw const FormatException('Empty Gemini response');

        final map = _tryParseJson(text);
        final model = RecommendationModel.fromJson(map);

        if (model.attarName.isEmpty || model.justification.isEmpty) {
          throw const FormatException('Invalid JSON fields');
        }
        return model;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        await Future.delayed(
            delay + Duration(milliseconds: Random().nextInt(400)));
        delay *= 2;
      }
    }

    throw lastError ?? ServerException();
  }

  Map<String, dynamic> _tryParseJson(String raw) {
    try {
      final parsed = jsonDecode(raw);
      if (parsed is Map<String, dynamic>) return parsed;
      throw const FormatException('Not a JSON map');
    } catch (_) {
      final start = raw.indexOf('{');
      final end = raw.lastIndexOf('}');
      if (start >= 0 && end > start) {
        final slice = raw.substring(start, end + 1);
        final parsed = jsonDecode(slice);
        if (parsed is Map<String, dynamic>) return parsed;
      }
      rethrow;
    }
  }
}
