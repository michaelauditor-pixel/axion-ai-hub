import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/adaptive/adaptive_engine.dart';
import '../../core/adaptive/regulation_adaptive_engine.dart';
import '../../core/adaptive/regulation_performance_snapshot.dart';
import '../../core/bootstrap/app_services.dart';
import '../../widgets/game_visual_strip.dart';
import 'regulation_difficulty_config.dart';

class G05RegulationScreen extends StatefulWidget {
  const G05RegulationScreen({required this.services, required this.profileId, super.key});

  final AppServices services;
  final String profileId;

  @override
  State<G05RegulationScreen> createState() => _G05RegulationScreenState();
}

class _G05RegulationScreenState extends State<G05RegulationScreen> {
  static const _gameId = 'G05_montanha_calma';
  static const _strategies = <_RegulationStrategy>[
    _RegulationStrategy(
      label: 'Respirar devagar',
      icon: Icons.air_rounded,
      guidance: 'Puxe o ar pelo nariz… e solte bem devagar.',
    ),
    _RegulationStrategy(
      label: 'Relaxar o corpo',
      icon: Icons.accessibility_new_rounded,
      guidance: 'Solte os ombros, abra as mãos e deixe o corpo menos tenso.',
    ),
    _RegulationStrategy(
      label: 'Olhar 3 coisas',
      icon: Icons.visibility_rounded,
      guidance: 'Encontre três coisas ao seu redor. Observe cor, forma e tamanho.',
    ),
    _RegulationStrategy(
      label: 'Ouvir 2 sons',
      icon: Icons.hearing_rounded,
      guidance: 'Fique quietinho por um instante e perceba dois sons diferentes.',
    ),
    _RegulationStrategy(
      label: 'Frase gentil',
      icon: Icons.favorite_rounded,
      guidance: 'Diga para você: “Posso tentar de novo com calma.”',
    ),
    _RegulationStrategy(
      label: 'Próximo passo',
      icon: Icons.route_rounded,
      guidance: 'Pense em uma coisa pequena que você pode fazer agora.',
    ),
  ];

  final _engine = const RegulationAdaptiveEngine();
  AdaptiveState _state = AdaptiveState.initial();
  String? _sessionId;
  Timer? _roundTimer;
  int _round = 0;
  int _completed = 0;
  int _premature = 0;
  int _omissions = 0;
  final List<int> _times = [];
  DateTime? _started;
  bool _done = false;
  bool _busy = false;
  bool _closing = false;
  _RegulationStrategy? _activeExercise;
  int _secondsLeft = 0;
  String _feedback = 'Escolha uma ferramenta para praticar.';

  @override
  void dispose() {
    _roundTimer?.cancel();
    if (_sessionId != null && !_done && !_closing) _abandonSilently();
    super.dispose();
  }

  List<_RegulationStrategy> _visibleStrategies(RegulationDifficultyConfig config) {
    final start = (_round - 1).clamp(0, 1000) % _strategies.length;
    final rotated = <_RegulationStrategy>[
      for (var i = 0; i < _strategies.length; i += 1) _strategies[(start + i) % _strategies.length],
    ];
    return rotated.take(config.choiceCount).toList();
  }

  Future<void> _start() async {
    if (_sessionId != null) return;
    _sessionId = await widget.services.repository.startSession(profileId: widget.profileId, gameId: _gameId);
    await _record('session_started', {
      'game_id': _gameId,
      'mode': 'guided_self_regulation_practice_non_diagnostic',
      'strategy_pool': _strategies.length,
      'rounds_planned': 6,
    });
    await widget.services.feedback.start();
    if (!mounted) return;
    setState(() {
      _round = 1;
      _started = DateTime.now();
      _feedback = 'Escolha uma ferramenta para praticar.';
    });
    _armRoundTimer();
  }

  void _armRoundTimer() {
    _roundTimer?.cancel();
    final config = RegulationDifficultyConfig.forLevel(_state.level);
    _roundTimer = Timer(Duration(milliseconds: config.responseWindowMs), _handleOmission);
  }

