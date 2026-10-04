class SocialPerformanceSnapshot {
  const SocialPerformanceSnapshot({
    required this.trials,
    required this.contextMatches,
    required this.supportiveChoices,
    required this.omissions,
    required this.reactionTimesMs,
  });

  final int trials;
  final int contextMatches;
  final int supportiveChoices;
  final int omissions;
  final List<int> reactionTimesMs;

  double get contextMatchRate => trials <= 0 ? 0 : contextMatches / trials;
  double get supportiveChoiceRate => trials <= 0 ? 0 : supportiveChoices / trials;
  double get mismatchRate => trials <= 0
      ? 0
      : (trials - supportiveChoices - omissions).clamp(0, trials) / trials;
  double get omissionRate => trials <= 0 ? 0 : omissions / trials;

  double get reactionTimeCv {
    if (reactionTimesMs.length < 2) return 0;
    final mean = reactionTimesMs.reduce((a, b) => a + b) / reactionTimesMs.length;
    if (mean <= 0) return 0;
    var sum = 0.0;
    for (final value in reactionTimesMs) {
      final d = value - mean;
      sum += d * d;
    }
    final x = sum / reactionTimesMs.length;
    if (x <= 0) return 0;
    var r = x;
    for (var i = 0; i < 10; i++) {
      r = 0.5 * (r + x / r);
    }
    return r / mean;
  }

  int? get medianReactionTimeMs {
    if (reactionTimesMs.isEmpty) return null;
    final v = [...reactionTimesMs]..sort();
    final m = v.length ~/ 2;
    return v.length.isOdd ? v[m] : ((v[m - 1] + v[m]) / 2).round();
  }

  Map<String, Object?> toJson() => {
    'trials': trials,
    'context_match_rate': contextMatchRate,
    'supportive_choice_rate': supportiveChoiceRate,
    'non_supportive_choice_rate': mismatchRate,
    'mismatch_rate': mismatchRate,
    'omission_rate': omissionRate,
    'reaction_time_cv': reactionTimeCv,
    'median_reaction_time_ms': medianReactionTimeMs,
  };
}
