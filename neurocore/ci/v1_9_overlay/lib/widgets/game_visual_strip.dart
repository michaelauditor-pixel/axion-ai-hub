import 'package:flutter/material.dart';

enum GameVisualKind { focus, inhibition, memory, flexibility, regulation, social }

class GameVisualStrip extends StatelessWidget {
  const GameVisualStrip({required this.kind, this.height = 116, super.key});
  final GameVisualKind kind;
  final double height;
  List<IconData> get _icons => switch (kind) {
    GameVisualKind.focus => const [Icons.star_rounded, Icons.circle, Icons.change_history_rounded],
    GameVisualKind.inhibition => const [Icons.play_arrow_rounded, Icons.pan_tool_alt_rounded, Icons.timer_outlined],
    GameVisualKind.memory => const [Icons.favorite_rounded, Icons.auto_awesome_rounded, Icons.hexagon_rounded],
    GameVisualKind.flexibility => const [Icons.palette_rounded, Icons.category_rounded, Icons.swap_horiz_rounded],
    GameVisualKind.regulation => const [Icons.air_rounded, Icons.spa_rounded, Icons.landscape_rounded],
    GameVisualKind.social => const [Icons.sentiment_satisfied_alt_rounded, Icons.forum_rounded, Icons.diversity_1_rounded],
  };
  List<Color> get _colors => switch (kind) {
    GameVisualKind.focus => const [Color(0xFF5571DE), Color(0xFF7DA6F5), Color(0xFFE39B55)],
    GameVisualKind.inhibition => const [Color(0xFF3A9B61), Color(0xFFD85858), Color(0xFF5B72D9)],
    GameVisualKind.memory => const [Color(0xFFE27892), Color(0xFF8A66C9), Color(0xFFE2A23A)],
    GameVisualKind.flexibility => const [Color(0xFF7652B7), Color(0xFF4F8CC9), Color(0xFFE28E45)],
    GameVisualKind.regulation => const [Color(0xFF55A48A), Color(0xFF77B98F), Color(0xFF6B8D75)],
    GameVisualKind.social => const [Color(0xFFE78C58), Color(0xFF5C93C8), Color(0xFF8D6AC0)],
  };
  @override Widget build(BuildContext context) {
    final icons = _icons, colors = _colors;
    return SizedBox(height: height, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) {
      final size = i == 1 ? height * .78 : height * .62;
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Container(width: size, height: size, decoration: BoxDecoration(color: colors[i].withValues(alpha: .14), borderRadius: BorderRadius.circular(size * .30), border: Border.all(color: colors[i].withValues(alpha: .25), width: 2)), child: Icon(icons[i], size: size * .50, color: colors[i])));
    })));
  }
}
