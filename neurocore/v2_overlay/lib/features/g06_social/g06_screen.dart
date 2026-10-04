import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_engine.dart';
import '../../core/adaptive/social_adaptive_engine.dart';
import '../../core/adaptive/social_performance_snapshot.dart';
import '../../core/bootstrap/app_services.dart';
import '../../widgets/game_visual_strip.dart';
import 'social_scenario.dart';

class G06SocialScreen extends StatefulWidget {
  const G06SocialScreen({required this.services, required this.profileId, super.key});

  final AppServices services;
  final String profileId;

  @override
  State<G06SocialScreen> createState() => _G06SocialScreenState();
}

class _G06SocialScreenState extends State<G06SocialScreen> {
  static const _gameId = 'G06_mundo_amigos';
  static const _trialsPerSession = 6;

  final _engine = const SocialAdaptiveEngine();
  final Random _random = Random.secure();
  AdaptiveState _state = AdaptiveState.initial();
  String? _sessionId;
  Timer? _responseTimer;
  List<SocialScenario> _scenarioOrder = const [];
  PresentedSocialScenario? _presented;
  int _index = 0;
  int _preferredPositionOffset = 0;
  int _matches = 0;
  int _supportive = 0;
  int _omissions = 0;
  final List<int> _times = [];
  DateTime? _started;
  bool _done = false;
  bool _resolved = false;
  bool _closing = false;
  String _feedback = 'Escolha uma resposta que respeite as pessoas da história.';

  @override
  void dispose() {
    _responseTimer?.cancel();
    if (_sessionId != null && !_done && !_closing) _abandonSilently();
    super.dispose();
  }

  int get _responseWindowMs => const [18000, 16500, 15000, 13500, 12000][_state.level.clamp(1, 5).toInt() - 1];

  Future<void> _start() async {
    if (_sessionId != null) return;
    _sessionId = await widget.services.repository.startSession(profileId: widget.profileId, gameId: _gameId);
    _scenarioOrder = List<SocialScenario>.of(SocialScenario.examples)..shuffle(_random);
    _preferredPositionOffset = _random.nextInt(3);
    await _record('session_started', {
      'game_id': _gameId,
      'mode': 'social_learning_non_diagnostic_non_masking',
      'scenario_pool': SocialScenario.examples.length,
      'trials_planned': _trialsPerSession,
      'multiple_supportive_answers': true,
      'choice_order_randomized': true,
    });
    await widget.services.feedback.start();
    if (!mounted) return;
    setState(() {});
    _prepareTrial();
  }

  void _prepareTrial() {
    _responseTimer?.cancel();
    final scenario = _scenarioOrder[_index];
    final count = _state.level <= 2 ? 2 : 3;
    _presented = scenario.present(
      random: _random,
      choiceCount: count,
      preferredPosition: (_index + _preferredPositionOffset) % count,
    );
    _resolved = false;
    _started = DateTime.now();
    _responseTimer = Timer(Duration(milliseconds: _responseWindowMs), _handleOmission);
  }

  Future<void> _choose(int choice) async {
    final p = _presented;
    if (p == null || _resolved || _done) return;
    _resolved = true;
    _responseTimer?.cancel();
    final elapsed = DateTime.now().difference(_started ?? DateTime.now()).inMilliseconds;
    final matched = choice == p.preferredIndex;
    final supportive = p.isSupportive(choice);
    if (matched) _matches++;
    if (supportive) {
      _supportive++;
      await widget.services.feedback.correct();
    } else {
      await widget.services.feedback.gentleMiss();
    }
    _times.add(elapsed);
    await _record('social_choice', {
      'trial': _index + 1,
      'choice_display_index': choice,
      'choice_text': p.choices[choice],
      'preferred_display_index': p.preferredIndex,
      'context_match': matched,
      'supportive_choice': supportive,
      'reaction_time_ms': elapsed,
    });
    if (!mounted) return;
    setState(() {
      if (matched) {
        _feedback = 'Boa leitura do contexto. Essa é uma opção respeitosa.';
      } else if (supportive) {
        _feedback = 'Boa escolha. Existem diferentes maneiras respeitosas de responder.';
      } else {
        _feedback = 'Vamos pensar em uma resposta que preserve o respeito e o espaço de todos.';
      }
    });
    await Future<void>.delayed(const Duration(milliseconds: 950));
    await _next();
  }

