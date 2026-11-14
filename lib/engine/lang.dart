/// Languages with complete content, in Settings order. Only these can be picked or
/// followed from the phone; a language joins here once its UI and content are done.
const appLangs = ['pl', 'en', 'de', 'fr', 'es', 'uk', 'it', 'pt', 'nl'];

/// Each language's own name, as shown in the picker.
const langNames = {
  'pl': 'Polski',
  'en': 'English',
  'de': 'Deutsch',
  'fr': 'Français',
  'es': 'Español',
  'uk': 'Українська',
  'it': 'Italiano',
  'pt': 'Português',
  'nl': 'Nederlands',
};

/// [setting] is 'system' or a language code; [phone] lists the phone's preferred
/// language codes in order. 'system' takes the first preferred language the app has;
/// otherwise English (the most widely understood), then the first available.
String resolveLanguage(
  String setting,
  List<String> phone,
  Iterable<String> available,
) {
  final wanted = setting == 'system' ? phone : [setting];
  for (final code in wanted) {
    if (available.contains(code)) return code;
  }
  return available.contains('en') ? 'en' : available.first;
}

/// Language of texts built outside the widget tree: calculation traces, spread names,
/// place names. Set from the app's resolved language.
var appLang = 'pl';

/// Picks the text for [appLang]. A language without its own text falls back to English.
String tr({
  required String pl,
  required String en,
  String? de,
  String? fr,
  String? es,
  String? uk,
  String? it,
  String? pt,
  String? nl,
}) => switch (appLang) {
  'pl' => pl,
  'de' => de ?? en,
  'fr' => fr ?? en,
  'es' => es ?? en,
  'uk' => uk ?? en,
  'it' => it ?? en,
  'pt' => pt ?? en,
  'nl' => nl ?? en,
  _ => en,
};

/// [byLang] in the app's language, or its English entry.
T inLang<T>(Map<String, T> byLang) => byLang[appLang] ?? byLang['en'] as T;

extension MidSentence on String {
  /// A name used inside a sentence ("Moon in Leo, full moon"). German keeps the
  /// capital, since all its nouns are capitalised ("Vollmond").
  String get midSentence => appLang == 'de' ? this : toLowerCase();
}
