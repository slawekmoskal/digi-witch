// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Hoje';

  @override
  String get tabNumerology => 'Números';

  @override
  String get tabTarot => 'Tarô';

  @override
  String get tabLibrary => 'Biblioteca';

  @override
  String get tabJournal => 'Diário';

  @override
  String get settings => 'Ajustes';

  @override
  String get start => 'Vamos começar';

  @override
  String get onboardWhat =>
      'Seu guia diário de símbolos: horóscopo do dia, a Lua, tarô, numerologia, seu signo chinês e um dicionário de sonhos. Cada cálculo é mostrado passo a passo, e cada carta é explicada na biblioteca.';

  @override
  String get onboardNot =>
      'Esta é uma ferramenta de entretenimento, aprendizado sobre simbolismo e autorreflexão. Ela não prevê o futuro, não mede a personalidade em sentido científico e não substitui orientação profissional.';

  @override
  String get onboardPrivacy =>
      'Você não precisa criar conta. Datas, nomes e o seu diário ficam apenas neste aparelho.';

  @override
  String get onboardAdults => 'Este app é destinado a adultos.';

  @override
  String get reversed => 'invertida';

  @override
  String get writeReflection => 'Escrever uma reflexão no diário';

  @override
  String get exportJournal => 'Exportar diário';

  @override
  String get newEntry => 'Nova anotação';

  @override
  String get editEntry => 'Anotação';

  @override
  String get journalEmpty =>
      'Seu diário está vazio. Anote um primeiro pensamento. Você pode começar pela pergunta do dia ou por uma carta que tirou.';

  @override
  String get journalPrivacy =>
      'As anotações ficam guardadas apenas neste aparelho.';

  @override
  String get deleteEntryConfirm =>
      'Excluir esta anotação? Não é possível desfazer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get save => 'Salvar';

  @override
  String get linkedResult => 'Resultado vinculado';

  @override
  String get promptsTitle => 'Uma pergunta para começar (opcional)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'Geral',
      'rodzina': 'Família',
      'tarot': 'Tarô',
      'liczby': 'Números',
      'other': 'Outras',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Sortear uma pergunta';

  @override
  String get familyNote =>
      'Escreva apenas o que você se sente à vontade para compartilhar. Você pode usar apelidos no lugar dos nomes de quem ama.';

  @override
  String get entryHint => 'Seus pensamentos…';

  @override
  String get tarotIntro =>
      'Tratamos as cartas como um ponto de partida para a reflexão, não como previsão. As posições de uma tiragem são perguntas que vale a pena fazer a si mesmo.';

  @override
  String get drawCards => 'Tirar cartas';

  @override
  String get drawAgain => 'Tirar de novo';

  @override
  String get reversedOn =>
      'Cartas invertidas: ativadas (cada carta de forma independente, com 1 chance em 2).';

  @override
  String get reversedOff =>
      'Cartas invertidas: desativadas. Você pode ativá-las nos Ajustes.';

  @override
  String get spreadReflectionPrompt =>
      'O que mais me tocou nesta tiragem, e por quê?';

  @override
  String get questionLabel => 'Sua pergunta (opcional)';

  @override
  String get questionHint =>
      'p. ex.: O que devo ter em mente ao mudar de emprego?';

  @override
  String get readingTitle => 'O que as cartas dizem sobre a sua pergunta';

  @override
  String get readingTitleNoQuestion => 'Resumo da tiragem';

  @override
  String get summaryMajors =>
      'Os Arcanos Maiores dominam: o tema toca algo importante, maior que as decisões do dia a dia.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Predominam os Paus: energia, ação e iniciativa estão em segundo plano.',
      'cups': 'Predominam as Copas: emoções, sentimentos e relações estão em segundo plano.',
      'swords': 'Predominam as Espadas: pensamentos, decisões e conversas difíceis estão em segundo plano.',
      'pentacles': 'Predominam os Ouros: trabalho, dinheiro e assuntos práticos estão em segundo plano.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'A maioria das cartas está invertida: algo pode estar bloqueado, atrasado ou sendo vivido mais por dentro do que por fora.';

  @override
  String get summaryBalanced =>
      'As cartas estão bem distribuídas: nenhuma área predomina claramente.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'A resposta das cartas: $card na posição “$position”: $advice';
  }

  @override
  String get addBookmark => 'Adicionar aos favoritos';

  @override
  String get removeBookmark => 'Remover dos favoritos';

  @override
  String get group => 'Grupo';

  @override
  String get keywords => 'Palavras-chave';

  @override
  String get symbolism => 'Simbolismo';

  @override
  String get upright => 'Significado direto';

  @override
  String get reversedMeaning => 'Significado invertido';

  @override
  String get reflectionQuestions => 'Perguntas para refletir';

  @override
  String get reflectionQuestion => 'Pergunta para refletir';

  @override
  String get sourcesAndRights => 'Fontes e direitos';

  @override
  String get cardSourceNote =>
      'As descrições das cartas são textos originais escritos para este app. Ilustração: Pamela Colman Smith (1878–1951), baralho publicado em 1909, em domínio público; digitalização de um exemplar “Roses & Lilies” (Saskia Jansen), disponível no Wikimedia Commons. A imagem foi apenas redimensionada.';

  @override
  String get numerologyIntro =>
      'Informe sua data de nascimento e, se quiser, seu nome completo. Salvos como seu perfil, eles liberam o horóscopo de hoje, o número do dia, seus três grandes e o seu signo chinês. Os dados ficam apenas neste celular.';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get birthDateHelp => 'Só números: dia, mês, ano, p. ex. 15071990';

  @override
  String get fullNameOptional => 'Nome completo (opcional)';

  @override
  String get fullNameHelp =>
      'Necessário apenas para os números calculados a partir das letras. São aceitas letras acentuadas e o ç; espaços, hifens e apóstrofos são ignorados.';

  @override
  String get personalYearFor => 'Ano pessoal para:';

  @override
  String get previousYear => 'Ano anterior';

  @override
  String get nextYear => 'Próximo ano';

  @override
  String get calculate => 'Calcular';

  @override
  String get saveAsProfile => 'Salvar como meu perfil';

  @override
  String get profileSaved => 'Salvo neste aparelho.';

  @override
  String get portrait => 'Retrato numerológico';

  @override
  String get portraitNote =>
      'Abra um número para ver o cálculo e a interpretação simbólica. Os resultados seguem a convenção descrita na Biblioteca (“Como calculamos”).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Caminho de vida',
      'birthDay': 'Número do dia de nascimento',
      'expression': 'Número de expressão',
      'soulUrge': 'Número da alma',
      'personality': 'Número de personalidade',
      'personalYear': 'Ano pessoal',
      'personalDay': 'Número do dia',
      'relation': 'Número da relação',
      'personalMonth': 'Mês pessoal',
      'maturity': 'Número de maturidade',
      'house': 'Número da casa',
      'other': 'Número',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'Nada para calcular';

  @override
  String get calculation => 'Cálculo';

  @override
  String get symbolicInterpretation => 'Interpretação simbólica';

  @override
  String get enterDateOrName =>
      'Informe uma data de nascimento ou um nome completo.';

  @override
  String get dateInvalid => 'Essa data não existe. Confira o dia e o mês.';

  @override
  String get dateFuture => 'A data não pode estar no futuro.';

  @override
  String get nameNoLetters => 'Informe pelo menos uma letra.';

  @override
  String nameUnsupported(String chars) {
    return 'Caracteres não aceitos: $chars. Informe a grafia em alfabeto latino (uma transliteração) que você quer usar no cálculo.';
  }

  @override
  String get cardOfDay => 'Carta do dia';

  @override
  String get cardOfDayNote =>
      'A carta do dia permanece a mesma até o fim do dia, pelo relógio deste aparelho.';

  @override
  String get promptOfDay => 'Pergunta do dia';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Seu ano pessoal $yearString';
  }

  @override
  String get search => 'Buscar cartas, termos, artigos';

  @override
  String get bookmarks => 'Favoritos';

  @override
  String get articles => 'Artigos';

  @override
  String cardsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cartas ($n)',
      one: 'Carta (1)',
    );
    return '$_temp0';
  }

  @override
  String get archetypes => 'Arquétipos';

  @override
  String get archetypesNote =>
      'Os 12 arquétipos são um modelo editorial próprio deste app: uma entre muitas formas possíveis de dividir o tema, não um cânone nem um teste psicológico.';

  @override
  String get aboutModel => 'Sobre o modelo';

  @override
  String get archetypeGifts => 'Dons';

  @override
  String get archetypeShadow => 'Sombra';

  @override
  String get glossary => 'Glossário';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get allowReversed => 'Cartas invertidas';

  @override
  String get allowReversedRule =>
      'Quando ativado, cada carta tirada pode sair invertida de forma independente, com 1 chance em 2.';

  @override
  String get profile => 'Meu perfil';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyBody =>
      'Não criamos contas nem enviamos suas datas, nomes ou anotações a nenhum servidor. Seus dados ficam apenas neste aparelho, a menos que você mesmo os exporte.';

  @override
  String get deleteAllTitle => 'Apagar todos os dados';

  @override
  String get deleteAllBody =>
      'Vamos remover do aparelho o seu diário, perfil, favoritos, carta do dia e ajustes. Não é possível desfazer.';

  @override
  String get sourcesBody =>
      'As interpretações, perguntas, arquétipos e artigos são textos originais. Ilustrações das cartas: Pamela Colman Smith, baralho de 1909 (domínio público), digitalizações do Wikimedia Commons; os detalhes estão em cada carta. As fontes históricas estão listadas no fim dos artigos.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Ajuda';

  @override
  String get helpBody =>
      'Se você está passando por uma crise, procure um profissional de saúde mental ou um serviço de apoio emocional: no Brasil, o CVV atende pelo 188, gratuitamente, 24 horas por dia. Em caso de emergência, ligue para o 192 (SAMU), 190 (Polícia) ou 193 (Bombeiros).';

  @override
  String get versions => 'Versões';

  @override
  String get algorithm => 'algoritmo';

  @override
  String get contentVer => 'conteúdo';

  @override
  String get disclaimer =>
      'Este conteúdo é para entretenimento, aprendizado e autorreflexão. Não constitui aconselhamento médico, psicológico, jurídico ou financeiro.';

  @override
  String get proShort => 'Compra única: sem anúncios, tiragens extras.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Sem anúncios em todo o app\n• Tiragens extras: “Relacionamento” (6 cartas) e “Cruz da reflexão” (10 cartas)\n• Pagamento único, sem assinatura';

  @override
  String get proFreeStays =>
      'A numerologia, a carta do dia, as tiragens de 1, 3 e 5 cartas, a biblioteca e o diário continuam gratuitos. Comprar o Pro não influencia quais cartas saem nem como os resultados são calculados.';

  @override
  String get proActive => 'Você tem o Pro. Obrigado!';

  @override
  String get proUnavailable =>
      'A compra não está disponível agora. Verifique sua conexão com a internet e tente novamente mais tarde.';

  @override
  String proBuy(String price) {
    return 'Comprar o Pro por $price';
  }

  @override
  String get purchaseError =>
      'A compra não foi concluída. Você não foi cobrado, a menos que a loja tenha confirmado a transação.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get proOnly => 'Disponível no Pro';

  @override
  String get adPrivacyOptions => 'Privacidade dos anúncios';

  @override
  String get reminder => 'Lembrete diário';

  @override
  String get reminderOff => 'Desativado';

  @override
  String reminderAt(String time) {
    return 'Todos os dias às $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Um momento para refletir, se você quiser.';

  @override
  String get reminderDenied =>
      'As notificações não estão permitidas. Você pode permiti-las nos ajustes do sistema.';

  @override
  String get proStoreNote =>
      'O pagamento e eventuais reembolsos são tratados pela App Store ou pelo Google Play, segundo as regras deles. A compra funciona com ou sem o seu consentimento para anúncios.';

  @override
  String get horoscopeToday => 'Hoje';

  @override
  String get horoscopeStars => 'Os astros dizem';

  @override
  String get horoscopeCaution => 'Atenção';

  @override
  String moonIn(String sign, String phase) {
    return 'Lua em $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Números da sorte do dia';

  @override
  String get luckyNote =>
      'Por diversão: os números vêm da sua data de nascimento e da data de hoje, por isso ficam os mesmos o dia todo. Eles não preveem prêmios.';

  @override
  String get whyThis => 'De onde isso vem';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Seu signo: $sign ($dates), elemento: $element. Signo chinês: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'o mesmo elemento',
      'supportive': 'favorável',
      'tense': 'tensa',
      'other': 'neutra',
    });
    return 'Ao meio-dia de hoje a Lua está em $sign (elemento: $element). Relação com o seu elemento: $_temp0.';
  }

  @override
  String get whyMethod =>
      'A posição da Lua é calculada com fórmulas astronômicas, offline (precisão de cerca de 0,5°). O texto de “Hoje” depende da relação entre os elementos, “Os astros dizem” da fase da Lua, e “Atenção” do número do seu dia.';

  @override
  String get horoscopeNeedsBirth =>
      'Informe sua data de nascimento e você verá na hora seu signo, o horóscopo de hoje, o número do dia e seus números da sorte.';

  @override
  String get moonToday => 'A Lua hoje';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · $percent% iluminada · em $sign';
  }

  @override
  String get moonCalendar => 'Calendário lunar';

  @override
  String get moonCalendarIntro =>
      'As próximas fases principais da Lua, no horário local (precisão de cerca de 1 hora).';

  @override
  String get compatibility => 'Compatibilidade entre duas pessoas';

  @override
  String get compatIntro =>
      'Informe duas datas de nascimento. Vamos comparar signos, elementos, signos chineses e caminhos de vida. É uma brincadeira e um bom assunto de conversa, não um veredito sobre a relação.';

  @override
  String personDate(int n) {
    return 'Data de nascimento: pessoa $n';
  }

  @override
  String get check => 'Comparar';

  @override
  String get compatElements => 'Elementos';

  @override
  String personLine(
    int n,
    String sign,
    String element,
    String chinese,
    int lifePath,
  ) {
    return 'Pessoa $n: $sign ($element) · Signo chinês: $chinese · caminho de vida $lifePath';
  }

  @override
  String get birthCardTitle => 'Carta de nascimento';

  @override
  String get birthCardNote =>
      'Método: dia + mês + ano de nascimento; depois os algarismos são somados até o resultado não passar de 22 (22 = O Louco). Um resultado de dois algarismos gera também uma carta companheira.';

  @override
  String get birthCardSecond => 'Carta companheira';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'A resposta das cartas: SIM',
      'no': 'A resposta das cartas: NÃO',
      'other': 'A resposta das cartas: INCERTO. A questão ainda está em aberto',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Hoje para você';

  @override
  String get licenses => 'Licenças (fontes e bibliotecas)';

  @override
  String get cardAdvice => 'O conselho da carta';

  @override
  String get correspondences =>
      'Correspondências astrológicas (Golden Dawn, século XIX)';

  @override
  String get chooseSpread => 'Escolha uma tiragem';

  @override
  String get tapDeck => 'Concentre-se na sua pergunta e toque no baralho';

  @override
  String spreadCards(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cartas',
      one: '1 carta',
    );
    return '$_temp0';
  }

  @override
  String get bigThree => 'Seus três grandes';

  @override
  String get bigThreeIntro =>
      'O Sol é o seu signo. A Lua descreve suas emoções, e o ascendente, como os outros veem você. Para a Lua, em geral basta a data; o ascendente exige a hora e o local de nascimento. Os dados ficam apenas neste aparelho.';

  @override
  String get birthTime => 'Hora de nascimento';

  @override
  String get notGiven => 'não informado';

  @override
  String get birthPlace => 'Local de nascimento';

  @override
  String get placesNote =>
      'Cidades da Polônia e grandes cidades do mundo. Se a sua não estiver na lista, escolha a mais próxima do mesmo país ou informe as coordenadas. Algumas dezenas de quilômetros mudam o ascendente em menos de 1°.';

  @override
  String get sunLabel => 'Sol';

  @override
  String get moonLabel => 'Lua';

  @override
  String get ascLabel => 'Ascendente';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Nesse dia a Lua mudou de signo: $a ou $b, dependendo da sua hora de nascimento.';
  }

  @override
  String get ascNeeds =>
      'Informe a hora e o local de nascimento para calcular o ascendente.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Hora local $local → $utc UTC (fuso $zone, com histórico de horário de verão).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Longitude eclíptica da Lua: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendente: $deg° → $sign ($place, $lat° N, $lon° L).';
  }

  @override
  String get needBirthDate =>
      'Primeiro salve sua data de nascimento na aba Números (botão “Salvar como meu perfil”).';

  @override
  String get clear => 'Limpar';

  @override
  String get chineseTitle => 'Horóscopo chinês';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Ano no calendário chinês: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'O Ano Novo Chinês cai entre 21 de janeiro e 20 de fevereiro. Se você nasceu antes dele, pertence ao signo do ano anterior. Isso já foi levado em conta aqui.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Ano $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'O ano chinês atual começou em $date.';
  }

  @override
  String get chineseCompatTitle => 'Compatibilidade dos signos chineses';

  @override
  String get chineseFriend => 'Amigo secreto';

  @override
  String get chineseTrine => 'Trio de aliados';

  @override
  String get chineseClash => 'Signo oposto';

  @override
  String get chineseElement => 'Elemento do ano de nascimento';

  @override
  String get mercuryRetro => 'Mercúrio retrógrado';

  @override
  String mercuryNow(String date) {
    return 'Mercúrio retrógrado até $date';
  }

  @override
  String get mercuryNone => 'Sem períodos retrógrados no próximo ano.';

  @override
  String get upcomingPhases => 'Próximas fases';

  @override
  String get dayByDay => 'Dia a dia (30 dias)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Lua em $sign · $phase';
  }

  @override
  String get dreams => 'Dicionário de sonhos';

  @override
  String dreamsCount(int n) {
    return '$n símbolos de sonhos: o que um sonho pode dizer sobre você';
  }

  @override
  String get dreamsIntro =>
      'Os sonhos não preveem o futuro. O dicionário sugere com o que um símbolo costuma ser associado, e a pergunta ajuda você a ver o que ele significa para si. O mais importante é como você se sentiu no sonho.';

  @override
  String get dreamsSearch => 'Busque um símbolo, p. ex. água, dentes, casa';

  @override
  String get dreamsEmpty =>
      'Não há esse símbolo. Tente uma palavra parecida ou anote o sonho no diário.';

  @override
  String chineseSignButton(String animal) {
    return 'Signo chinês: $animal';
  }

  @override
  String get otherPlace => 'Outro local: informar coordenadas';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Outro local: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Você encontra as coordenadas em um app de mapas (por exemplo, tocando em um lugar no Google Maps). Sul e oeste entram com sinal de menos. O fuso horário é uma região, p. ex. America/Sao_Paulo, Europe/Lisbon.';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get timeZone => 'Fuso horário';

  @override
  String get otherPlaceMissing =>
      'Informe a latitude, a longitude e o fuso horário.';

  @override
  String get otherPlaceRange =>
      'A latitude deve estar entre -66° e 66° (além dos círculos polares o ascendente pode ficar indefinido), e a longitude entre -180° e 180°.';

  @override
  String get numbersStartTitle => 'Comece pela sua data de nascimento';

  @override
  String get numbersEditTitle => 'Alterar dados ou calcular para outra pessoa';

  @override
  String get calculateOnce => 'Só calcular (sem salvar)';

  @override
  String get compatibilityHint => 'Compare duas datas de nascimento';

  @override
  String get yourNumbers => 'Seus números';

  @override
  String get editOrOther => 'Alterar dados ou calcular para outra pessoa';

  @override
  String get showMyHoroscope => 'Ver meu horóscopo';

  @override
  String get privacyShort =>
      'A data fica apenas neste celular. Você pode alterá-la na aba Números.';

  @override
  String get explore => 'Explorar';

  @override
  String get exploreBigThree => 'Sol, Lua e ascendente';

  @override
  String get exploreChinese => 'Signo, elemento e o seu ano';

  @override
  String get exploreTarot => 'Pergunte às cartas';

  @override
  String get exploreTarotSub => 'Tiragens e perguntas de sim ou não';

  @override
  String get exploreNumbersSub => 'Caminho de vida e carta de nascimento';

  @override
  String get exploreMoon => 'Fases, jardinagem, Mercúrio retrógrado';

  @override
  String get exploreDreams => 'O que o seu sonho diz';

  @override
  String get exploreLibrary => '78 cartas, artigos, glossário: na Biblioteca';

  @override
  String get exploreLibraryTitle => 'Cartas e artigos';

  @override
  String get squareTitle => 'Quadrado de Pitágoras';

  @override
  String get squareIntro =>
      'Uma grade com os algarismos da sua data de nascimento (método de Aleksandrov): quanto mais vezes um algarismo aparece, mais forte é o traço. Toque em uma célula para ler a descrição.';

  @override
  String get squareEmpty => 'nenhum';

  @override
  String get cyclesTitle => 'Ciclos de vida: picos e desafios';

  @override
  String get cyclesIntro =>
      'A numerologia divide a vida em quatro etapas. Cada uma tem o seu “pico”, um tema de crescimento, e o seu “desafio”, uma lição a trabalhar. A duração da primeira etapa depende do seu caminho de vida.';

  @override
  String ageRange(int from, int to) {
    return '$from–$to anos';
  }

  @override
  String ageFrom(int from) {
    return 'a partir dos $from anos';
  }

  @override
  String get cyclesNow => 'AGORA';

  @override
  String get ichingTitle => 'Oráculo I Ching';

  @override
  String get ichingIntro =>
      'O Livro das Mutações é um oráculo chinês clássico. Pense na sua pergunta e lance três moedas seis vezes; o hexagrama é montado de baixo para cima. As linhas marcadas com um ponto são “mutáveis” e mostram no que a situação está se transformando.';

  @override
  String ichingToss(int n) {
    return 'Lançar as moedas ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'coroa, coroa, coroa = 6 (yin velho, mutável)',
      '7': 'duas coroas e uma cara = 7 (yang)',
      '8': 'duas caras e uma coroa = 8 (yin)',
      'other': 'cara, cara, cara = 9 (yang velho, mutável)',
    });
    return 'Último lançamento: $_temp0';
  }

  @override
  String get ichingMeaning => 'Significado';

  @override
  String get ichingChange => 'Direção da mudança';

  @override
  String ichingChangingLines(String lines) {
    return 'Linhas mutáveis: $lines. A situação está se transformando em:';
  }

  @override
  String get ichingAgain => 'Nova pergunta';

  @override
  String get ichingNote =>
      'As descrições dos hexagramas e das linhas são interpretações curtas próprias deste app, inspiradas nas imagens do antigo texto chinês. Trate-as como ponto de partida para a reflexão.';

  @override
  String get exploreIching => 'Uma pergunta e seis lançamentos de moedas';

  @override
  String get ritualsTitle => 'Rituais da Lua';

  @override
  String get exploreRituals => 'Intenções para a Lua nova e a cheia';

  @override
  String get ritualsIntro =>
      'A Lua nova e a cheia marcam o ritmo do mês. Na Lua nova, anote uma intenção; na cheia, olhe para trás e veja o que aconteceu. Suas anotações vão para o diário.';

  @override
  String get moonRemindersToggle => 'Lembrar da Lua nova e da cheia';

  @override
  String get moonRemindersNote =>
      'Uma notificação às 9h no dia da Lua nova e da Lua cheia. Funciona offline.';

  @override
  String get moonReminderNewTitle => 'Lua nova: hora de uma intenção';

  @override
  String get moonReminderNewBody =>
      'Anote o que você quer começar neste ciclo.';

  @override
  String get moonReminderFullTitle => 'Lua cheia: hora de olhar para trás';

  @override
  String get moonReminderFullBody =>
      'O que deu certo desde a Lua nova? Pelo que você é grato?';

  @override
  String get forYouToday => 'Só para você';

  @override
  String get advice => 'Conselho';

  @override
  String get karmicTitle => 'Carma nos números';

  @override
  String get karmicIntro =>
      'Dívidas cármicas são os números 13, 14, 16 e 19 que aparecem no caminho até os seus números. Lições cármicas são os algarismos ausentes do seu nome completo. Na tradição, descrevem temas a trabalhar, não veredictos.';

  @override
  String get karmicNone => 'Nenhuma dívida cármica nos seus números.';

  @override
  String get karmicLessonsTitle =>
      'Lições cármicas (algarismos ausentes do seu nome)';

  @override
  String get houseTitle => 'Numerologia da casa e do telefone';

  @override
  String get houseHint =>
      'Número da casa, do apartamento ou do telefone, p. ex. 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Cor do dia: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Cor: $color · pedra: $stone · dia: $day · planeta: $planet';
  }

  @override
  String get periodTitle => 'Horóscopo da semana e do mês';

  @override
  String get explorePeriod => 'Dias-chave e o seu mês pessoal';

  @override
  String get periodIntro =>
      'Calculado a partir do céu real: as fases da Lua, eclipses, Mercúrio retrógrado, a entrada do Sol no próximo signo e os dias em que a Lua está no seu signo, além dos seus números pessoais.';

  @override
  String get tabWeek => 'Semana';

  @override
  String get tabMonth => 'Mês';

  @override
  String get weekGeneral => 'Em geral';

  @override
  String get keyDays => 'Dias-chave';

  @override
  String get noKeyDays =>
      'Não há eventos especiais no céu neste período. É um bom momento para um trabalho calmo e constante.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Lua no seu signo ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'O Sol entra em $sign';
  }

  @override
  String get evMercuryStart => 'Mercúrio entra em retrogradação';

  @override
  String get evMercuryEnd => 'Mercúrio volta a direto';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Eclipse solar',
      'partial': 'Eclipse lunar (parcial ou total)',
      'other': 'Eclipse lunar penumbral (sutil)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Número do dia $n: $title';
  }

  @override
  String get eclipsesTitle => 'Eclipses no próximo ano';

  @override
  String get eclipseVisibility =>
      'A visibilidade depende de onde você está na Terra: nem todo eclipse pode ser visto do seu local.';

  @override
  String eclipseSoon(String when) {
    return 'Um eclipse se aproxima: $when';
  }

  @override
  String get loveLabel => 'Amor';

  @override
  String get workLabel => 'Trabalho';

  @override
  String get wellbeingLabel => 'Bem-estar';

  @override
  String ichingImage(String upper, String lower) {
    return 'Imagem: $upper sobre $lower';
  }

  @override
  String get ichingLinesTitle => 'Linhas mutáveis';

  @override
  String ichingLine(int n, String text) {
    return 'Linha $n: $text';
  }

  @override
  String get revealCard => 'Descobrir a carta';

  @override
  String get revealCardHint => 'Toque na carta para ver o que o dia traz.';

  @override
  String get cardOfDayMore => 'Mais sobre a carta';

  @override
  String get moodQuestion => 'Como você está hoje?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Pesado',
      '2': 'Para baixo',
      '3': 'Mais ou menos',
      '4': 'Bem',
      'other': 'Ótimo',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Salvo apenas neste aparelho.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'em $days dias',
      one: 'amanhã',
      zero: 'hoje',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Seu aniversário';

  @override
  String notifMoon(String sign) {
    return 'Lua em $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'número do dia $n';
  }

  @override
  String get notifCard => 'sua carta do dia está esperando';

  @override
  String get tabStars => 'Astros';

  @override
  String get starsMore => 'Mais dos astros';

  @override
  String get deckTitle => 'O baralho';

  @override
  String get fullHoroscope => 'Horóscopo completo';

  @override
  String get upcoming => 'Em breve';

  @override
  String get suggested => 'Sugestão de hoje';

  @override
  String get suggestBigThree =>
      'Adicione hora e local de nascimento para descobrir sua Lua e seu ascendente';

  @override
  String get dayNumberShort => 'número do dia';

  @override
  String get dayColorShort => 'cor do dia';

  @override
  String get fullNumerology => 'Numerologia completa e retrato';

  @override
  String get firstEntry => 'Escreva um primeiro pensamento';

  @override
  String get greetDay => 'Bom dia';

  @override
  String get greetEvening => 'Boa noite';

  @override
  String get dayHoroscope => 'Horóscopo';

  @override
  String get dayNumbers => 'Meus números';

  @override
  String get dayCard => 'Carta';

  @override
  String get dayDone => 'Tudo feito por hoje.';

  @override
  String tomorrowIs(String what) {
    return 'Amanhã: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Amanhã: Lua em $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Amanhã: uma nova carta e o número do dia $n.';
  }

  @override
  String get tomorrowCard => 'Amanhã: uma nova carta do dia.';

  @override
  String get tabDreams => 'Sonhos';

  @override
  String get dreamAsk => 'Com o que você sonhou esta noite?';

  @override
  String get dreamAskHint =>
      'Anote o sonho antes que ele desbote, ou procure um símbolo abaixo.';

  @override
  String get dreamSave => 'Anotar o sonho';

  @override
  String get dreamEntry => 'Sonho';

  @override
  String get dreamOfDay => 'Símbolo do dia';

  @override
  String get dreamsAll => 'Todos os símbolos';

  @override
  String get widgetCardWaiting => 'Esperando para ser revelada';

  @override
  String get widgetStale => 'Toque para ver o seu dia';

  @override
  String widgetCardSays(String advice) {
    return 'A carta diz: $advice';
  }

  @override
  String get widgetNeedBirth =>
      'Informe sua data de nascimento para ver o seu dia.';

  @override
  String get language => 'Idioma';

  @override
  String get dateHint => 'DD.MM.AAAA';

  @override
  String get layTarot => 'Fazer uma tiragem';

  @override
  String get tarotWelcomeTitle => 'O que as cartas vão sugerir hoje?';

  @override
  String get tarotWelcomeBody =>
      'Pense no que está na sua cabeça, escolha uma tiragem e vire as cartas. Cada tiragem é um novo olhar. Volte sempre que surgir uma nova pergunta.';

  @override
  String get seeDeck => 'Ver o baralho';

  @override
  String get tarotWelcomeSetting => 'Introdução na aba Tarô';

  @override
  String get hide => 'Ocultar';

  @override
  String get tapHint => 'toque';

  @override
  String get dailyMood => 'Como você pode se sentir hoje';

  @override
  String get dailyEvents => 'O que o dia pode trazer';

  @override
  String get dailyAdvice => 'Conselho para hoje';

  @override
  String get energyLabel => 'Energia';

  @override
  String meterValue(String label, int n) {
    return '$label: $n de 5';
  }

  @override
  String get cheerAll => 'Um dia lindo, os astros estão a seu favor';

  @override
  String get cheerLove => 'Um bom dia para o coração';

  @override
  String get cheerWork => 'Um bom dia para fazer acontecer';

  @override
  String get cheerEnergy => 'Um dia cheio de energia';

  @override
  String get cheerUpLove => 'O amor está melhor que ontem';

  @override
  String get cheerUpWork => 'O trabalho está melhor que ontem';

  @override
  String get cheerUpEnergy => 'Mais energia que ontem';

  @override
  String get cheerNewMoon => 'Lua nova, boa hora para uma intenção nova';

  @override
  String get cheerWaxing => 'A Lua cresce, e seus planos com ela';

  @override
  String get cheerFullMoon => 'Lua cheia, hora de valorizar o que você já tem';

  @override
  String get cheerWaning => 'A Lua míngua, fica mais fácil soltar o que pesa';

  @override
  String get cheerNewMoon2 =>
      'Lua nova, uma página em branco. Escreva algo bom nela';

  @override
  String get cheerNewMoon3 => 'Lua nova, as melhores ideias nascem no silêncio';

  @override
  String get cheerWaxing2 =>
      'A Lua está crescente, bom momento para somar pequenos passos';

  @override
  String get cheerWaxing3 => 'A Lua crescente favorece o que você começa';

  @override
  String get cheerFullMoon2 =>
      'Lua cheia, hoje dá para enxergar mais. Inclusive o que deu certo';

  @override
  String get cheerFullMoon3 =>
      'Lua cheia, uma boa noite para celebrar as pequenas coisas';

  @override
  String get cheerWaning2 =>
      'A Lua está minguante, bom momento para arrumar e respirar';

  @override
  String get cheerWaning3 =>
      'A Lua minguante favorece o descanso e o encerrar de ciclos';

  @override
  String get threeGood => 'Anote três coisas boas';

  @override
  String get threeGoodPrompt =>
      'Três coisas boas desta semana, e o que as tornou possíveis:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Dias difíceis acontecem. Hoje você não precisa compensar nada.',
      '2': 'Um dia mais fraco também vale. Um pequeno passo basta.',
      '3': 'Um dia comum também conta.',
      '4': 'Que bom ouvir isso.',
      'other': 'Que lindo. Vale lembrar o que tornou o dia assim.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk =>
      'Quer que a carta do dia espere por você todas as manhãs?';

  @override
  String get reminderAskSub =>
      'Uma notificação por dia, às 8h, com o conteúdo do dia. Mude o horário ou desative nos Ajustes.';

  @override
  String get reminderYes => 'Sim, me lembre';

  @override
  String get reminderNo => 'Não, obrigado';

  @override
  String get onboardBirthHint =>
      'Opcional. Com a data você vê na hora seu signo, horóscopo e números.';

  @override
  String get lookBack => 'Seus dias';

  @override
  String get lookBackHint =>
      'Cartas do dia e humor, dia a dia. Guardados apenas neste aparelho.';
}
