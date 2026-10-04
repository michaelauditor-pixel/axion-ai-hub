import '../../ml/feature_contract.dart';
import 'profile_models.dart';

/// Consolida somente tendências comparáveis dentro do mesmo jogo.
/// Um indicador é liberado após pelo menos 3 sessões concluídas daquele domínio.
class NeuroProfileAggregator {
  const NeuroProfileAggregator();

  static const int minimumSessionsPerDomain = 3;

  NeuroProfileView aggregate({
    required String profileId,
    required List<SessionFeatureVectorV1> features,
  }) {
    if (features.isEmpty) {
      return _empty(profileId);
    }

    final ordered = [...features]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));

    double? indicatorFor(String gameId) {
      final domain = ordered.where((f) => f.gameId == gameId).toList();
      if (domain.length < minimumSessionsPerDomain) return null;
      double? value;
      for (final feature in domain) {
        value = _ewma(value, _accuracyScore(feature));
      }
      return value == null ? null : _clamp100(value);
    }

    final attention = indicatorFor('G01_missao_foco');
    final inhibition = indicatorFor('G02_pare_pense_va');
    final memory = indicatorFor('G03_memoria_magica');
    final flexibility = indicatorFor('G04_troca_troca');
    final regulation = indicatorFor('G05_montanha_calma');
    final social = indicatorFor('G06_mundo_amigos');

    final difficultySum = ordered.fold<double>(0, (sum, f) => sum + f.finalDifficulty);

    return NeuroProfileView(
      profileId: profileId,
      sessionCount: ordered.length,
      sustainedAttentionIndicator: attention,
      inhibitoryControlIndicator: inhibition,
      workingMemoryIndicator: memory,
      cognitiveFlexibilityIndicator: flexibility,
      selfRegulationPracticeIndicator: regulation,
      socialEmotionalLearningIndicator: social,
      responseConsistencyIndicator: null,
      overallGameplayIndicator: null,
      averageDifficulty: difficultySum / ordered.length,
      trend: 'domain_only',
      updatedAt: ordered.last.completedAt,
    );
  }

  NeuroProfileView _empty(String profileId) => NeuroProfileView(
    profileId: profileId,
    sessionCount: 0,
    sustainedAttentionIndicator: null,
    inhibitoryControlIndicator: null,
    workingMemoryIndicator: null,
    cognitiveFlexibilityIndicator: null,
    selfRegulationPracticeIndicator: null,
    socialEmotionalLearningIndicator: null,
    responseConsistencyIndicator: null,
    overallGameplayIndicator: null,
    averageDifficulty: null,
    trend: 'insufficient_data',
    updatedAt: null,
  );

  double _accuracyScore(SessionFeatureVectorV1 f) {
    final hit = f.hitRate.clamp(0.0, 1.0);
    final errors = f.commissionRate.clamp(0.0, 1.0);
    final omissions = f.omissionRate.clamp(0.0, 1.0);
    return ((hit * 0.70) + ((1 - errors) * 0.20) + ((1 - omissions) * 0.10)) * 100;
  }

  double _ewma(double? previous, double current) {
    const alpha = 0.35;
    return previous == null ? current : (alpha * current) + ((1 - alpha) * previous);
  }

  double _clamp100(double value) => value.clamp(0.0, 100.0).toDouble();
}
