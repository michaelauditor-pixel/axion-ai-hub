import 'adaptive_engine.dart';
import 'social_performance_snapshot.dart';

class SocialAdaptiveEngine {
  const SocialAdaptiveEngine();

  AdaptiveDecision evaluate({
    required AdaptiveState state,
    required SocialPerformanceSnapshot performance,
  }) {
    final strain =
        performance.supportiveChoiceRate < 0.60 || performance.omissionRate > 0.25;
    if (strain) {
      final streak = state.strainStreak + 1;
      return AdaptiveDecision(
        nextState: AdaptiveState(
          level: state.level > 1 ? state.level - 1 : 1,
          highPerformanceStreak: 0,
          strainStreak: streak,
        ),
        reasonCode: 'social_scaffolding_increased',
        microPause: streak >= 2,
      );
    }

    final mastery = performance.supportiveChoiceRate >= 0.85;
    if (mastery) {
      final streak = state.highPerformanceStreak + 1;
      final increase = streak >= 2 && state.level < 5;
      return AdaptiveDecision(
        nextState: AdaptiveState(
          level: increase ? state.level + 1 : state.level,
          highPerformanceStreak: increase ? 0 : streak,
          strainStreak: 0,
        ),
        reasonCode: increase ? 'social_progression' : 'social_mastery_observed',
        microPause: false,
      );
    }

    return AdaptiveDecision(
      nextState: AdaptiveState(
        level: state.level,
        highPerformanceStreak: 0,
        strainStreak: 0,
      ),
      reasonCode: 'social_maintain',
      microPause: false,
    );
  }
}
