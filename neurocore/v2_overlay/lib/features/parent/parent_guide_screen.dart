import 'package:flutter/material.dart';

import '../../core/product/product_info.dart';

class ParentGuideScreen extends StatelessWidget {
  const ParentGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guia para responsáveis')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: const [
          _GuideHero(),
          SizedBox(height: 18),
          _InfoSection(
            icon: Icons.child_care_rounded,
            title: 'Para quem é',
            body:
                'Faixa principal recomendada: ${NeuroCoreProductInfo.recommendedAge}. O aplicativo foi desenhado para crianças que se beneficiam de missões curtas, instruções simples, pausas e dificuldade adaptativa.',
          ),
          _InfoSection(
            icon: Icons.health_and_safety_outlined,
            title: 'O que o NeuroCore é — e o que não é',
            body:
                '${NeuroCoreProductInfo.positioning}\n\n${NeuroCoreProductInfo.clinicalBoundary}',
          ),
          SizedBox(height: 8),
          _GameGuide(
            code: 'G01',
            title: 'Missão Foco',
            skill: 'Atenção seletiva e consistência de resposta',
            howItWorks:
                'A criança procura um alvo visual específico entre símbolos distratores. Em algumas tentativas o alvo pode não aparecer, exigindo observar antes de agir.',
            parentNote:
                'Observe se a criança passa a conferir melhor antes de tocar e se mantém o desempenho ao longo da sessão. O resultado descreve apenas o comportamento dentro desta tarefa.',
          ),
          _GameGuide(
            code: 'G02',
            title: 'Pare, Pense, Vá!',
            skill: 'Controle inibitório e resposta a regras',
            howItWorks:
                'A criança toca quando aparece VÁ e precisa esperar quando aparece PARE. Os blocos são balanceados para que PARE apareça de forma obrigatória e não existam longas sequências de VÁ.',
            parentNote:
                'O jogo pratica interromper uma resposta automática. Não deve ser interpretado como medida clínica de impulsividade fora do aplicativo.',
          ),
          _GameGuide(
            code: 'G03',
            title: 'Memória Mágica',
            skill: 'Memória de trabalho',
            howItWorks:
                'Uma sequência de símbolos é apresentada por poucos instantes. Depois, a criança reconstrói a ordem. O comprimento e o ritmo mudam conforme o desempenho.',
            parentNote:
                'A progressão de span e a exatidão ajudam a acompanhar a tarefa ao longo do tempo, mas não equivalem a um teste neuropsicológico padronizado.',
          ),
          _GameGuide(
            code: 'G04',
            title: 'Troca-Troca',
            skill: 'Flexibilidade cognitiva',
            howItWorks:
                'A criança classifica um símbolo pela COR ou pela FORMA. Durante a missão a regra muda e ela precisa perceber a mudança e ajustar a resposta.',
            parentNote:
                'O indicador representa adaptação a mudanças de regra dentro do jogo e não mede, sozinho, flexibilidade no cotidiano.',
          ),
          _GameGuide(
            code: 'G05',
            title: 'Montanha da Calma',
            skill: 'Repertório de autorregulação',
            howItWorks:
                'A criança escolhe uma estratégia e é guiada por um pequeno exercício: respirar devagar, relaxar o corpo, observar os sentidos, usar uma frase gentil ou planejar o próximo passo.',
            parentNote:
                'O objetivo é ampliar repertório de estratégias. O app não identifica crises, agressividade, ansiedade ou emoções e não substitui intervenção profissional.',
          ),
          _GameGuide(
            code: 'G06',
            title: 'Mundo dos Amigos',
            skill: 'Leitura de contexto e alternativas sociais',
            howItWorks:
                'A criança lê histórias curtas e escolhe entre diferentes respostas. Mais de uma alternativa pode ser respeitosa; o jogo evita tratar uma única forma social como obrigatória.',
            parentNote:
                'A proposta é ampliar possibilidades de resposta, não treinar mascaramento, normalização comportamental ou obediência automática.',
          ),
          _InfoSection(
            icon: Icons.insights_outlined,
            title: 'Como interpretar os resultados',
            body:
                'Resultados devem ser comparados dentro do mesmo jogo e ao longo de sessões repetidas. Evite transformar desempenho em uma missão em “diagnóstico”, “QI”, “grau de TDAH” ou “percentual global de melhora”. Uma tendência só é útil quando há repetição suficiente no mesmo domínio.',
          ),
          _InfoSection(
            icon: Icons.public_rounded,
            title: 'Mercado e idiomas',
            body:
                'A versão atual é em ${NeuroCoreProductInfo.currentLanguage}. O produto pode ser publicado fora do Brasil após localização de textos, metadados, política de privacidade e conteúdo cultural. Inglês e espanhol são as primeiras expansões recomendadas. ${NeuroCoreProductInfo.internationalSummary}',
          ),
          _InfoSection(
            icon: Icons.badge_outlined,
            title: 'Desenvolvimento e responsabilidade',
            body: NeuroCoreProductInfo.developerSummary,
          ),
        ],
      ),
    );
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.family_restroom_rounded, size: 36),
          SizedBox(height: 14),
          Text(
            'Entenda o que cada missão realmente pratica',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            'Informações claras para acompanhar a criança sem transformar métricas de jogo em diagnóstico.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Text(body, style: const TextStyle(height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameGuide extends StatelessWidget {
  const _GameGuide({
    required this.code,
    required this.title,
    required this.skill,
    required this.howItWorks,
    required this.parentNote,
  });

  final String code;
  final String title;
  final String skill;
  final String howItWorks;
  final String parentNote;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(code, style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900))),
              ],
            ),
            const SizedBox(height: 12),
            Text('Pratica: $skill', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(howItWorks, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 10),
            Text('Para os pais: $parentNote', style: TextStyle(height: 1.45, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
