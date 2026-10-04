import 'package:flutter/material.dart';

import '../../core/bootstrap/app_services.dart';
import '../../core/product/product_info.dart';
import '../../core/profile/profile_models.dart';
import '../g01_focus/g01_screen.dart';
import '../g02_inhibition/g02_screen.dart';
import '../g03_memory/g03_screen.dart';
import '../g04_flexibility/g04_screen.dart';
import '../g05_regulation/g05_screen.dart';
import '../g06_social/g06_screen.dart';
import '../parent/parent_access_screen.dart';
import '../settings/accessibility_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.services, super.key});

  final AppServices services;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChildProfile> _profiles = const [];
  String? _activeProfileId;
  int? _completedSessions;
  bool _loading = true;

  ChildProfile? get _activeProfile {
    for (final profile in _profiles) {
      if (profile.profileId == _activeProfileId) return profile;
    }
    return _profiles.isEmpty ? null : _profiles.first;
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _activeProfileId ??= await widget.services.repository.ensureDefaultProfile();
    await _refresh();
  }

  Future<void> _refresh() async {
    final profiles = await widget.services.repository.listProfiles();
    if (profiles.isNotEmpty && !profiles.any((p) => p.profileId == _activeProfileId)) {
      _activeProfileId = profiles.first.profileId;
    }
    final count = _activeProfileId == null
        ? 0
        : await widget.services.repository.completedSessionCount(profileId: _activeProfileId);
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _completedSessions = count;
      _loading = false;
    });
  }

  Future<void> _openGame(Widget Function(String profileId) builder) async {
    final id = _activeProfileId;
    if (id == null) return;
    await Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => builder(id)));
    await _refresh();
  }

  Future<void> _openParentArea() async {
    final id = _activeProfileId;
    if (id == null) return;
    final selected = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => ParentAccessScreen(services: widget.services, initialProfileId: id),
      ),
    );
    if (selected != null) _activeProfileId = selected;
    await _refresh();
  }

  Future<void> _openAccessibility() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => AccessibilityScreen(services: widget.services)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final profile = _activeProfile?.displayLabel ?? 'Explorador';
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF596BDD), Color(0xFF7A5CD6)]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NeuroCore', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
                            Text('Missões para treinar habilidades do dia a dia', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Conforto e acessibilidade',
                        onPressed: _openAccessibility,
                        icon: const Icon(Icons.accessibility_new_rounded),
                      ),
                      const SizedBox(width: 6),
                      IconButton.filledTonal(
                        tooltip: 'Área dos responsáveis',
                        onPressed: _openParentArea,
                        icon: const Icon(Icons.family_restroom_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8ECFF), Color(0xFFF4EAFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.rocket_launch_rounded, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Olá, $profile!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              const Text('Escolha uma missão. Cada uma treina uma habilidade diferente.', style: TextStyle(height: 1.35)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SkillChip('Atenção', Icons.visibility_rounded),
                      _SkillChip('Memória', Icons.psychology_alt_rounded),
                      _SkillChip('Autocontrole', Icons.pan_tool_alt_rounded),
                      _SkillChip('Flexibilidade', Icons.swap_horiz_rounded),
                      _SkillChip('Calma', Icons.spa_rounded),
                      _SkillChip('Convivência', Icons.groups_rounded),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text('Escolha uma missão', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(
                    'As missões se adaptam ao desempenho. Não é prova e não há punição por errar.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _MissionCard(
                    accent: const Color(0xFF4F67D8),
                    soft: const Color(0xFFEAF0FF),
                    icon: Icons.center_focus_strong_rounded,
                    code: 'G01',
                    title: 'Missão Foco',
                    skill: 'Atenção seletiva',
                    childText: 'Encontre o alvo certo entre símbolos parecidos.',
                    onTap: () => _openGame((id) => G01FocusScreen(services: widget.services, profileId: id)),
                  ),
                  _MissionCard(
                    accent: const Color(0xFF2F8B50),
                    soft: const Color(0xFFE9F8EE),
                    icon: Icons.traffic_rounded,
                    code: 'G02',
                    title: 'Pare, Pense, Vá!',
                    skill: 'Controle inibitório',
                    childText: 'VÁ: toque. PARE: espere. Observe antes de agir.',
                    onTap: () => _openGame((id) => G02InhibitionScreen(services: widget.services, profileId: id)),
                  ),
                  _MissionCard(
                    accent: const Color(0xFFD38A21),
                    soft: const Color(0xFFFFF4DD),
                    icon: Icons.extension_rounded,
                    code: 'G03',
                    title: 'Memória Mágica',
                    skill: 'Memória de trabalho',
                    childText: 'Veja uma sequência e reconstrua a ordem.',
                    onTap: () => _openGame((id) => G03MemoryScreen(services: widget.services, profileId: id)),
                  ),
                  _MissionCard(
                    accent: const Color(0xFF7B52B9),
                    soft: const Color(0xFFF2EAFE),
                    icon: Icons.change_circle_outlined,
                    code: 'G04',
                    title: 'Troca-Troca',
                    skill: 'Flexibilidade cognitiva',
                    childText: 'A regra muda: às vezes vale a COR, às vezes a FORMA.',
                    onTap: () => _openGame((id) => G04FlexibilityScreen(services: widget.services, profileId: id)),
                  ),
                  _MissionCard(
                    accent: const Color(0xFF27856E),
                    soft: const Color(0xFFE8F7F2),
                    icon: Icons.landscape_rounded,
                    code: 'G05',
                    title: 'Montanha da Calma',
                    skill: 'Estratégias de autorregulação',
                    childText: 'Pratique respiração, corpo, sentidos e próximos passos.',
                    onTap: () => _openGame((id) => G05RegulationScreen(services: widget.services, profileId: id)),
                  ),
                  _MissionCard(
                    accent: const Color(0xFFD46F35),
                    soft: const Color(0xFFFFF0E6),
                    icon: Icons.diversity_1_rounded,
                    code: 'G06',
                    title: 'Mundo dos Amigos',
                    skill: 'Alternativas sociais',
                    childText: 'Conheça histórias e descubra diferentes respostas respeitosas.',
                    onTap: () => _openGame((id) => G06SocialScreen(services: widget.services, profileId: id)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_completedSessions ?? 0} sessões concluídas • dados locais • área dos responsáveis protegida',
                            style: const TextStyle(fontSize: 13, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '${NeuroCoreProductInfo.appName} ${NeuroCoreProductInfo.versionLabel} • recomendado para ${NeuroCoreProductInfo.recommendedAge}. Ferramenta neuroeducacional, não diagnóstica e não terapêutica.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, height: 1.4),
                  ),
                  const SizedBox(height: 28),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip(this.label, this.icon);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 17),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.accent,
    required this.soft,
    required this.icon,
    required this.code,
    required this.title,
    required this.skill,
    required this.childText,
    required this.onTap,
  });

  final Color accent;
  final Color soft;
  final IconData icon;
  final String code;
  final String title;
  final String skill;
  final String childText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: soft,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(18)),
                  child: Icon(icon, color: Colors.white, size: 31),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$code • $title', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(skill, style: TextStyle(fontWeight: FontWeight.w800, color: accent)),
                      const SizedBox(height: 5),
                      Text(childText, style: const TextStyle(fontSize: 13.5, height: 1.35)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(minimumSize: const Size(54, 46), padding: const EdgeInsets.symmetric(horizontal: 12)),
                  child: const Icon(Icons.play_arrow_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