  Future<void> _choose(_RegulationStrategy strategy) async {
    if (_busy || _done || _sessionId == null) return;
    _busy = true;
    _roundTimer?.cancel();
    final elapsed = DateTime.now().difference(_started ?? DateTime.now()).inMilliseconds;
    final config = RegulationDifficultyConfig.forLevel(_state.level);
    if (elapsed < 500) _premature++;
    _completed++;
    _times.add(elapsed);
    await _record('regulation_strategy_selected', {
      'round': _round,
      'strategy': strategy.label,
      'selection_time_ms': elapsed,
      'difficulty': _state.level,
    });
    await widget.services.feedback.correct();

    final seconds = (config.pacingSeconds + 2).clamp(5, 7).toInt();
    if (!mounted) return;
    setState(() {
      _activeExercise = strategy;
      _secondsLeft = seconds;
      _feedback = strategy.guidance;
    });

    for (var remaining = seconds; remaining > 0; remaining -= 1) {
      if (!mounted || _done) return;
      setState(() => _secondsLeft = remaining);
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    await _record('regulation_guided_practice_completed', {
      'round': _round,
      'strategy': strategy.label,
      'guided_seconds': seconds,
    });
    if (!mounted) return;
    setState(() {
      _activeExercise = null;
      _secondsLeft = 0;
      _feedback = 'Muito bem. Você praticou uma ferramenta de autorregulação.';
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    _busy = false;
    await _advance();
  }

  Future<void> _handleOmission() async {
    if (_busy || _done || _sessionId == null) return;
    _busy = true;
    _omissions++;
    await _record('regulation_prompt_omitted', {'round': _round, 'difficulty': _state.level});
    await widget.services.feedback.gentleMiss();
    if (mounted) setState(() => _feedback = 'Tudo bem. Vamos seguir para outra ferramenta.');
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _busy = false;
    await _advance();
  }

  Future<void> _advance() async {
    _roundTimer?.cancel();
    if (_round >= 6) {
      await _finish();
      return;
    }
    if (_round % 2 == 0) {
      final snapshot = RegulationPerformanceSnapshot(
        prompts: _round,
        completedStrategies: _completed,
        prematureActions: _premature,
        omissions: _omissions,
        completionTimesMs: _times,
      );
      final decision = _engine.evaluate(state: _state, performance: snapshot);
      _state = decision.nextState;
      await _record('difficulty_reviewed', {
        'round': _round,
        'difficulty_after': _state.level,
        'reason': decision.reasonCode,
      });
    }
    if (!mounted) return;
    setState(() {
      _round++;
      _started = DateTime.now();
      _feedback = 'Escolha outra ferramenta e experimente.';
    });
    _armRoundTimer();
  }

  Future<void> _finish() async {
    _roundTimer?.cancel();
    final snapshot = RegulationPerformanceSnapshot(
      prompts: 6,
      completedStrategies: _completed,
      prematureActions: _premature,
      omissions: _omissions,
      completionTimesMs: _times,
    );
    final summary = <String, Object?>{
      'game_id': _gameId,
      'blocks_completed': 3,
      'final_difficulty': _state.level,
      'performance': snapshot.toJson(),
      'note': 'guided_practice_metric_not_emotion_diagnosis',
    };
    final features = widget.services.neuroProfile.buildCompletedG05(
      profileId: widget.profileId,
      sessionId: _sessionId!,
      summary: summary,
    );
    await widget.services.repository.finalizeCompletedSession(
      sessionId: _sessionId!,
      summary: summary,
      features: features,
    );
    _done = true;
    await widget.services.feedback.complete();
    if (mounted) setState(() {});
  }

  Future<void> _record(String type, Map<String, Object?> payload) async {
    final id = _sessionId;
    if (id == null) return;
    await widget.services.telemetry.record(sessionId: id, eventType: type, payload: payload);
  }

  Future<void> _abandonSilently() async {
    _closing = true;
    _roundTimer?.cancel();
    final id = _sessionId;
    if (id == null) return;
    try {
      await widget.services.telemetry.record(sessionId: id, eventType: 'session_abandoned', payload: {'round': _round});
      await widget.services.repository.abandonSession(sessionId: id);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final config = RegulationDifficultyConfig.forLevel(_state.level);
    return Scaffold(
      appBar: AppBar(title: const Text('Montanha da Calma')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _done
              ? _Done(onBack: () => Navigator.of(context).pop())
              : _sessionId == null
                  ? _Intro(onStart: _start)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LinearProgressIndicator(value: _round / 6, minHeight: 9),
                        const SizedBox(height: 12),
                        Text('Parada $_round de 6', style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 14),
                        const GameVisualStrip(kind: GameVisualKind.regulation, height: 92),
                        const SizedBox(height: 14),
                        if (_activeExercise != null)
                          Expanded(
                            child: _GuidedExercise(strategy: _activeExercise!, secondsLeft: _secondsLeft),
                          )
                        else ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF8F2),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Text(_feedback, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(height: 16),
                          ..._visibleStrategies(config).map(
                            (strategy) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: FilledButton.tonalIcon(
                                onPressed: _busy ? null : () => _choose(strategy),
                                icon: Icon(strategy.icon),
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(strategy.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Aqui você pratica ferramentas. Não existe “emoção certa” e o jogo não detecta crises ou diagnósticos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11.5, height: 1.35),
                          ),
                        ],
                      ],
                    ),
        ),
      ),
    );
  }
}

class _RegulationStrategy {
  const _RegulationStrategy({required this.label, required this.icon, required this.guidance});
  final String label;
  final IconData icon;
  final String guidance;
}

class _Intro extends StatelessWidget {
  const _Intro({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const GameVisualStrip(kind: GameVisualKind.regulation, height: 126),
        const SizedBox(height: 18),
        const Text('Montanha da Calma', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text(
          'Em cada parada você escolhe uma ferramenta e pratica de verdade por alguns segundos. Respiração, corpo, sentidos, frases gentis e próximos passos fazem parte da trilha.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.45),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.hiking_rounded), label: const Text('Começar a subida')),
      ],
    );
  }
}

class _GuidedExercise extends StatelessWidget {
  const _GuidedExercise({required this.strategy, required this.secondsLeft});
  final _RegulationStrategy strategy;
  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFDDF5EC), Color(0xFFEAF0FF)]),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(strategy.icon, size: 64),
            const SizedBox(height: 16),
            Text(strategy.label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(strategy.guidance, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, height: 1.45)),
            const SizedBox(height: 22),
            CircleAvatar(radius: 34, child: Text('$secondsLeft', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900))),
          ],
        ),
      ),
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.emoji_nature_rounded, size: 76),
        const SizedBox(height: 16),
        const Text('Montanha concluída!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text('Você praticou diferentes ferramentas de autorregulação.', textAlign: TextAlign.center),
        const SizedBox(height: 22),
        FilledButton(onPressed: onBack, child: const Text('Voltar às missões')),
      ],
    ),
  );
}
