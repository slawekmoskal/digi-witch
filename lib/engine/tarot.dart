/// Tarot draw engine — pure Dart. Randomness is injected for tests.
/// Result never depends on payment, ads, ad ID or user profile.
library;

import 'dart:math';

import 'lang.dart';
import 'numerology.dart';

const suits = ['wands', 'cups', 'swords', 'pentacles'];

/// Canonical 78 ids: `major_00`..`major_21`, `<suit>_01`..`<suit>_14`.
final List<String> deckIds = List.unmodifiable([
  for (var i = 0; i <= 21; i++) 'major_${i.toString().padLeft(2, '0')}',
  for (final s in suits)
    for (var r = 1; r <= 14; r++) '${s}_${r.toString().padLeft(2, '0')}',
]);

class Spread {
  final String id, name;
  final List<String> positions;
  final bool pro;
  const Spread(this.id, this.name, this.positions, {this.pro = false});

  // The same spread in another language is still the same spread.
  @override
  bool operator ==(Object other) => other is Spread && other.id == id;
  @override
  int get hashCode => id.hashCode;
}

/// Spreads in the app's language; ids, order and card counts are the same in every language.
List<Spread> get spreads => inLang({
  'pl': _spreadsPl,
  'en': _spreadsEn,
  'de': _spreadsDe,
  'fr': _spreadsFr,
  'es': _spreadsEs,
  'uk': _spreadsUk,
  'it': _spreadsIt,
  'pt': _spreadsPt,
  'nl': _spreadsNl,
});

const _spreadsPl = [
  Spread('one', 'Jedna karta', ['Na co warto dziś zwrócić uwagę']),
  Spread('three', 'Trzy karty', [
    'Sytuacja',
    'Możliwa perspektywa',
    'Następny krok',
  ]),
  Spread('five', 'Pięć kart', [
    'Sedno sprawy',
    'Co mnie wspiera',
    'Co mnie ogranicza',
    'Czego nie widzę',
    'Co mogę zrobić',
  ]),
  Spread('relation', 'Relacja', [
    'Ja w tej relacji',
    'Jak widzę drugą osobę',
    'Co nas łączy',
    'Co nas różni',
    'Czego potrzebuję',
    'Co mogę zaproponować',
  ], pro: true),
  Spread('cross', 'Krzyż refleksji', [
    'Sedno',
    'Co je przecina',
    'Podstawa',
    'Co odchodzi',
    'Świadomy cel',
    'Najbliższy krok',
    'Moja postawa',
    'Otoczenie',
    'Nadzieje i obawy',
    'Możliwy kierunek',
  ], pro: true),
  Spread('yesno', 'Tak/Nie', ['Odpowiedź']),
  Spread('decision', 'Decyzja A/B', [
    'Sedno decyzji',
    'Droga A',
    'Dokąd prowadzi A',
    'Droga B',
    'Dokąd prowadzi B',
  ]),
  Spread('month', 'Miesiąc', [
    'Tydzień 1',
    'Tydzień 2',
    'Tydzień 3',
    'Tydzień 4',
    'Rada na miesiąc',
  ]),
  Spread('year', 'Rok', [
    'Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', //
    'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień',
  ], pro: true),
];

const _spreadsEn = [
  Spread('one', 'One card', ['What deserves your attention today']),
  Spread('three', 'Three cards', [
    'The situation',
    'A possible perspective',
    'The next step',
  ]),
  Spread('five', 'Five cards', [
    'The heart of the matter',
    'What supports me',
    'What holds me back',
    'What I am not seeing',
    'What I can do',
  ]),
  Spread('relation', 'Relationship', [
    'Me in this relationship',
    'How I see the other person',
    'What connects us',
    'What sets us apart',
    'What I need',
    'What I can offer',
  ], pro: true),
  Spread('cross', 'Reflection cross', [
    'The heart of it',
    'What crosses it',
    'The foundation',
    'What is passing',
    'The conscious aim',
    'The nearest step',
    'My stance',
    'My surroundings',
    'Hopes and fears',
    'A possible direction',
  ], pro: true),
  Spread('yesno', 'Yes or no', ['The answer']),
  Spread('decision', 'Decision A/B', [
    'The heart of the decision',
    'Path A',
    'Where A leads',
    'Path B',
    'Where B leads',
  ]),
  Spread('month', 'Month', [
    'Week 1',
    'Week 2',
    'Week 3',
    'Week 4',
    'Advice for the month',
  ]),
  Spread('year', 'Year', [
    'January', 'February', 'March', 'April', 'May', 'June', //
    'July', 'August', 'September', 'October', 'November', 'December',
  ], pro: true),
];

