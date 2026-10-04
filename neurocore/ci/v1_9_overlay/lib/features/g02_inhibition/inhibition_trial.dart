import 'dart:math';
import 'inhibition_difficulty_config.dart';

enum InhibitionCue { go, noGo }
class InhibitionTrial {
  const InhibitionTrial({required this.cue});
  final InhibitionCue cue;
  bool get isGo => cue == InhibitionCue.go;
  Map<String, Object?> toJson() => {'cue': isGo ? 'go' : 'no_go'};
}
class InhibitionTrialGenerator {
  InhibitionTrialGenerator({Random? random}) : _random = random ?? Random.secure();
  final Random _random;
  List<InhibitionTrial> generateBlock(InhibitionDifficultyConfig config, int trialCount, {int initialGoRun = 0, int maxConsecutiveGo = 3}) {
    if (trialCount < 3) throw ArgumentError.value(trialCount, 'trialCount', 'must be >= 3');
    if (initialGoRun < 0 || initialGoRun > maxConsecutiveGo) throw ArgumentError.value(initialGoRun, 'initialGoRun', 'out of range');
    var noGoCount = ((1 - config.goProbability) * trialCount).round().clamp(trialCount >= 8 ? 2 : 1, trialCount - 1).toInt();
    while (noGoCount < trialCount - 1) {
      final goCount = trialCount - noGoCount;
      final capacity = max(0, maxConsecutiveGo - initialGoRun) + noGoCount * maxConsecutiveGo;
      if (goCount <= capacity) break;
      noGoCount += 1;
    }
    final goCount = trialCount - noGoCount;
    final cues = <InhibitionCue>[...List<InhibitionCue>.filled(goCount, InhibitionCue.go), ...List<InhibitionCue>.filled(noGoCount, InhibitionCue.noGo)];
    for (var attempt = 0; attempt < 600; attempt += 1) {
      cues.shuffle(_random);
      if (_valid(cues, initialGoRun, maxConsecutiveGo)) return cues.map((cue) => InhibitionTrial(cue: cue)).toList(growable: false);
    }
    final result = <InhibitionCue>[]; var remainingGo = goCount, remainingNoGo = noGoCount, run = initialGoRun;
    while (remainingGo + remainingNoGo > 0) {
      final mustStop = run >= maxConsecutiveGo;
      final canStop = remainingNoGo > 0;
      final shouldStop = mustStop || (canStop && remainingGo > 0 && _random.nextDouble() < remainingNoGo / (remainingGo + remainingNoGo));
      if (shouldStop && canStop) { result.add(InhibitionCue.noGo); remainingNoGo--; run = 0; }
      else if (remainingGo > 0 && run < maxConsecutiveGo) { result.add(InhibitionCue.go); remainingGo--; run++; }
      else if (canStop) { result.add(InhibitionCue.noGo); remainingNoGo--; run = 0; }
      else { throw StateError('Unable to construct balanced inhibition block'); }
    }
    if (!_valid(result, initialGoRun, maxConsecutiveGo)) throw StateError('Generated inhibition block violates run constraint');
    return result.map((cue) => InhibitionTrial(cue: cue)).toList(growable: false);
  }
  bool _valid(List<InhibitionCue> cues, int initialGoRun, int maxConsecutiveGo) {
    var run = initialGoRun;
    for (final cue in cues) { if (cue == InhibitionCue.go) { run++; if (run > maxConsecutiveGo) return false; } else { run = 0; } }
    return true;
  }
  static int trailingGoRun(List<InhibitionTrial> trials) { var run = 0; for (final trial in trials.reversed) { if (!trial.isGo) break; run++; } return run; }
}
