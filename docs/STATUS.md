# Stan prac — punkt powrotu

Ostatnia aktualizacja: 2026-11-17. Wszystko zacommitowane na gałęzi `fix/delete-all-data`; przed kolejnym commitem patrz „Do zrobienia przy commicie”.

## 2026-11-17 — zmiana dnia, karta Pro na widżetach (zacznij tutaj)

- Nowy dzień wszędzie bez restartu: aplikacja sprawdza datę co minutę i przy powrocie z tła, przebudowuje ekrany, wysyła widżetom nowy tydzień i planuje od nowa przypomnienia (`_checkDay`, `_syncWidget` w `lib/main.dart`). Numerologia przelicza rok i miesiąc osobisty po zmianie miesiąca.
- Widżety: Android odświeża się o północy (`MidnightReceiver`, okno do 10 min) i po zmianie strefy/zegara; iOS ma linię czasu z wpisami o północy.
- Pro: karta dnia od razu na widżetach (karty na 7 dni losowane z góry, `cardAhead` w `lib/data/store.dart`), w aplikacji obraca się sama przy pierwszym wejściu na Dziś i trafia do „Twoich dni”. Obrazki kart widżety czytają z plików aplikacji.
- Kalendarz przy polach daty urodzenia (`datePickerButton`), bo na iPadzie z klawiaturą sprzętową nie ma klawiatury ekranowej.
- Sprawdzone na emulatorze Androida (zmiana dnia przez strefę czasową: tło, aplikacja na ekranie, widżet). Nie sprawdzone: przejście przez prawdziwą północ na iPhonie/iPadzie, widżety iOS po zmianie strefy. Testy 164/164.
- iPad Pro 11 zarejestrowany w profilu demo (build przez `xcodebuild -allowProvisioningDeviceRegistration`).

## Przegląd przed wysyłką do sklepów — 2026-11-15

Zrobione: polityka prywatności z danymi administratora (Mobileo Sławomir Moskal) w `docs/privacy-policy-draft.md` i jako strona `site/prywatnosc/index.html` (PL + EN, link w stopce strony); link „Polityka prywatności” w Ustawieniach (`url_launcher`); iOS: `ios/Runner/PrivacyInfo.xcprivacy` i komunikat o śledzeniu w 9 językach (`ios/Runner/*.lproj/InfoPlist.strings`, dodane przez `tool/ios_project.rb appfiles`); notatki dla recenzenta i teksty karty sklepu PL/EN w `docs/review-notes.md`. Sprawdzone: ekran startowy na symulatorze iPada Pro 11; na emulatorze Androida (release) widżet „Dziś dla Ciebie” działa i zmienia język z aplikacją, wszystkie pięć widżetów jest w wyborze widżetów (pozostałe cztery nie były kładzione na ekran).

Zostaje właścicielowi: wgrać `site/` na serwer (bez tego link do polityki w aplikacji prowadzi donikąd); prawdziwe ID AdMob; produkt `pro_lifetime` + test sandbox; keystore Androida; `ios_project.rb store` + zespół z płatnego konta; konta, DSA, formularze. Pierwsze wydanie tylko w Polsce, dopóki tłumaczeń nie przejrzy native speaker. Nazwy i opisy widżetów Androida są tylko po polsku (`res/values/strings.xml`).

## Stan na koniec sesji 2026-11-12

**Nic z tej sesji nie jest zacommitowane** (ostatni commit `1a83d70`, gałąź `feature/astro-and-ui`). Przed commitem patrz „Do zrobienia przy commicie”. Testy: `flutter test` 142/142, `flutter analyze` czysto. Na obu iPhone'ach (17 Pro Max i Duo) jest wersja demo z końca sesji.