class DrawnCard {
  final String cardId;
  final String position;
  final bool reversed;
  const DrawnCard(this.cardId, this.position, this.reversed);

  Map<String, Object> toJson() => {
    'cardId': cardId,
    'position': position,
    'reversed': reversed,
  };
  factory DrawnCard.fromJson(Map<String, dynamic> j) => DrawnCard(
    j['cardId'] as String,
    j['position'] as String,
    j['reversed'] as bool,
  );
}

/// Fisher–Yates via List.shuffle (uniform), then the first N cards — no replacement.
/// Reversal rule: if enabled, each card independently reversed with probability 1/2.
List<DrawnCard> draw(
  Spread spread, {
  required Random random,
  required bool allowReversed,
}) {
  final deck = [...deckIds]..shuffle(random);
  return [
    for (var i = 0; i < spread.positions.length; i++)
      DrawnCard(
        deck[i],
        spread.positions[i],
        allowReversed && random.nextBool(),
      ),
  ];
}

/// Spread-level patterns for the reading summary. Counts only — wording lives in l10n.
class SpreadSummary {
  final bool majorsDominate, mostlyReversed;
  final String? dominantSuit; // strictly most frequent suit, at least 2 cards
  const SpreadSummary(
    this.majorsDominate,
    this.mostlyReversed,
    this.dominantSuit,
  );
}

SpreadSummary summarize(List<DrawnCard> cards) {
  final n = cards.length;
  final suitCounts = <String, int>{};
  for (final c in cards) {
    if (!c.cardId.startsWith('major_')) {
      suitCounts.update(
        c.cardId.split('_').first,
        (v) => v + 1,
        ifAbsent: () => 1,
      );
    }
  }
  final ranked = suitCounts.entries.toList()..sort((a, b) => b.value - a.value);
  final top = ranked.isEmpty ? null : ranked.first;
  final unique =
      top != null &&
      top.value >= 2 &&
      (ranked.length == 1 || ranked[1].value < top.value);
  // Patterns need at least 3 cards to mean anything.
  return SpreadSummary(
    n >= 3 && cards.where((c) => c.cardId.startsWith('major_')).length * 2 > n,
    n >= 3 && cards.where((c) => c.reversed).length * 2 > n,
    unique ? top.key : null,
  );
}

enum YesNo { yes, no, unclear }

// Upright cards traditionally read as "no" or "unclear"; every other upright card is "yes".
const _noCards = {
  'major_15', 'major_16', 'swords_03', 'swords_05', 'swords_08', //
  'swords_09', 'swords_10', 'cups_05', 'pentacles_05', 'wands_10',
};
const _unclearCards = {
  'major_12',
  'major_18',
  'swords_02',
  'swords_07',
  'cups_04',
  'cups_07',
};

/// Reversal weakens the answer: yes → no, no → unclear.
YesNo yesNo(DrawnCard c) {
  final base = _noCards.contains(c.cardId)
      ? YesNo.no
      : _unclearCards.contains(c.cardId)
      ? YesNo.unclear
      : YesNo.yes;
  if (!c.reversed) return base;
  return base == YesNo.yes ? YesNo.no : YesNo.unclear;
}

/// Birth card (Major Arcana) from a birth date: day + month + year, digit sums down to ≤ 22.
class BirthCard {
  final int major; // 0–21; 22 maps to the Fool (0)
  final int? second; // paired card for two-digit results
  final List<String> steps;
  const BirthCard(this.major, this.second, this.steps);
  String get id => 'major_${major.toString().padLeft(2, '0')}';
  String? get secondId =>
      second == null ? null : 'major_${second!.toString().padLeft(2, '0')}';
}