  Future<void> _handleOmission() async {
    if (_resolved || _done || _presented == null) return;
    _resolved = true;
    _omissions++;
    await _record('social_choice_omitted', {'trial': _index + 1, 'response_window_ms': _responseWindowMs});
    await widget.services.feedback.gentleMiss();
    if (mounted) setState(() => _feedback = 'Tudo bem. Vamos conhecer outra situação.');
    await Future<void>.delayed(const Duration(milliseconds: 700));
    await _next();
  }

  Future<void> _next() async {
    _responseTimer?.cancel();
    final completed = _index + 1;
    if (completed >= _trialsPerSession) {
      await _finish();
      return;
    }
    if (completed % 2 == 0) {
      final perf = SocialPerformanceSnapshot(
        trials: completed,
        contextMatches: _matches,
        supportiveChoices: _supportive,
        omissions: _omissions,
        reactionTimesMs: _times,
      );
      final decision = _engine.evaluate(state: _state, performance: perf);
      _state = decision.nextState;
      await _record('difficulty_reviewed', {
        'trial': completed,
        'difficulty_after': _state.level,
        'reason': decision.reasonCode,
      });
    }
    if (!mounted) return;
    setState(() {
      _index++;
      _feedback = 'Leia a situação e escolha com calma.';
    });
    _prepareTrial();
    if (mounted) setState(() {});
  }

  Future<void> _finish() async {
    _responseTimer?.cancel();
    final perf = SocialPerformanceSnapshot(
      trials: _trialsPerSession,
      contextMatches: _matches,
      supportiveChoices: _supportive,
      omissions: _omissions,
      reactionTimesMs: _times,
    );
    final summary = <String, Object?>{
      'game_id': _gameId,
      'blocks_completed': 3,
      'final_difficulty': _state.level,
      'performance': perf.toJson(),
      'note': 'social_learning_multiple_supportive_responses_non_masking',
    };
    final features = widget.services.neuroProfile.buildCompletedG06(
      profileId: widget.profileId,
      sessionId: _sessionId!,
      summary: summary,
    );
    await widget.services.repository.finalizeCompletedSession(sessionId: _sessionId!, summary: summary, features: features);
    _done = true;
    await widget.services.feedback.complete();
    if (mounted) setState(() {});
  }

  Future<void> _record(String type, Map<String, Object?> payload) async {
    final id = _sessionId;
    if (id != null) await widget.services.telemetry.record(sessionId: id, eventType: type, payload: payload);
  }

  Future<void> _abandonSilently() async {
    _closing = true;
    _responseTimer?.cancel();
    final id = _sessionId;
    if (id == null) return;
    try {
      await widget.services.telemetry.record(sessionId: id, eventType: 'session_abandoned', payload: {'trial': _index + 1});
      await widget.services.repository.abandonSession(sessionId: id);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mundo dos Amigos')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.diversity_1_rounded, size: 78),
                const SizedBox(height: 16),
                const Text('Missão concluída!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text('Você conheceu diferentes maneiras de responder com respeito.', textAlign: TextAlign.center),
                const SizedBox(height: 22),
                FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Voltar às missões')),
              ],
            ),
          ),
        ),
      );
    }

    if (_sessionId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mundo dos Amigos')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const GameVisualStrip(kind: GameVisualKind.social, height: 130),
              const SizedBox(height: 18),
              const Text('Histórias para pensar em possibilidades', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text(
                'Leia cada situação e escolha uma resposta. Às vezes mais de uma opção pode ser respeitosa. O objetivo não é obrigar uma única forma de agir.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.45),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(onPressed: _start, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Começar histórias')),
            ],
          ),
        ),
      );
    }

    final p = _presented;
    return Scaffold(
      appBar: AppBar(title: const Text('Mundo dos Amigos')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            LinearProgressIndicator(value: (_index + 1) / _trialsPerSession, minHeight: 9),
            const SizedBox(height: 10),
            Text('História ${_index + 1} de $_trialsPerSession', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const GameVisualStrip(kind: GameVisualKind.social, height: 88),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: const Color(0xFFFFF2E8), borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Text(p?.story ?? 'Preparando história…', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.35)),
                  const SizedBox(height: 10),
                  Text(_feedback, textAlign: TextAlign.center, style: const TextStyle(height: 1.35)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (p != null)
              ...p.choices.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FilledButton.tonal(
                    onPressed: _resolved ? null : () => _choose(entry.key),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Text(entry.value, textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'Não existe meta de mascaramento ou “comportamento normal”. A missão trabalha contexto, respeito, limites e alternativas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