Zrobione w tej sesji (decyzje 44–49 w `docs/decisions.md`):
- **iPhone Duo:** natywne zakładki iOS w systemowym pasku pionowym + przycisk wstecz (`ios/Runner/SceneDelegate.swift`, `lib/native_tabs.dart`).
- **Przekaz dnia:** 180 zdań na język w sześciu rodzajach (`assets/content/**/messages.json`), klucz oparty na badaniach (`docs/content-sources.md`), kolejność bez powtórek (`messageIndex`, `messagePattern` w `lib/engine/daily.dart`). Karta na górze Dziś i Gwiazd: gdy odczyt ma dobrą wiadomość, prowadzi ona, inaczej prowadzi zdanie (`dayGreeting`, `DayMessage` w `lib/ui/astro_screens.dart`).
- **Dziś:** trzy przyciski Horoskop / Moje liczby / Karta, większe odstępy i tekst 16 pt w całej aplikacji; w niedzielę przycisk „Zapisz trzy dobre rzeczy”.
- **Widżety:** Miłość/Praca/Energia w „Dziś dla Ciebie”; dwa duże: „Twój dzień” i „Dobra myśl” (iOS + Android).
- **Strona www** w `site/` (jedna strona, 6 języków, digi-witch.com, support@digi-witch.com): telefon zgodny z aplikacją (znak Waga), ikony wektorowe, ikony sklepów. Właściciel opublikował ją sam; **ostatnia poprawka proporcji kart (`.tarot img`) czeka na ponowne wgranie na serwer.**
- **Przegląd praw:** grafiki, czcionka, biblioteki i teksty w porządku; rejestry znaków (TMview, USPTO) bez „Digi Witch”/„DigiWitch”; thedigiwitch.com nie działa (domena zajęta do 2027-05). Szczegóły w `docs/content-sources.md`.
- **Rynek:** start w Europie; Indie tylko jako nisza po angielsku (inny system astrologii, brak hindi, obciążone słowo „witch”).

Czeka na właściciela:
1. Sprawdzenie na telefonach: Duo rozłożony, dotknięcia zakładek i przycisk wstecz, duże widżety, przycisk „Trzy dobre rzeczy” (tylko w niedzielę).
2. Przeczytanie 180 polskich zdań przekazu; pozostałe języki do native speakera; listę warto pokazać psychologowi.
3. Akceptacja polskich tekstów odczytu dnia (`daily.json`) → potem tłumaczenie na en/de/fr/es/uk.
4. Decyzja o commicie.

Odłożone / do rozważenia:
- Wybór rodzajów zdań w Ustawieniach („Co Ci pomaga?”).
- Nazwy heksagramów I Ching w językach innych niż angielski porównać z wydanymi przekładami (angielskie są własne od 2026-11-15).
- Strona: oficjalne plakietki sklepów już są (`site/assets/badges/`, decyzja właściciela 2026-11-15, na razie bez linków, z napisem „Wkrótce w”); po publikacji aplikacji podpiąć linki do sklepów i usunąć „Wkrótce w”. Dalej: polityka prywatności, dane właściciela (dla wersji niemieckiej Impressum); usunąć nieużywane teksty starej makiety w `site/index.html`.
- UPRP i indyjski rejestr znaków nie były sprawdzane osobno.
- Android: nowe widżety i zmiany tylko skompilowane, nie uruchamiane.
- Na Duo: druga strzałka wstecz w aplikacji, brak czerwonej kropki przy „Dziś” w natywnych zakładkach.

Pomocnicze skrypty z sesji były w katalogu tymczasowym i nie są zachowane (zrzuty z symulatora z pominięciem wprowadzenia: tymczasowa zmiana `onboarded`/`birthDate` w `lib/data/store.dart` i startowej zakładki w `lib/main.dart`, zawsze przywracana).

## Gotowe
- Aplikacja Flutter (Android + iOS): numerologia (`pl-pyth-1`, ślad obliczeń), tarot 78 kart (1/3/5 + 2 rozkłady Pro), karta dnia, biblioteka (wyszukiwarka, zakładki, słownik, artykuły, 12 archetypów), dziennik (33 pytania, 14 rodzinnych, eksport, usuwanie), ustawienia, przypomnienia (domyślnie off).
- Pro `pro_lifetime` 24,99 zł (kod IAP gotowy, produkt jeszcze nie istnieje w sklepach), baner AdMob z UMP — **na testowych ID**.
- Grafiki RWS 1909 z Commons (PD, SHA-1 w `assets/cards/manifest.json`), własna ikona.
- Testy: `flutter test` 56/56, `flutter analyze` czysto; emulator Android 16 release — przetestowany (szczegóły `docs/testing.md`).

