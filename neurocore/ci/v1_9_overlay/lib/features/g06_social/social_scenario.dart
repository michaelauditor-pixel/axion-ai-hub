import 'dart:math';

class PresentedSocialScenario {
  const PresentedSocialScenario({required this.story, required this.choices, required this.preferredIndex});
  final String story;
  final List<String> choices;
  final int preferredIndex;
}

class SocialScenario {
  const SocialScenario({required this.story, required this.choices, required this.preferredIndex});
  final String story;
  final List<String> choices;
  final int preferredIndex;

  PresentedSocialScenario present({required Random random, required int choiceCount, required int preferredPosition}) {
    final safeCount = choiceCount.clamp(2, choices.length).toInt();
    final preferred = choices[preferredIndex];
    final alternatives = <String>[for (var i = 0; i < choices.length; i++) if (i != preferredIndex) choices[i]]..shuffle(random);
    final visible = <String>[preferred, ...alternatives.take(safeCount - 1)]..shuffle(random);
    final targetPosition = preferredPosition.clamp(0, safeCount - 1).toInt();
    visible.remove(preferred);
    visible.insert(targetPosition, preferred);
    return PresentedSocialScenario(story: story, choices: visible, preferredIndex: targetPosition);
  }

  static const examples = <SocialScenario>[
    SocialScenario(story:'Uma colega deixou cair os lápis e parece ocupada juntando tudo.',choices:['Oferecer ajuda','Continuar a própria atividade sem atrapalhar','Rir dela'],preferredIndex:0),
    SocialScenario(story:'Um amigo diz que quer brincar sozinho por alguns minutos.',choices:['Respeitar o espaço','Perguntar depois se ele quer companhia','Insistir até ele aceitar'],preferredIndex:0),
    SocialScenario(story:'Duas crianças querem usar o mesmo brinquedo.',choices:['Combinar turnos','Procurar outra brincadeira enquanto espera','Gritar mais alto'],preferredIndex:0),
    SocialScenario(story:'Alguém não entendeu a regra de uma brincadeira.',choices:['Explicar com calma','Mostrar um exemplo','Excluir da brincadeira'],preferredIndex:0),
    SocialScenario(story:'Uma criança está falando e você também quer contar uma coisa.',choices:['Esperar uma pausa e pedir a vez','Guardar a ideia para contar depois','Interromper gritando'],preferredIndex:0),
    SocialScenario(story:'Seu colega escolheu uma brincadeira diferente da sua.',choices:['Conversar para encontrar uma opção boa para os dois','Brincar separado por um tempo sem brigar','Obrigar o colega a mudar'],preferredIndex:0),
    SocialScenario(story:'Um amigo parece chateado e não quer explicar o motivo.',choices:['Dizer que você está disponível se ele quiser falar','Dar espaço com respeito','Ficar perguntando sem parar'],preferredIndex:0),
    SocialScenario(story:'Você percebe que entendeu uma fala de um jeito diferente do colega.',choices:['Perguntar com calma o que ele quis dizer','Explicar como você entendeu','Decidir que ele fez de propósito'],preferredIndex:0),
  ];
}
