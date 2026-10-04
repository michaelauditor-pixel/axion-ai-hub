import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurocore_app/features/g01_focus/difficulty_config.dart';
import 'package:neurocore_app/features/g01_focus/stimulus.dart';
import 'package:neurocore_app/features/g02_inhibition/inhibition_difficulty_config.dart';
import 'package:neurocore_app/features/g02_inhibition/inhibition_trial.dart';
import 'package:neurocore_app/features/g05_regulation/regulation_difficulty_config.dart';
import 'package:neurocore_app/features/g06_social/social_scenario.dart';

void main() {
  test('G02 always includes PARE and caps consecutive VA across blocks', () {
    final generator = InhibitionTrialGenerator(random: Random(42));
    for (var level = 1; level <= 5; level++) {
      var trailing = 0;
      for (var block = 0; block < 1000; block++) {
        final trials = generator.generateBlock(InhibitionDifficultyConfig.forLevel(level), 10, initialGoRun: trailing);
        expect(trials.where((t) => !t.isGo).length, greaterThanOrEqualTo(2));
        var run = trailing;
        for (final trial in trials) { run = trial.isGo ? run + 1 : 0; expect(run, lessThanOrEqualTo(3)); }
        trailing = InhibitionTrialGenerator.trailingGoRun(trials);
      }
    }
  });
  test('G01 mixes target presence within every block', () {
    final generator = FocusTrialGenerator(random: Random(7));
    for (var level = 1; level <= 5; level++) {
      for (var i = 0; i < 300; i++) {
        final schedule = generator.generatePresenceSchedule(DifficultyConfig.forLevel(level), 10);
        expect(schedule.where((v) => v).length, greaterThanOrEqualTo(2));
        expect(schedule.where((v) => !v).length, greaterThanOrEqualTo(2));
      }
    }
  });
  test('G06 has at least six unique stories and preferred choice stays visible', () {
    expect(SocialScenario.examples.length, greaterThanOrEqualTo(6));
    expect(SocialScenario.examples.map((e) => e.story).toSet().length, SocialScenario.examples.length);
    final random = Random(11);
    for (final scenario in SocialScenario.examples) {
      for (var count = 2; count <= 3; count++) {
        for (var position = 0; position < count; position++) {
          final p = scenario.present(random: random, choiceCount: count, preferredPosition: position);
          expect(p.preferredIndex, position);
          expect(p.choices[position], scenario.choices[scenario.preferredIndex]);
        }
      }
    }
  });
  test('G05 has real positive response windows for omission measurement', () {
    for (var level = 1; level <= 5; level++) expect(RegulationDifficultyConfig.forLevel(level).responseWindowMs, greaterThan(0));
  });
}