## Dodane 2026-11-10 (po południu)
- Pytanie do kart + odpowiedź z reguł i rad kart (bez AI), rozkład Tak/Nie.
- Horoskop dnia (znak × Księżyc × liczba dnia), szczęśliwe liczby, Księżyc dziś + kalendarz (fazy, dzień po dniu, ogród/strzyżenie, Merkury wsteczny).
- Wielka trójka (Słońce, Księżyc, ascendent; godzina + miasto w PL), horoskop chiński (żywioł, yin/yang, rok, zgodność), zgodność dwóch osób, karta urodzenia, sennik (144), artykuł o powtarzających się liczbach.
- Nowy wygląd: paleta z ikony, Cormorant Garamond, ramka „karta tarota”, pływający pasek (na iOS imitacja Liquid Glass), ekran Tarota z talią i odsłanianiem kart.
- Później: miejsca urodzenia na świecie (229 + własne współrzędne), Dziś jako centrum (data od razu, kafelki „Odkrywaj”), Liczby z profilem; kwadrat Pitagorasa, cykle życia, I Ching, rytuały nowiu/pełni (powiadomienia), tranzyty osobiste.
- Potem: miesiąc osobisty, dojrzałość, karma, numer domu, zaćmienia, horoskop tygodniowy/miesięczny, rozkłady Decyzja/Miesiąc/Rok, dłuższe opisy, 384 linie I Ching.
- Codzienny rytuał: karta dnia do odsłonięcia + nastrój, odliczania (pełnia, nów, zaćmienie, Merkury, urodziny), przypomnienie z treścią dnia (plan: `docs/engagement-plan.md`; następny: widżet).
- Nowy układ zakładek: Gwiazdy · Wróżby · [Dziś] · Liczby · Dziennik, Biblioteka pod lupą; Dziś uporządkowane „na jedno spojrzenie” (decyzja 32). Następne: iPhone Duo (układy szerokie, dwie kolumny, boczna nawigacja).
- Dziś na jednym ekranie: powitanie, ramka przesuwana w bok (Horoskop → Moje liczby → Karta), „Na dziś gotowe” + zapowiedź jutra; poprawiona reklama i przycisk Dziennika (decyzja 33).
- Zakładka Sny zamiast Dziennika (Dziennik pod ikoną w górnym pasku), nowy środkowy przycisk „Dziś” (decyzja 34).
- Szerokie okna (iPhone Duo: boczna szyna, dwie kolumny na Dziś) i widżet „Twój dzień” na Androida i iOS (decyzje 35–36).
- Trzy widżety: Dziś dla Ciebie, Karta dnia, Księżyc — każdy otwiera swoje miejsce w aplikacji (decyzja 37).
- Języki: polski, angielski, niemiecki, francuski, hiszpański, ukraiński — wszystkie pełne (decyzje 38–41); włoski, portugalski (BR) i holenderski podpięci w decyzji 60 (szkic maszynowy, do przeglądu native speakera). Język telefonu ustawia język aplikacji (iOS `CFBundleLocalizations`, Android `locales_config.xml`, decyzja 40). Przed publikacją: przegląd każdego języka przez native speakera, opisy w sklepach i polityka prywatności w tych językach. Testy: 138/138 (liczba po dodaniu it/pt/nl — do uzupełnienia po uruchomieniu).
- Nowe „Dziś” i zakładka Tarot (decyzje 42–43). Osobisty odczyt dnia jest tylko po polsku (`assets/content/daily.json`, 178 tekstów). Czeka na akceptację tekstów przez właściciela; potem tłumaczenie na en/de/fr/es/uk (`tool/l10n/daily_<lang>/` + `python3 tool/l10n/daily.py . <lang>` + wpis `assets/content/<lang>/daily.json` jest już objęty katalogiem w `pubspec.yaml`).
- 2026-11-12 (decyzje 44–48): natywne zakładki na iPhonie Duo, nowa kolejność horoskopu i szczęśliwe liczby, przekaz dnia + hasło dnia (Dziś, Gwiazdy, widżety), dwa duże widżety, strona www w `site/`. Do sprawdzenia przez właściciela na telefonach: Duo rozłożony, przycisk wstecz, duże widżety; teksty przekazu (`messages.json`) do akceptacji.
- Testy: `flutter test` 152/152 (stan 2026-11-14, po dodaniu włoskiego, portugalskiego i holenderskiego); obliczenia astronomiczne sprawdzone z PyEphem (fixtures w `test/fixtures/`).

