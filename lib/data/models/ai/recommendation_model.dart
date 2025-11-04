import '../../../domain/entities/ai/recommendation.dart';

class RecommendationModel extends Recommendation {
  const RecommendationModel({
    required super.attarName,
    required super.justification,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      attarName: (json['attarName'] ?? json['name'] ?? '').toString(),
      justification: (json['justification'] ?? json['reason'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'attarName': attarName,
        'justification': justification,
      };
}