BirthCard birthCard(CalendarDate d) {
  final sum = d.day + d.month + d.year;
  final steps = [
    tr(
      pl: 'Dzień + miesiąc + rok: ${d.day} + ${d.month} + ${d.year} = $sum.',
      en: 'Day + month + year: ${d.day} + ${d.month} + ${d.year} = $sum.',
    ),
  ];
  var n = sum;
  while (n > 22) {
    final m = digitSum(n);
    steps.add(tr(pl: 'Suma cyfr $n = $m.', en: 'Digit sum of $n = $m.'));
    n = m;
  }
  final second = n > 9 ? digitSum(n) : null;
  if (n == 22) {
    steps.add(
      tr(pl: '22 odpowiada Głupcowi (0).', en: '22 stands for The Fool (0).'),
    );
  }
  if (second != null) {
    steps.add(
      tr(
        pl: 'Druga karta pary: suma cyfr $n = $second.',
        en: 'Second card of the pair: digit sum of $n = $second.',
      ),
    );
  }
  return BirthCard(n == 22 ? 0 : n, second, steps);
}

const _spreadsDe = [
  Spread('one', 'Eine Karte', ['Worauf du heute achten solltest']),
  Spread('three', 'Drei Karten', [
    'Die Situation',
    'Eine mögliche Sichtweise',
    'Der nächste Schritt',
  ]),
  Spread('five', 'Fünf Karten', [
    'Der Kern der Sache',
    'Was mich unterstützt',
    'Was mich bremst',
    'Was ich nicht sehe',
    'Was ich tun kann',
  ]),
  Spread('relation', 'Beziehung', [
    'Ich in dieser Beziehung',
    'Wie ich die andere Person sehe',
    'Was uns verbindet',
    'Was uns unterscheidet',
    'Was ich brauche',
    'Was ich anbieten kann',
  ], pro: true),
  Spread('cross', 'Reflexionskreuz', [
    'Der Kern',
    'Was ihn kreuzt',
    'Die Grundlage',
    'Was vergeht',
    'Das bewusste Ziel',
    'Der nächste Schritt',
    'Meine Haltung',
    'Mein Umfeld',
    'Hoffnungen und Ängste',
    'Eine mögliche Richtung',
  ], pro: true),
  Spread('yesno', 'Ja oder Nein', ['Die Antwort']),
  Spread('decision', 'Entscheidung A/B', [
    'Der Kern der Entscheidung',
    'Weg A',
    'Wohin A führt',
    'Weg B',
    'Wohin B führt',
  ]),
  Spread('month', 'Monat', [
    'Woche 1',
    'Woche 2',
    'Woche 3',
    'Woche 4',
    'Rat für den Monat',
  ]),
  Spread('year', 'Jahr', [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ], pro: true),
];

const _spreadsFr = [
  Spread('one', 'Une carte', ['Ce qui mérite votre attention aujourd’hui']),
  Spread('three', 'Trois cartes', [
    'La situation',
    'Une perspective possible',
    'La prochaine étape',
  ]),
  Spread('five', 'Cinq cartes', [
    'Le cœur du sujet',
    'Ce qui me soutient',
    'Ce qui me freine',
    'Ce que je ne vois pas',
    'Ce que je peux faire',
  ]),
  Spread('relation', 'Relation', [
    'Moi dans cette relation',
    'Comment je vois l’autre',
    'Ce qui nous unit',
    'Ce qui nous distingue',
    'Ce dont j’ai besoin',
    'Ce que je peux offrir',
  ], pro: true),
  Spread('cross', 'Croix de réflexion', [
    'Le cœur',
    'Ce qui le croise',
    'Le fondement',
    'Ce qui s’éloigne',
    'Le but conscient',
    'La prochaine étape',
    'Mon attitude',
    'Mon entourage',
    'Espoirs et craintes',
    'Une direction possible',
  ], pro: true),
  Spread('yesno', 'Oui ou non', ['La réponse']),
  Spread('decision', 'Décision A/B', [
    'Le cœur de la décision',
    'Voie A',
    'Où mène A',
    'Voie B',
    'Où mène B',
  ]),
  Spread('month', 'Mois', [
    'Semaine 1',
    'Semaine 2',
    'Semaine 3',
    'Semaine 4',
    'Conseil pour le mois',
  ]),
  Spread('year', 'Année', [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ], pro: true),
];