## Języki it / pt / nl — do zrobienia przed publikacją (2026-11-14)
- Przegląd native speakera dla włoskiego, portugalskiego (BR) i holenderskiego (też dla pięciu starszych języków): teksty to szkice modelu. Szczególnie: przekazy dnia (`messages.json`), I Ching, tarot, numerologia, formy rodzaju w włoskim (np. „sei fiero”), nazwy miast ukraińskich w zapisie łacińskim.
- Numery pomocy sprawdzić na oficjalnych stronach (sprawdzone tylko wyszukiwaniem, źródła pośrednie): telefonoamico.it (02 2327 2327), cvv.org.br (188), 113.nl (113 / 0800-0113).
- Przekazy dnia w en/de/fr/es/uk są jeszcze STARE (inny komplet niż polski); tłumaczyć nowy polski komplet po akceptacji polskich zdań.
- Opisy w sklepach, polityka prywatności i `daily.json` (odczyt dnia) — dla it/pt/nl jeszcze nie ma (jak dla pozostałych języków poza polskim).

## Do zrobienia przy commicie
- `ios/Runner.xcodeproj/project.pbxproj` zawiera teraz cel widżetu **i** wartości demo. Przed commitem: `GEM_HOME=/opt/homebrew/Cellar/cocoapods/1.17.0_1/libexec ruby tool/ios_project.rb store` (bundle `com.digiwitch.app`, bez Team ID), commit, potem `… ios_project.rb demo 2B3TYZXZA8`.
- Ważność obliczeń: elementy Merkurego 1800–2050 (odświeżyć przed 2050); Chiński Nowy Rok bez miesięcy przestępnych 11/12 — najbliższy przypadek 2033.
- Demo na iPhonie (darmowe Apple ID) wygasa po 7 dniach: `flutter build ios --release --dart-define=APP_GROUP=group.com.digiwitch.app.demo --dart-define=DEMO_PRO=true` (DEMO_PRO = wersja testowa jak Pro: bez reklam i okna zgody; nigdy w buildzie do sklepu) + `xcrun devicectl device install app --device 00008150-000965A902F2401C build/ios/iphoneos/Runner.app`. Bez `--dart-define` widżet iOS w wersji demo nie dostanie danych.

## Następne kroki (kolejność sugerowana)
1. **Właściciel:** konta Apple Developer, Google Play Console, AdMob → `docs/launch-checklist.md`.
2. Podpis release Androida (keystore poza repo, `key.properties` w `.gitignore`) — obecnie podpis debug.
3. Prawdziwe ID AdMob przy buildzie (`--dart-define=ADMOB_BANNER_ANDROID=…`, `-PADMOB_APP_ID_ANDROID=…`, iOS `Info.plist`).
4. Produkt `pro_lifetime` w obu sklepach → test sandbox zakupu/przywracania.
5. iOS: zainstalować runtime symulatora iOS 27.2 (Xcode → Settings → Components) → test na symulatorze, Privacy Report.
6. Korekta tłumaczenia angielskiego przez native speakera; angielska polityka prywatności i opisy w sklepach.
7. Korekta treści przez człowieka — w tym nowe: rady kart, `astro.json`, `dreams.json`, `iching.json`, `numerology_extra.json`, nowe wskaźniki w `numerology.json` (`docs/content-sources.md`), polityka prywatności pod digi-witch.com/prywatnosc (`docs/privacy-policy-draft.md`), decyzja DSA (przedsiębiorca).

## Środowisko
```sh
export PATH=$HOME/development/flutter/bin:$PATH
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
flutter test && flutter analyze
# emulator (AVD dw_test):
~/Library/Android/sdk/emulator/emulator -avd dw_test -gpu host &
flutter build apk --release && adb install -r build/app/outputs/flutter-apk/app-release.apk
adb emu kill   # zatrzymanie
```
Uwaga: na dysku ~33 GB wolnego; build Androida + emulator zajmują kilka GB (`flutter clean` zwalnia).

## Dokumenty
`docs/decisions.md` (decyzje 1–62), `docs/testing.md`, `docs/launch-checklist.md`, `docs/content-sources.md`, `docs/numerology-method.md`, `docs/research/`.
