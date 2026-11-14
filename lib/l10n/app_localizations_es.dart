// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Digi Witch';

  @override
  String get tabToday => 'Hoy';

  @override
  String get tabNumerology => 'Números';

  @override
  String get tabTarot => 'Tarot';

  @override
  String get tabLibrary => 'Biblioteca';

  @override
  String get tabJournal => 'Diario';

  @override
  String get settings => 'Ajustes';

  @override
  String get start => 'Empezar';

  @override
  String get onboardWhat =>
      'Tu guía diaria de símbolos: horóscopo del día, la Luna, tarot, numerología, tu signo chino y un diccionario de sueños. Cada cálculo se muestra paso a paso y cada carta se explica en la biblioteca.';

  @override
  String get onboardNot =>
      'Esta app es una herramienta de entretenimiento, de aprendizaje sobre simbolismo y de reflexión personal. No predice el futuro, no mide la personalidad en sentido científico ni sustituye el consejo de un profesional.';

  @override
  String get onboardPrivacy =>
      'No necesitas cuenta. Las fechas, los nombres y tu diario se quedan en este dispositivo.';

  @override
  String get onboardAdults => 'Esta app está dirigida a personas adultas.';

  @override
  String get reversed => 'invertida';

  @override
  String get writeReflection => 'Escribir una reflexión en el diario';

  @override
  String get exportJournal => 'Exportar diario';

  @override
  String get newEntry => 'Nueva entrada';

  @override
  String get editEntry => 'Entrada';

  @override
  String get journalEmpty =>
      'Tu diario está vacío. Escribe un primer pensamiento; puedes empezar por la pregunta del día o por una carta que hayas sacado.';

  @override
  String get journalPrivacy =>
      'Las entradas se guardan solo en este dispositivo.';

  @override
  String get deleteEntryConfirm =>
      '¿Eliminar esta entrada? No se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get linkedResult => 'Resultado vinculado';

  @override
  String get promptsTitle => 'Una pregunta para empezar (opcional)';

  @override
  String promptCategory(String c) {
    String _temp0 = intl.Intl.selectLogic(c, {
      'ogolne': 'General',
      'rodzina': 'Familia',
      'tarot': 'Tarot',
      'liczby': 'Números',
      'other': 'Otras',
    });
    return '$_temp0';
  }

  @override
  String get randomPrompt => 'Pregunta al azar';

  @override
  String get familyNote =>
      'Escribe solo lo que te apetezca compartir. Puedes usar apodos en lugar de los nombres de tus seres queridos.';

  @override
  String get entryHint => 'Tus pensamientos…';

  @override
  String get tarotIntro =>
      'Entendemos las cartas como una invitación a reflexionar, no como una predicción. Las posiciones de una tirada son preguntas que vale la pena hacerse.';

  @override
  String get drawCards => 'Sacar cartas';

  @override
  String get drawAgain => 'Volver a sacar';

  @override
  String get reversedOn =>
      'Cartas invertidas: activadas (cada carta por separado, con una probabilidad de 1 entre 2).';

  @override
  String get reversedOff =>
      'Cartas invertidas: desactivadas. Puedes activarlas en Ajustes.';

  @override
  String get spreadReflectionPrompt =>
      '¿Qué es lo que más me ha llegado de esta tirada y por qué?';

  @override
  String get questionLabel => 'Tu pregunta (opcional)';

  @override
  String get questionHint =>
      'p. ej., ¿qué debo tener en cuenta al cambiar de trabajo?';

  @override
  String get readingTitle => 'Lo que dicen las cartas sobre tu pregunta';

  @override
  String get readingTitleNoQuestion => 'Resumen de la tirada';

  @override
  String get summaryMajors =>
      'Predominan los Arcanos mayores: se trata de algo importante, que va más allá de las decisiones del día a día.';

  @override
  String summarySuit(String suit) {
    String _temp0 = intl.Intl.selectLogic(suit, {
      'wands': 'Sobre todo Bastos: de fondo están la energía, la acción y la iniciativa.',
      'cups': 'Sobre todo Copas: de fondo están las emociones, los sentimientos y las relaciones.',
      'swords': 'Sobre todo Espadas: de fondo están los pensamientos, las decisiones y las conversaciones difíciles.',
      'pentacles': 'Sobre todo Oros: de fondo están el trabajo, el dinero y los asuntos prácticos.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get summaryReversed =>
      'La mayoría de las cartas están invertidas: puede que algo esté bloqueado, retrasado o se viva más por dentro que por fuera.';

  @override
  String get summaryBalanced =>
      'Las cartas están repartidas de forma equilibrada: ningún ámbito predomina claramente.';

  @override
  String summaryAnswer(String position, String card, String advice) {
    return 'La respuesta de las cartas: $card en la posición «$position»: $advice';
  }

  @override
  String get addBookmark => 'Añadir marcador';

  @override
  String get removeBookmark => 'Quitar marcador';

  @override
  String get group => 'Grupo';

  @override
  String get keywords => 'Palabras clave';

  @override
  String get symbolism => 'Simbolismo';

  @override
  String get upright => 'Significado al derecho';

  @override
  String get reversedMeaning => 'Significado invertido';

  @override
  String get reflectionQuestions => 'Preguntas para reflexionar';

  @override
  String get reflectionQuestion => 'Pregunta para reflexionar';

  @override
  String get sourcesAndRights => 'Fuentes y derechos';

  @override
  String get cardSourceNote =>
      'Las descripciones de las cartas son textos originales escritos para esta app. Ilustración: Pamela Colman Smith (1878–1951), baraja publicada en 1909, de dominio público; escaneo de un ejemplar «Roses & Lilies» (Saskia Jansen), compartido en Wikimedia Commons. La imagen solo se ha redimensionado.';

  @override
  String get numerologyIntro =>
      'Introduce tu fecha de nacimiento y, si quieres, tu nombre completo. Guardados como perfil, desbloquean el horóscopo del día, tu número del día, tu tríada astral y tu signo chino. Los datos se quedan solo en este teléfono.';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get birthDateHelp => 'Solo cifras: día, mes, año, p. ej., 15071990';

  @override
  String get fullNameOptional => 'Nombre completo (opcional)';

  @override
  String get fullNameHelp =>
      'Solo hace falta para los números que se calculan a partir de letras. Se admiten tildes y la ñ; los espacios, guiones y apóstrofos se omiten.';

  @override
  String get personalYearFor => 'Año personal para:';

  @override
  String get previousYear => 'Año anterior';

  @override
  String get nextYear => 'Año siguiente';

  @override
  String get calculate => 'Calcular';

  @override
  String get saveAsProfile => 'Guardar como mi perfil';

  @override
  String get profileSaved => 'Guardado en este dispositivo.';

  @override
  String get portrait => 'Retrato numerológico';

  @override
  String get portraitNote =>
      'Despliega un número para ver el cálculo y su interpretación simbólica. Los resultados siguen la convención descrita en la biblioteca («Cómo calculamos»).';

  @override
  String indicatorName(String name) {
    String _temp0 = intl.Intl.selectLogic(name, {
      'lifePath': 'Camino de vida',
      'birthDay': 'Número del día de nacimiento',
      'expression': 'Número de expresión',
      'soulUrge': 'Número del alma',
      'personality': 'Número de personalidad',
      'personalYear': 'Año personal',
      'personalDay': 'Número del día',
      'relation': 'Número de la relación',
      'personalMonth': 'Mes personal',
      'maturity': 'Número de madurez',
      'house': 'Número de la casa',
      'other': 'Número',
    });
    return '$_temp0';
  }

  @override
  String get noBasis => 'No hay nada que calcular';

  @override
  String get calculation => 'Cálculo';

  @override
  String get symbolicInterpretation => 'Interpretación simbólica';

  @override
  String get enterDateOrName =>
      'Introduce una fecha de nacimiento o un nombre completo.';

  @override
  String get dateInvalid => 'Esa fecha no existe. Comprueba el día y el mes.';

  @override
  String get dateFuture => 'La fecha no puede estar en el futuro.';

  @override
  String get nameNoLetters => 'Introduce al menos una letra.';

  @override
  String nameUnsupported(String chars) {
    return 'Caracteres no admitidos: $chars. Introduce la grafía en alfabeto latino (transliteración) que quieres usar para el cálculo.';
  }

  @override
  String get cardOfDay => 'Carta del día';

  @override
  String get cardOfDayNote =>
      'La carta del día no cambia hasta que termina el día, según el reloj de este dispositivo.';

  @override
  String get promptOfDay => 'Pregunta del día';

  @override
  String yourPersonalYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return 'Tu año personal $yearString';
  }

  @override
  String get search => 'Buscar cartas, términos, artículos';

  @override
  String get bookmarks => 'Marcadores';

  @override
  String get articles => 'Artículos';

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
  String get archetypes => 'Arquetipos';

  @override
  String get archetypesNote =>
      'Los 12 arquetipos son un modelo editorial propio de esta app: una de muchas formas posibles de clasificar, no un canon ni un test psicológico.';

  @override
  String get aboutModel => 'Sobre el modelo';

  @override
  String get archetypeGifts => 'Dones';

  @override
  String get archetypeShadow => 'Sombra';

  @override
  String get glossary => 'Glosario';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get allowReversed => 'Cartas invertidas';

  @override
  String get allowReversedRule =>
      'Si está activado, cada carta que sacas se invierte por separado con una probabilidad de 1 entre 2.';

  @override
  String get profile => 'Mi perfil';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyBody =>
      'No creamos cuentas ni enviamos tus fechas, nombres o entradas a ningún servidor. Tus datos están solo en este dispositivo, salvo que los exportes tú.';

  @override
  String get deleteAllTitle => 'Eliminar todos los datos';

  @override
  String get deleteAllBody =>
      'Borraremos de este dispositivo tu diario, tu perfil, tus marcadores, la carta del día y los ajustes. No se puede deshacer.';

  @override
  String get sourcesBody =>
      'Las interpretaciones, preguntas, arquetipos y artículos son textos originales. Ilustraciones de las cartas: Pamela Colman Smith, baraja de 1909 (dominio público), escaneos de Wikimedia Commons; los detalles figuran junto a cada carta. Las fuentes históricas se citan al final de los artículos.';

  @override
  String get purchases => 'Digi Witch Pro';

  @override
  String get help => 'Ayuda';

  @override
  String get helpBody =>
      'Si estás pasando por una crisis, contacta con un profesional de la salud mental o con una línea de ayuda: en España, el 024 (atención a la conducta suicida), gratuito y disponible las 24 horas. En caso de emergencia, llama al 112.';

  @override
  String get versions => 'Versiones';

  @override
  String get algorithm => 'algoritmo';

  @override
  String get contentVer => 'contenidos';

  @override
  String get disclaimer =>
      'Este contenido es para entretenimiento, aprendizaje y reflexión personal. No constituye asesoramiento médico, psicológico, jurídico ni financiero.';

  @override
  String get proShort => 'Compra única: sin anuncios, tiradas adicionales.';

  @override
  String get proTitle => 'Digi Witch Pro';

  @override
  String get proBenefits =>
      '• Sin anuncios en toda la app\n• Tiradas adicionales: «Relación» (6 cartas) y «Cruz de reflexión» (10 cartas)\n• Pago único, sin suscripción';

  @override
  String get proFreeStays =>
      'La numerología, la carta del día, las tiradas de 1, 3 y 5 cartas, la biblioteca y el diario siguen siendo gratuitos. Comprar Pro no influye en qué cartas salen ni en cómo se calculan los resultados.';

  @override
  String get proActive => 'Tienes Pro. ¡Gracias!';

  @override
  String get proUnavailable =>
      'Ahora mismo no se puede comprar. Comprueba tu conexión a internet y vuelve a intentarlo más tarde.';

  @override
  String proBuy(String price) {
    return 'Comprar Pro por $price';
  }

  @override
  String get purchaseError =>
      'La compra no se ha completado. No se te ha cobrado nada, salvo que la tienda haya confirmado la transacción.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get proOnly => 'Disponible en Pro';

  @override
  String get adPrivacyOptions => 'Privacidad de los anuncios';

  @override
  String get reminder => 'Recordatorio diario';

  @override
  String get reminderOff => 'Desactivado';

  @override
  String reminderAt(String time) {
    return 'Todos los días a las $time';
  }

  @override
  String get reminderTitle => 'Digi Witch';

  @override
  String get reminderBody => 'Un momento para reflexionar, si te apetece.';

  @override
  String get reminderDenied =>
      'Las notificaciones no están permitidas. Puedes permitirlas en los ajustes del sistema.';

  @override
  String get proStoreNote =>
      'El pago y los posibles reembolsos los gestionan App Store o Google Play según sus propias normas. La compra funciona tanto si aceptas los anuncios como si no.';

  @override
  String get horoscopeToday => 'Hoy';

  @override
  String get horoscopeStars => 'Los astros dicen';

  @override
  String get horoscopeCaution => 'Cuidado con';

  @override
  String moonIn(String sign, String phase) {
    return 'Luna en $sign, $phase.';
  }

  @override
  String get luckyNumbers => 'Números de la suerte del día';

  @override
  String get luckyNote =>
      'Por diversión: los números salen de tu fecha de nacimiento y de la fecha de hoy, así que no cambian en todo el día. No predicen premios.';

  @override
  String get whyThis => 'De dónde sale esto';

  @override
  String whySign(
    String sign,
    String dates,
    String element,
    String chinese,
    String chineseText,
  ) {
    return 'Tu signo: $sign ($dates), elemento: $element. Signo chino: $chinese. $chineseText';
  }

  @override
  String whyMoon(String sign, String element, String relation) {
    String _temp0 = intl.Intl.selectLogic(relation, {
      'same': 'el mismo elemento',
      'supportive': 'favorable',
      'tense': 'tensa',
      'other': 'neutra',
    });
    return 'Hoy a mediodía la Luna está en $sign (elemento: $element). Relación con tu elemento: $_temp0.';
  }

  @override
  String get whyMethod =>
      'La posición de la Luna se calcula sin conexión con fórmulas astronómicas (precisión de unos 0,5°). El texto «Hoy» depende de la relación entre los elementos, «Los astros dicen» de la fase lunar y «Cuidado con» de tu número del día.';

  @override
  String get horoscopeNeedsBirth =>
      'Introduce tu fecha de nacimiento y verás al momento tu signo, el horóscopo del día, tu número del día y tus números de la suerte.';

  @override
  String get moonToday => 'La Luna hoy';

  @override
  String moonState(String phase, int percent, String sign) {
    return '$phase · $percent % iluminada · en $sign';
  }

  @override
  String get moonCalendar => 'Calendario lunar';

  @override
  String get moonCalendarIntro =>
      'Las próximas fases principales de la Luna, en hora local (con una precisión de 1 hora aproximadamente).';

  @override
  String get compatibility => 'Compatibilidad de dos personas';

  @override
  String get compatIntro =>
      'Introduce dos fechas de nacimiento. Compararemos signos del zodiaco, elementos, signos chinos y caminos de vida. Es un juego y una forma de empezar una conversación, no un veredicto sobre una relación.';

  @override
  String personDate(int n) {
    return 'Fecha de nacimiento: persona $n';
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
    return 'Persona $n: $sign ($element) · signo chino: $chinese · camino de vida $lifePath';
  }

  @override
  String get birthCardTitle => 'Carta de nacimiento';

  @override
  String get birthCardNote =>
      'Método: día + mes + año de nacimiento; después se suman las cifras hasta que el resultado no supere 22 (22 = El Loco). Un resultado de dos cifras da además una carta compañera.';

  @override
  String get birthCardSecond => 'Carta compañera';

  @override
  String yesNoAnswer(String a) {
    String _temp0 = intl.Intl.selectLogic(a, {
      'yes': 'La respuesta de las cartas: SÍ',
      'no': 'La respuesta de las cartas: NO',
      'other':
          'La respuesta de las cartas: INCIERTA. El asunto aún está en el aire',
    });
    return '$_temp0';
  }

  @override
  String get horoscopeFor => 'Hoy para ti';

  @override
  String get licenses => 'Licencias (fuentes y bibliotecas)';

  @override
  String get cardAdvice => 'El consejo de la carta';

  @override
  String get correspondences =>
      'Correspondencias astrológicas (Golden Dawn, siglo XIX)';

  @override
  String get chooseSpread => 'Elige una tirada';

  @override
  String get tapDeck => 'Piensa en tu pregunta y toca la baraja';

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
  String get bigThree => 'Tu tríada astral';

  @override
  String get bigThreeIntro =>
      'El Sol es tu signo del zodiaco. La Luna describe tus emociones y el ascendente, cómo te ven los demás. Para la Luna suele bastar la fecha; el ascendente necesita la hora y el lugar de nacimiento. Los datos se quedan solo en este dispositivo.';

  @override
  String get birthTime => 'Hora de nacimiento';

  @override
  String get notGiven => 'sin indicar';

  @override
  String get birthPlace => 'Lugar de nacimiento';

  @override
  String get placesNote =>
      'Ciudades de Polonia y grandes ciudades del mundo. Si no está la tuya, elige la más cercana del mismo país o introduce coordenadas. Unas decenas de kilómetros cambian el ascendente menos de 1°.';

  @override
  String get sunLabel => 'Sol';

  @override
  String get moonLabel => 'Luna';

  @override
  String get ascLabel => 'Ascendente';

  @override
  String moonTwoSigns(String a, String b) {
    return 'Ese día la Luna cambió de signo: $a o $b, según la hora de nacimiento.';
  }

  @override
  String get ascNeeds =>
      'Introduce la hora y el lugar de nacimiento para calcular el ascendente.';

  @override
  String traceTime(String local, String utc, String zone) {
    return 'Hora local $local → $utc UTC (zona $zone, con el historial del horario de verano).';
  }

  @override
  String traceMoon(String deg, String sign) {
    return 'Longitud eclíptica de la Luna: $deg° → $sign.';
  }

  @override
  String traceAsc(
    String deg,
    String sign,
    String place,
    String lat,
    String lon,
  ) {
    return 'Ascendente: $deg° → $sign ($place, $lat° N, $lon° E).';
  }

  @override
  String get needBirthDate =>
      'Primero guarda tu fecha de nacimiento en la pestaña Números (botón «Guardar como mi perfil»).';

  @override
  String get clear => 'Borrar';

  @override
  String get chineseTitle => 'Horóscopo chino';

  @override
  String chineseBirthYear(int year, String element, String yy) {
    String _temp0 = intl.Intl.selectLogic(yy, {'yang': 'yang', 'other': 'yin'});
    return 'Año en el calendario chino: $year · $element · $_temp0';
  }

  @override
  String get chineseNewYearNote =>
      'El Año Nuevo chino cae entre el 21 de enero y el 20 de febrero. Si naciste antes, te corresponde el signo del año anterior. Aquí ya se tiene en cuenta.';

  @override
  String chineseCurrentYear(int year, String animal, String element) {
    return 'Año $year: $animal · $element';
  }

  @override
  String chineseYearSince(String date) {
    return 'El año chino actual empezó el $date.';
  }

  @override
  String get chineseCompatTitle => 'Compatibilidad de los signos chinos';

  @override
  String get chineseFriend => 'Amigo secreto';

  @override
  String get chineseTrine => 'Trígono de aliados';

  @override
  String get chineseClash => 'Signo opuesto';

  @override
  String get chineseElement => 'Elemento del año de nacimiento';

  @override
  String get mercuryRetro => 'Mercurio retrógrado';

  @override
  String mercuryNow(String date) {
    return 'Mercurio retrógrado hasta el $date';
  }

  @override
  String get mercuryNone => 'No hay periodos retrógrados en el próximo año.';

  @override
  String get upcomingPhases => 'Próximas fases';

  @override
  String get dayByDay => 'Día a día (30 días)';

  @override
  String moonDayLine(String sign, String phase) {
    return 'Luna en $sign · $phase';
  }

  @override
  String get dreams => 'Diccionario de sueños';

  @override
  String dreamsCount(int n) {
    return '$n símbolos oníricos: lo que un sueño puede decirte sobre ti';
  }

  @override
  String get dreamsIntro =>
      'Los sueños no predicen el futuro. El diccionario indica con qué se suele asociar un símbolo, y la pregunta te ayuda a ver qué significa para ti. Lo más importante es cómo te sentiste en el sueño.';

  @override
  String get dreamsSearch => 'Busca un símbolo, p. ej., agua, dientes, casa';

  @override
  String get dreamsEmpty =>
      'No existe ese símbolo. Prueba con una palabra parecida o anota el sueño en tu diario.';

  @override
  String chineseSignButton(String animal) {
    return 'Signo chino: $animal';
  }

  @override
  String get otherPlace => 'Otro lugar: introducir coordenadas';

  @override
  String otherPlaceSet(String place, String zone) {
    return 'Otro lugar: $place ($zone)';
  }

  @override
  String get otherPlaceHelp =>
      'Puedes encontrar las coordenadas en una app de mapas (por ejemplo, tocando un lugar en Google Maps). El sur y el oeste se introducen con signo menos. La zona horaria es una región, p. ej., Europe/Madrid, America/Mexico_City.';

  @override
  String get latitude => 'Latitud';

  @override
  String get longitude => 'Longitud';

  @override
  String get timeZone => 'Zona horaria';

  @override
  String get otherPlaceMissing =>
      'Introduce la latitud, la longitud y la zona horaria.';

  @override
  String get otherPlaceRange =>
      'La latitud debe estar entre -66° y 66° (más allá de los círculos polares el ascendente puede quedar indefinido) y la longitud entre -180° y 180°.';

  @override
  String get numbersStartTitle => 'Empieza por tu fecha de nacimiento';

  @override
  String get numbersEditTitle => 'Cambiar datos o calcular para otra persona';

  @override
  String get calculateOnce => 'Solo calcular (sin guardar)';

  @override
  String get compatibilityHint => 'Comparar dos fechas de nacimiento';

  @override
  String get yourNumbers => 'Tus números';

  @override
  String get editOrOther => 'Cambiar datos o calcular para otra persona';

  @override
  String get showMyHoroscope => 'Ver mi horóscopo';

  @override
  String get privacyShort =>
      'La fecha se queda solo en este teléfono. Puedes cambiarla en la pestaña Números.';

  @override
  String get explore => 'Explorar';

  @override
  String get exploreBigThree => 'Sol, Luna y ascendente';

  @override
  String get exploreChinese => 'Signo, elemento y tu año';

  @override
  String get exploreTarot => 'Pregunta a las cartas';

  @override
  String get exploreTarotSub => 'Tiradas y preguntas de sí o no';

  @override
  String get exploreNumbersSub => 'Camino de vida y carta de nacimiento';

  @override
  String get exploreMoon => 'Fases, jardinería, Mercurio retrógrado';

  @override
  String get exploreDreams => 'Lo que dice tu sueño';

  @override
  String get exploreLibrary =>
      '78 cartas, artículos, glosario: en la biblioteca';

  @override
  String get exploreLibraryTitle => 'Cartas y artículos';

  @override
  String get squareTitle => 'Cuadrado de Pitágoras';

  @override
  String get squareIntro =>
      'Una cuadrícula con las cifras de tu fecha de nacimiento (método de Aleksándrov): cuanto más se repite una cifra, más fuerte es el rasgo. Toca una casilla para leer su descripción.';

  @override
  String get squareEmpty => 'ninguna';

  @override
  String get cyclesTitle => 'Ciclos de vida: cimas y desafíos';

  @override
  String get cyclesIntro =>
      'La numerología divide la vida en cuatro etapas. Cada una tiene su «cima», un tema de crecimiento, y su «desafío», una lección por trabajar. La duración de la primera etapa depende de tu camino de vida.';

  @override
  String ageRange(int from, int to) {
    return 'de $from a $to años';
  }

  @override
  String ageFrom(int from) {
    return 'desde los $from años';
  }

  @override
  String get cyclesNow => 'AHORA';

  @override
  String get ichingTitle => 'Oráculo del I Ching';

  @override
  String get ichingIntro =>
      'El Libro de las Mutaciones es un oráculo chino clásico. Piensa en tu pregunta y lanza tres monedas seis veces; el hexagrama se construye de abajo arriba. Las líneas marcadas con un punto son «mutables» y muestran en qué se está convirtiendo la situación.';

  @override
  String ichingToss(int n) {
    return 'Lanzar las monedas ($n/6)';
  }

  @override
  String ichingLastToss(String sum) {
    String _temp0 = intl.Intl.selectLogic(sum, {
      '6': 'cruz, cruz, cruz = 6 (yin viejo, mutable)',
      '7': 'dos cruces y una cara = 7 (yang)',
      '8': 'dos caras y una cruz = 8 (yin)',
      'other': 'cara, cara, cara = 9 (yang viejo, mutable)',
    });
    return 'Última tirada: $_temp0';
  }

  @override
  String get ichingMeaning => 'Significado';

  @override
  String get ichingChange => 'Dirección del cambio';

  @override
  String ichingChangingLines(String lines) {
    return 'Líneas mutables: $lines. La situación se transforma en:';
  }

  @override
  String get ichingAgain => 'Nueva pregunta';

  @override
  String get ichingNote =>
      'Las descripciones de los hexagramas y las líneas son interpretaciones breves propias de esta app, inspiradas en las imágenes del antiguo texto chino. Tómalas como una invitación a reflexionar.';

  @override
  String get exploreIching => 'Una pregunta y seis lanzamientos de monedas';

  @override
  String get ritualsTitle => 'Rituales lunares';

  @override
  String get exploreRituals => 'Intenciones para la luna nueva y la llena';

  @override
  String get ritualsIntro =>
      'La luna nueva y la luna llena marcan el ritmo del mes. Escribe una intención en luna nueva y, en luna llena, mira atrás para ver qué ha pasado. Tus entradas se guardan en el diario.';

  @override
  String get moonRemindersToggle => 'Recordarme la luna nueva y la llena';

  @override
  String get moonRemindersNote =>
      'Una notificación a las 9:00 el día de luna nueva y de luna llena. Funciona sin conexión.';

  @override
  String get moonReminderNewTitle => 'Luna nueva: momento de una intención';

  @override
  String get moonReminderNewBody =>
      'Escribe lo que quieres empezar en este ciclo.';

  @override
  String get moonReminderFullTitle => 'Luna llena: momento de hacer balance';

  @override
  String get moonReminderFullBody =>
      '¿Qué ha ido bien desde la luna nueva? ¿Qué agradeces?';

  @override
  String get forYouToday => 'Solo para ti';

  @override
  String get advice => 'Consejo';

  @override
  String get karmicTitle => 'El karma en números';

  @override
  String get karmicIntro =>
      'Las deudas kármicas son los números 13, 14, 16 y 19 que aparecen al calcular tus números. Las lecciones kármicas son las cifras que faltan en tu nombre completo. En la tradición describen temas por trabajar, no veredictos.';

  @override
  String get karmicNone => 'No hay deudas kármicas en tus números.';

  @override
  String get karmicLessonsTitle =>
      'Lecciones kármicas (cifras que faltan en tu nombre)';

  @override
  String get houseTitle => 'Numerología de la casa y el teléfono';

  @override
  String get houseHint => 'Número de casa, piso o teléfono, p. ej., 12A';

  @override
  String luckyMeaning(int n, int reduced, String keywords) {
    return '$n → $reduced: $keywords';
  }

  @override
  String dayColor(String color) {
    return 'Color del día: $color';
  }

  @override
  String signExtras(String color, String stone, String day, String planet) {
    return 'Color: $color · piedra: $stone · día: $day · planeta: $planet';
  }

  @override
  String get periodTitle => 'Horóscopo de la semana y del mes';

  @override
  String get explorePeriod => 'Días clave y tu mes personal';

  @override
  String get periodIntro =>
      'Calculado a partir del cielo real: las fases de la Luna, los eclipses, Mercurio retrógrado, la entrada del Sol en el signo siguiente y los días en que la Luna está en tu signo, además de tus números personales.';

  @override
  String get tabWeek => 'Semana';

  @override
  String get tabMonth => 'Mes';

  @override
  String get weekGeneral => 'En general';

  @override
  String get keyDays => 'Días clave';

  @override
  String get noKeyDays =>
      'No hay acontecimientos especiales en el cielo durante este periodo. Es un buen momento para trabajar con calma y constancia.';

  @override
  String evPhase(String phase) {
    return '$phase';
  }

  @override
  String evMoonInSign(String sign) {
    return 'Luna en tu signo ($sign)';
  }

  @override
  String evSunIngress(String sign) {
    return 'El Sol entra en $sign';
  }

  @override
  String get evMercuryStart => 'Mercurio se vuelve retrógrado';

  @override
  String get evMercuryEnd => 'Mercurio vuelve a ser directo';

  @override
  String evEclipse(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'solar': 'Eclipse solar',
      'partial': 'Eclipse lunar (parcial o total)',
      'other': 'Eclipse lunar penumbral (sutil)',
    });
    return '$_temp0';
  }

  @override
  String dayNumberLine(int n, String title) {
    return 'Número del día $n: $title';
  }

  @override
  String get eclipsesTitle => 'Eclipses del próximo año';

  @override
  String get eclipseVisibility =>
      'La visibilidad depende de dónde estés en la Tierra: no todos los eclipses se ven desde tu ubicación.';

  @override
  String eclipseSoon(String when) {
    return 'Se acerca un eclipse: $when';
  }

  @override
  String get loveLabel => 'Amor';

  @override
  String get workLabel => 'Trabajo';

  @override
  String get wellbeingLabel => 'Bienestar';

  @override
  String ichingImage(String upper, String lower) {
    return 'Imagen: $upper sobre $lower';
  }

  @override
  String get ichingLinesTitle => 'Líneas mutables';

  @override
  String ichingLine(int n, String text) {
    return 'Línea $n: $text';
  }

  @override
  String get revealCard => 'Descubrir la carta';

  @override
  String get revealCardHint => 'Toca la carta para ver qué te trae el día.';

  @override
  String get cardOfDayMore => 'Más sobre la carta';

  @override
  String get moodQuestion => '¿Cómo te sientes hoy?';

  @override
  String moodName(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Fatal',
      '2': 'Bajo',
      '3': 'Regular',
      '4': 'Bien',
      'other': 'Genial',
    });
    return '$_temp0';
  }

  @override
  String get moodSaved => 'Guardado solo en este dispositivo.';

  @override
  String countdown(String what, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'en $days días',
      one: 'mañana',
      zero: 'hoy',
    );
    return '$what $_temp0';
  }

  @override
  String get yourBirthday => 'Tu cumpleaños';

  @override
  String notifMoon(String sign) {
    return 'Luna en $sign';
  }

  @override
  String notifDayNumber(int n) {
    return 'número del día $n';
  }

  @override
  String get notifCard => 'tu carta del día te espera';

  @override
  String get tabStars => 'Astros';

  @override
  String get starsMore => 'Más de los astros';

  @override
  String get deckTitle => 'La baraja';

  @override
  String get fullHoroscope => 'Horóscopo completo';

  @override
  String get upcoming => 'Próximamente';

  @override
  String get suggested => 'Sugerencias de hoy';

  @override
  String get suggestBigThree =>
      'Añade la hora y el lugar de nacimiento para descubrir tu Luna y tu ascendente';

  @override
  String get dayNumberShort => 'número del día';

  @override
  String get dayColorShort => 'color del día';

  @override
  String get fullNumerology => 'Numerología completa y retrato';

  @override
  String get firstEntry => 'Escribir un primer pensamiento';

  @override
  String get greetDay => 'Buenos días';

  @override
  String get greetEvening => 'Buenas noches';

  @override
  String get dayHoroscope => 'Horóscopo';

  @override
  String get dayNumbers => 'Mis números';

  @override
  String get dayCard => 'Carta';

  @override
  String get dayDone => 'Por hoy, todo listo.';

  @override
  String tomorrowIs(String what) {
    return 'Mañana: $what.';
  }

  @override
  String tomorrowMoon(String sign) {
    return 'Mañana: Luna en $sign.';
  }

  @override
  String tomorrowNumber(int n) {
    return 'Mañana: una carta nueva y el número del día $n.';
  }

  @override
  String get tomorrowCard => 'Mañana: una nueva carta del día.';

  @override
  String get tabDreams => 'Sueños';

  @override
  String get dreamAsk => '¿Qué has soñado esta noche?';

  @override
  String get dreamAskHint =>
      'Anota el sueño antes de que se desvanezca o busca un símbolo abajo.';

  @override
  String get dreamSave => 'Anotar el sueño';

  @override
  String get dreamEntry => 'Sueño';

  @override
  String get dreamOfDay => 'Símbolo del día';

  @override
  String get dreamsAll => 'Todos los símbolos';

  @override
  String get widgetCardWaiting => 'Esperando a ser descubierta';

  @override
  String get widgetStale => 'Toca para ver tu día';

  @override
  String widgetCardSays(String advice) {
    return 'La carta dice: $advice';
  }

  @override
  String get widgetNeedBirth =>
      'Introduce tu fecha de nacimiento para ver tu día.';

  @override
  String get language => 'Idioma';

  @override
  String get dateHint => 'DD.MM.AAAA';

  @override
  String get layTarot => 'Hacer una tirada';

  @override
  String get tarotWelcomeTitle => '¿Qué sugieren hoy las cartas?';

  @override
  String get tarotWelcomeBody =>
      'Piensa en lo que te ocupa, elige una tirada y descubre las cartas. Cada tirada es una mirada nueva. Vuelve cuando surja otra pregunta.';

  @override
  String get seeDeck => 'Ver la baraja';

  @override
  String get tarotWelcomeSetting => 'Introducción en la pestaña Tarot';

  @override
  String get hide => 'Ocultar';

  @override
  String get tapHint => 'toca';

  @override
  String get dailyMood => 'Cómo puedes sentirte hoy';

  @override
  String get dailyEvents => 'Lo que puede traerte el día';

  @override
  String get dailyAdvice => 'Consejo para hoy';

  @override
  String get energyLabel => 'Energía';

  @override
  String meterValue(String label, int n) {
    return '$label: $n de 5';
  }

  @override
  String get cheerAll => 'Un día precioso — las estrellas están de tu lado';

  @override
  String get cheerLove => 'Un buen día para el corazón';

  @override
  String get cheerWork => 'Un buen día para ponerse manos a la obra';

  @override
  String get cheerEnergy => 'Un día lleno de energía';

  @override
  String get cheerUpLove => 'En el amor, mejor que ayer';

  @override
  String get cheerUpWork => 'En el trabajo, mejor que ayer';

  @override
  String get cheerUpEnergy => 'Más energía que ayer';

  @override
  String get cheerNewMoon =>
      'Luna nueva — buen momento para una nueva intención';

  @override
  String get cheerWaxing => 'La Luna crece y tus planes con ella';

  @override
  String get cheerFullMoon =>
      'Luna llena — momento de valorar lo que ya tienes';

  @override
  String get cheerWaning => 'La Luna mengua — es más fácil soltar lo que pesa';

  @override
  String get cheerNewMoon2 =>
      'Luna nueva — una página en blanco. Escribe en ella algo bueno';

  @override
  String get cheerNewMoon3 =>
      'Luna nueva — en la calma nacen las mejores ideas';

  @override
  String get cheerWaxing2 =>
      'La Luna crece — buen momento para sumar pequeños pasos';

  @override
  String get cheerWaxing3 => 'La Luna creciente favorece lo que empiezas';

  @override
  String get cheerFullMoon2 =>
      'Luna llena — hoy se ve más. También lo que te ha salido bien';

  @override
  String get cheerFullMoon3 =>
      'Luna llena — buena noche para celebrar las cosas pequeñas';

  @override
  String get cheerWaning2 =>
      'La Luna mengua — buen momento para ordenar y respirar';

  @override
  String get cheerWaning3 =>
      'La Luna menguante favorece el descanso y cerrar asuntos';

  @override
  String get threeGood => 'Apuntar tres cosas buenas';

  @override
  String get threeGoodPrompt =>
      'Tres cosas buenas de esta semana — y qué hizo que ocurrieran:';

  @override
  String moodReply(String mood) {
    String _temp0 = intl.Intl.selectLogic(mood, {
      '1': 'Los días difíciles ocurren. Hoy no tienes que compensar nada.',
      '2': 'Un día más flojo también está bien. Basta un paso pequeño.',
      '3': 'Un día corriente también cuenta.',
      '4': 'Da gusto saberlo.',
      'other': 'Precioso. Vale la pena recordar qué lo hizo posible.',
    });
    return '$_temp0';
  }

  @override
  String get reminderAsk =>
      '¿Quieres que la carta del día te espere cada mañana?';

  @override
  String get reminderAskSub =>
      'Una notificación al día a las 8:00, con el contenido del día. Puedes cambiar la hora o desactivarla en Ajustes.';

  @override
  String get reminderYes => 'Sí, recuérdamelo';

  @override
  String get reminderNo => 'No, gracias';

  @override
  String get onboardBirthHint =>
      'Opcional. Con la fecha verás enseguida tu signo, tu horóscopo y tus números.';

  @override
  String get lookBack => 'Tus días';

  @override
  String get lookBackHint =>
      'Cartas del día y ánimo, día a día. Guardado solo en este dispositivo.';
}
