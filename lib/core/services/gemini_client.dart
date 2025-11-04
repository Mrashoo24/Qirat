import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiClient {
  final String apiKey;
  final String model;

  GeminiClient({
    String? apiKey,
    this.model = 'gemini-2.5-flash',
  }) : apiKey = apiKey ?? const String.fromEnvironment('GEMINI_API_KEY');

  bool get isConfigured => apiKey.isNotEmpty;

  Future<Map<String, dynamic>> generateContent({
    required String userPrompt,
    required String systemPrompt,
    Map<String, dynamic>? responseSchema,
  }) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
    );

    // Using generationConfig to request JSON output with schema
    final payload = <String, dynamic>{
      'contents': [
        {
          'parts': [
            {'text': userPrompt}
          ]
        }
      ],
      'system_instruction': {
        'parts': [
          {'text': systemPrompt}
        ]
      },
      'generationConfig': {
        'response_mime_type': 'application/json',
        if (responseSchema != null) 'response_schema': responseSchema,
        'temperature': 0.3,
      },
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (resp.statusCode != 200) {
      throw Exception('Gemini API error: ${resp.statusCode} ${resp.body}');
    }
    return json.decode(resp.body) as Map<String, dynamic>;
  }
}
