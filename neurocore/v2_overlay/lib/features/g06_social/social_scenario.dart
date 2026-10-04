import 'dart:math';

class PresentedSocialScenario {
  const PresentedSocialScenario({
    required this.story,
    required this.choices,
    required this.preferredIndex,
    required this.supportiveIndices,
  });

  final String story;
  final List<String> choices;
  final int preferredIndex;
  final Set<int> supportiveIndices;

  bool isSupportive(int index) => supportiveIndices.contains(index);
}

class SocialScenario {
  const SocialScenario({
    required this.story,
    required this.choices,
    required this.preferredIndex,
    required this.supportiveIndices,
  });

  final String story;
  final List<String> choices;
  final int preferredIndex;
  final Set<int> supportiveIndices;

  PresentedSocialScenario present({required Random random, required int choiceCount, required int preferredPosition}) {
    final safeCount = choiceCount.clamp(2, choices.length).toInt();
    final candidates = <int>[for (var i = 0; i < choices.length; i++) if (i != preferredIndex) i]..shuffle(random);
    final selectedOriginal = <int>[preferredIndex, ...candidates.take(safeCount - 1)];
    final items = selectedOriginal.map((i) => (text: choices[i], original: i)).toList()..shuffle(random);
    final targetPosition = preferredPosition.clamp(0, safeCount - 1).toInt();
    final currentPreferred = items.indexWhere((e) => e.original == preferredIndex);
    final preferredItem = items.removeAt(currentPreferred);
    items.insert(targetPosition, preferredItem);
    final supportiveDisplay = <int>{};
    for (var i = 0; i < items.length; i++) {
      if (supportiveIndices.contains(items[i].original)) supportiveDisplay.add(i);
    }
    return PresentedSocialScenario(
      story: story,
      choices: items.map((e) => e.text).toList(),
      preferredIndex: targetPosition,
      supportiveIndices: supportiveDisplay,
    );
  }

  static const examples = <SocialScenario>[
    SocialScenario(
      story: 'Uma colega deixou cair os lápis e está juntando tudo.',
      choices: ['Oferecer ajuda', 'Continuar a própria atividade sem atrapalhar', 'Rir dela'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Um amigo diz que quer brincar sozinho por alguns minutos.',
      choices: ['Respeitar o espaço', 'Perguntar depois se ele quer companhia', 'Insistir até ele aceitar'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Duas crianças querem usar o mesmo brinquedo.',
      choices: ['Combinar turnos', 'Procurar outra brincadeira enquanto espera', 'Gritar para pegar primeiro'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Alguém não entendeu a regra de uma brincadeira.',
      choices: ['Explicar com calma', 'Mostrar um exemplo', 'Excluir da brincadeira'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Uma criança está falando e você também quer contar uma coisa.',
      choices: ['Esperar uma pausa e pedir a vez', 'Guardar a ideia para contar depois', 'Interromper gritando'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Seu colega escolheu uma brincadeira diferente da sua.',
      choices: ['Conversar para encontrar uma opção boa para os dois', 'Brincar separado por um tempo sem brigar', 'Obrigar o colega a mudar'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Um amigo parece chateado e não quer explicar o motivo.',
      choices: ['Dizer que você está disponível se ele quiser falar', 'Dar espaço com respeito', 'Ficar perguntando sem parar'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
    SocialScenario(
      story: 'Você entendeu uma fala de um jeito diferente do colega.',
      choices: ['Perguntar com calma o que ele quis dizer', 'Explicar como você entendeu', 'Decidir que ele fez de propósito'],
      preferredIndex: 0,
      supportiveIndices: {0, 1},
    ),
  ];
}
