# Rzeczywiście wykonane testy

Uruchomienie: `flutter test` (Flutter stable, Dart 3.13.7, macOS).

## 2026-11-10 — etap 1 (MVP offline)

| Zakres | Plik | Wynik |
|---|---|---|
| Silnik numerologii vs niezależna wyrocznia w Pythonie (13 dat, 7 imion), daty nieistniejące/przestępne, Ł, separatory, nieobsługiwane znaki, brak samogłosek, różnica szkół, ślad | `test/numerology_test.dart` | 26/26 ✅ |
| Talia 78 kart, brak powtórzeń w rozkładzie, odwrócenia wyłączone, powtarzalność z ziarnem, jednorodność (chi² < 117,6 przy df=77) i ~50% odwróceń | `test/tarot_test.dart` | 5/5 ✅ |
| Spójność treści (78 kart = id silnika, brak duplikatów tekstów, interpretacja dla każdej osiągalnej liczby każdego wskaźnika, ≥30 pytań, ≥10 rodzinnych, 12 archetypów); magazyn: karta dnia po „restarcie” i zmianie daty, dziennik dodaj/edytuj/eksport/usuń z wersjami, usunięcie wszystkich danych, odwrócenia domyślnie off | `test/content_store_test.dart` | 8/8 ✅ |
| Widgety: onboarding bez rejestracji → Dzisiaj; obliczenie z samej daty z krokami; błędna data i znak „ü”; rozkład 3 kart + zapis refleksji; wyszukiwarka biblioteki; ciemny motyw + tekst 2× bez przepełnień | `test/app_flow_test.dart` | 6/6 ✅ |

Razem: **45/45** zaliczone. `flutter analyze`: brak uwag.

Testy UI wykryły i pomogły naprawić 2 realne błędy układu (przepełnienie wiersza wyboru roku, przepełnienie awersu karty przy 2× tekście).

Ręcznie: zbudowano `flutter build web --release`, uruchomiono w Chrome (headless), zrzut ekranu Dzisiaj — renderuje się poprawnie po polsku w ciemnym motywie.

## Czego NIE przetestowano

- Brak uruchomienia na Androidzie (brak Android SDK/Java) i na iOS (brak symulatora iOS 27.2 i CocoaPods).
- Brak testu z prawdziwym czytnikiem ekranu (TalkBack/VoiceOver) — są tylko etykiety semantyczne.
- Eksport dziennika (`share_plus`) nie był uruchomiony na urządzeniu.
- (etap 1) Reklamy, zakupy, przypomnienia — wtedy nie zaimplementowane; patrz etap 2.

## 2026-11-10 — etap 2 (Pro, reklamy, grafiki, przypomnienia) + niezależny przegląd

`flutter test`: **56/56** ✅, `flutter analyze`: brak uwag.

Nowe testy: grafika i proweniencja dla każdej z 78 kart (plik, SHA-1, licencja); blokada rozkładów Pro i odblokowanie dla Pro (widget); „Usuń wszystkie dane” zachowuje Pro; regresje z przeglądu — NFD (`e`+U+0328), twarda spacja, U+2011, U+2019, odrzucenie `ſ`/`ı`/`ß`, emoji raportowane w całości, walidacja daty niezależna od strefy (2011-12-30, Pacific/Apia), rok > 9999; uszkodzony JSON dziennika (kwarantanna + eksport), jeden zły wpis nie blokuje pozostałych, uszkodzona karta dnia losowana ponownie, unikalne id przy równoczesnym zapisie; zapis profilu z błędną/przyszłą datą nie nadpisuje starej (widget).

Niezależny przegląd kodu (osobny agent, bez dostępu do zapisu) zgłosił 12 problemów — wszystkie poprawione w commicie `0d675ac`.

### Buildy i urządzenia
- `flutter build ios --no-codesign --release` ✅ (33 MB, zależności przez Swift Package Manager).
- `flutter build appbundle/apk --release` ✅ (targetSdk 36, compileSdk 37).
- **Emulator Android 16 (API 36, arm64, Google Play image):** aplikacja **padała przy starcie** w wydaniu release — R8 usuwał `androidx.work.impl.WorkDatabase_Impl` (WorkManager z SDK reklam). Dodano `android/app/proguard-rules.pro`; po poprawce `apkanalyzer` potwierdza obecność klasy i konstruktora w APK. **Ponowne uruchomienie na emulatorze po poprawce nie zostało wykonane** (emulator zatrzymany z powodu braku miejsca na dysku).

### Nadal nieprzetestowane
- Uruchomienie po poprawce R8 na emulatorze/urządzeniu; iOS na symulatorze (brak runtime iOS 27.2) i urządzeniu.
- Prawdziwy zakup/przywracanie (wymaga kont sandbox), formularz UMP i baner testowy na urządzeniu, ATT, powiadomienia (uprawnienie, dostarczenie, restart urządzenia).
- TalkBack/VoiceOver.