const _spreadsEs = [
  Spread('one', 'Una carta', ['A qué conviene prestar atención hoy']),
  Spread('three', 'Tres cartas', [
    'La situación',
    'Una perspectiva posible',
    'El siguiente paso',
  ]),
  Spread('five', 'Cinco cartas', [
    'El fondo del asunto',
    'Lo que me apoya',
    'Lo que me frena',
    'Lo que no veo',
    'Lo que puedo hacer',
  ]),
  Spread('relation', 'Relación', [
    'Yo en esta relación',
    'Cómo veo a la otra persona',
    'Lo que nos une',
    'Lo que nos diferencia',
    'Lo que necesito',
    'Lo que puedo ofrecer',
  ], pro: true),
  Spread('cross', 'Cruz de reflexión', [
    'El centro',
    'Lo que lo cruza',
    'La base',
    'Lo que se va',
    'El objetivo consciente',
    'El paso más cercano',
    'Mi actitud',
    'Mi entorno',
    'Esperanzas y miedos',
    'Una dirección posible',
  ], pro: true),
  Spread('yesno', 'Sí o no', ['La respuesta']),
  Spread('decision', 'Decisión A/B', [
    'El fondo de la decisión',
    'Camino A',
    'Adónde lleva A',
    'Camino B',
    'Adónde lleva B',
  ]),
  Spread('month', 'Mes', [
    'Semana 1',
    'Semana 2',
    'Semana 3',
    'Semana 4',
    'Consejo para el mes',
  ]),
  Spread('year', 'Año', [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ], pro: true),
];

const _spreadsUk = [
  Spread('one', 'Одна карта', ['На що варто звернути увагу сьогодні']),
  Spread('three', 'Три карти', [
    'Ситуація',
    'Можливий погляд',
    'Наступний крок',
  ]),
  Spread('five', 'П’ять карт', [
    'Суть справи',
    'Що мене підтримує',
    'Що мене стримує',
    'Чого я не бачу',
    'Що я можу зробити',
  ]),
  Spread('relation', 'Стосунки', [
    'Я в цих стосунках',
    'Як я бачу іншу людину',
    'Що нас поєднує',
    'Що нас відрізняє',
    'Чого я потребую',
    'Що я можу запропонувати',
  ], pro: true),
  Spread('cross', 'Хрест роздумів', [
    'Суть',
    'Що її перетинає',
    'Основа',
    'Що відходить',
    'Свідома мета',
    'Найближчий крок',
    'Моя позиція',
    'Оточення',
    'Надії та страхи',
    'Можливий напрям',
  ], pro: true),
  Spread('yesno', 'Так чи ні', ['Відповідь']),
  Spread('decision', 'Рішення А/Б', [
    'Суть рішення',
    'Шлях А',
    'Куди веде А',
    'Шлях Б',
    'Куди веде Б',
  ]),
  Spread('month', 'Місяць', [
    'Тиждень 1',
    'Тиждень 2',
    'Тиждень 3',
    'Тиждень 4',
    'Порада на місяць',
  ]),
  Spread('year', 'Рік', [
    'Січень',
    'Лютий',
    'Березень',
    'Квітень',
    'Травень',
    'Червень',
    'Липень',
    'Серпень',
    'Вересень',
    'Жовтень',
    'Листопад',
    'Грудень',
  ], pro: true),
];

const _spreadsIt = [
  Spread('one', 'Una carta', ['A cosa vale la pena prestare attenzione oggi']),
  Spread('three', 'Tre carte', [
    'La situazione',
    'Una prospettiva possibile',
    'Il passo successivo',
  ]),
  Spread('five', 'Cinque carte', [
    'Il cuore della questione',
    'Ciò che mi sostiene',
    'Ciò che mi frena',
    'Ciò che non vedo',
    'Ciò che posso fare',
  ]),
  Spread('relation', 'Relazione', [
    'Io in questa relazione',
    'Come vedo l’altra persona',
    'Ciò che ci unisce',
    'Ciò che ci distingue',
    'Ciò di cui ho bisogno',
    'Ciò che posso offrire',
  ], pro: true),
  Spread('cross', 'Croce della riflessione', [
    'Il centro',
    'Ciò che lo attraversa',
    'La base',
    'Ciò che se ne va',
    'L’obiettivo consapevole',
    'Il passo più vicino',
    'Il mio atteggiamento',
    'Il mio ambiente',
    'Speranze e paure',
    'Una direzione possibile',
  ], pro: true),
  Spread('yesno', 'Sì o no', ['La risposta']),
  Spread('decision', 'Decisione A/B', [
    'Il cuore della decisione',
    'Strada A',
    'Dove porta A',
    'Strada B',
    'Dove porta B',
  ]),
  Spread('month', 'Mese', [
    'Settimana 1',
    'Settimana 2',
    'Settimana 3',
    'Settimana 4',
    'Consiglio per il mese',
  ]),
  Spread('year', 'Anno', [
    'Gennaio',
    'Febbraio',
    'Marzo',
    'Aprile',
    'Maggio',
    'Giugno',
    'Luglio',
    'Agosto',
    'Settembre',
    'Ottobre',
    'Novembre',
    'Dicembre',
  ], pro: true),
];

