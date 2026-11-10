# Stan prac — punkt powrotu

Ostatnia aktualizacja: 2026-11-10 (popołudnie). **Zmiany niezacommitowane** — patrz „Do zrobienia przy commicie”.

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
- Testy: `flutter test` 83/83; obliczenia astronomiczne sprawdzone z PyEphem (fixtures w `test/fixtures/`).

## Do zrobienia przy commicie
- **Nie commitować** `ios/Runner.xcodeproj/project.pbxproj` (demo: bundle `com.digiwitch.app.demo`, Team `2B3TYZXZA8`) — przywrócić `git checkout` przed buildem do sklepu.
- Demo na iPhonie (darmowe Apple ID) wygasa po 7 dniach: `flutter build ios --release` + `xcrun devicectl device install app --device 00008150-000965A902F2401C build/ios/iphoneos/Runner.app`.

## Następne kroki (kolejność sugerowana)
1. **Właściciel:** konta Apple Developer, Google Play Console, AdMob → `docs/launch-checklist.md`.
2. Podpis release Androida (keystore poza repo, `key.properties` w `.gitignore`) — obecnie podpis debug.
3. Prawdziwe ID AdMob przy buildzie (`--dart-define=ADMOB_BANNER_ANDROID=…`, `-PADMOB_APP_ID_ANDROID=…`, iOS `Info.plist`).
4. Produkt `pro_lifetime` w obu sklepach → test sandbox zakupu/przywracania.
5. iOS: zainstalować runtime symulatora iOS 27.2 (Xcode → Settings → Components) → test na symulatorze, Privacy Report.
6. Korekta treści przez człowieka — w tym nowe: rady kart, `astro.json`, `dreams.json`, liczba dnia/relacji (`docs/content-sources.md`), polityka prywatności pod digi-witch.com/prywatnosc (`docs/privacy-policy-draft.md`), decyzja DSA (przedsiębiorca).

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
`docs/decisions.md` (decyzje 1–19), `docs/testing.md`, `docs/launch-checklist.md`, `docs/content-sources.md`, `docs/numerology-method.md`, `docs/research/`.