const _spreadsPt = [
  Spread('one', 'Uma carta', ['A que vale a pena prestar atenção hoje']),
  Spread('three', 'Três cartas', [
    'A situação',
    'Uma perspectiva possível',
    'O próximo passo',
  ]),
  Spread('five', 'Cinco cartas', [
    'O cerne da questão',
    'O que me apoia',
    'O que me trava',
    'O que eu não vejo',
    'O que eu posso fazer',
  ]),
  Spread('relation', 'Relacionamento', [
    'Eu neste relacionamento',
    'Como vejo a outra pessoa',
    'O que nos une',
    'O que nos diferencia',
    'De que eu preciso',
    'O que eu posso oferecer',
  ], pro: true),
  Spread('cross', 'Cruz da reflexão', [
    'O centro',
    'O que o atravessa',
    'A base',
    'O que está partindo',
    'O objetivo consciente',
    'O passo mais próximo',
    'Minha postura',
    'Meu entorno',
    'Esperanças e medos',
    'Uma direção possível',
  ], pro: true),
  Spread('yesno', 'Sim ou não', ['A resposta']),
  Spread('decision', 'Decisão A/B', [
    'O cerne da decisão',
    'Caminho A',
    'Aonde leva A',
    'Caminho B',
    'Aonde leva B',
  ]),
  Spread('month', 'Mês', [
    'Semana 1',
    'Semana 2',
    'Semana 3',
    'Semana 4',
    'Conselho para o mês',
  ]),
  Spread('year', 'Ano', [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ], pro: true),
];

const _spreadsNl = [
  Spread('one', 'Eén kaart', ['Waar het vandaag goed is op te letten']),
  Spread('three', 'Drie kaarten', [
    'De situatie',
    'Een mogelijk perspectief',
    'De volgende stap',
  ]),
  Spread('five', 'Vijf kaarten', [
    'De kern van de zaak',
    'Wat me steunt',
    'Wat me tegenhoudt',
    'Wat ik niet zie',
    'Wat ik kan doen',
  ]),
  Spread('relation', 'Relatie', [
    'Ik in deze relatie',
    'Hoe ik de ander zie',
    'Wat ons verbindt',
    'Wat ons onderscheidt',
    'Wat ik nodig heb',
    'Wat ik kan bieden',
  ], pro: true),
  Spread('cross', 'Reflectiekruis', [
    'Het midden',
    'Wat het kruist',
    'De basis',
    'Wat vertrekt',
    'Het bewuste doel',
    'De dichtstbijzijnde stap',
    'Mijn houding',
    'Mijn omgeving',
    'Hoop en angst',
    'Een mogelijke richting',
  ], pro: true),
  Spread('yesno', 'Ja of nee', ['Het antwoord']),
  Spread('decision', 'Beslissing A/B', [
    'De kern van de beslissing',
    'Weg A',
    'Waar A naartoe leidt',
    'Weg B',
    'Waar B naartoe leidt',
  ]),
  Spread('month', 'Maand', [
    'Week 1',
    'Week 2',
    'Week 3',
    'Week 4',
    'Advies voor de maand',
  ]),
  Spread('year', 'Jaar', [
    'Januari',
    'Februari',
    'Maart',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Augustus',
    'September',
    'Oktober',
    'November',
    'December',
  ], pro: true),
];
